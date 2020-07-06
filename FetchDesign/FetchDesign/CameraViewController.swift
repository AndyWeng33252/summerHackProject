//
//  CameraViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/26/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import ARKit
import SceneKit

class CameraViewController: UIViewController {

    @IBOutlet weak var arView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configuration.planeDetection = [.horizontal, .vertical]
        configuration.environmentTexturing = .automatic
        self.arView.session.run(configuration)
        
        arView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        arView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:))))
        // Do any additional setup after loading the view.
    }
    var currentAngleY: Float = 0.0
    var currentNode: SCNNode!
    @objc
    func rotatePiece(_ gesture: UIRotationGestureRecognizer) {   // Move the anchor point of the view's layer to the center of the
    // user's two fingers. This creates a more natural looking rotation.
        let location = gesture.location(in: self.view)
        guard let hitNodeResult = arView.hitTest(location, options: nil).first else { return }
        currentNode = hitNodeResult.node
        
        //1. Get The Current Rotation From The Gesture
        let rotation = Float(gesture.rotation)

        //2. If The Gesture State Has Changed Set The Nodes EulerAngles.y
        if gesture.state == .changed{

            currentNode.eulerAngles.y = currentAngleY + rotation
        }

        //3. If The Gesture Has Ended Store The Last Angle Of The Cube
        if(gesture.state == .ended) {
            currentAngleY = currentNode.eulerAngles.y

         }
    }
    var lastPanLocation: SCNVector3?
    // the z poisition of the dragging point
    var panStartZ: CGFloat?
    // the node being dragged
    var draggingNode: SCNNode?
    
    @objc
    func panGesture(_ gesture: UIPanGestureRecognizer) {
        let location = gesture.location(in: self.view)
        switch gesture.state {
        case .began:
            guard let hitNodeResult = arView.hitTest(location, options: nil).first else { return }
            lastPanLocation = hitNodeResult.worldCoordinates
            panStartZ = CGFloat(arView.projectPoint(lastPanLocation!).z)
            draggingNode = hitNodeResult.node
        case .changed:
            guard panStartZ != nil, draggingNode != nil else { return }

            // the touch has moved and worldTouchPosition is the new position in 3d space that the touch is at.
            // We use the panStartZ and never change it because panning should never change the z position (relative to the camera)
            // This is similar to getting the hitTest location of the gesture again,
            // but does not require the gesture to still intersect with the dragging object.
            let worldTouchPosition = arView.unprojectPoint(SCNVector3(location.x, location.y, panStartZ!))

            // The amount to move the box by is the distance between the last touch point and the new one (in 3d scene space)
            let movementVector = SCNVector3(worldTouchPosition.x - lastPanLocation!.x,
                                            worldTouchPosition.y - lastPanLocation!.y,
                                            worldTouchPosition.z - lastPanLocation!.z)
            draggingNode!.localTranslate(by: movementVector)

            self.lastPanLocation = worldTouchPosition
        case .ended:
            (panStartZ, draggingNode) = (nil, nil)

        default:
            break
    }
}
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let sceneResult = arView.hitTest(touch.location(in: arView), options: nil)
        let sceneNode = sceneResult.last?.node
        if sceneNode?.parent?.name == "sofa"{
        }
        else {
            let result = arView.hitTest(touch.location(in: arView), types: ARHitTestResult.ResultType.estimatedHorizontalPlane)
            guard let hitResult = result.last else{return}
            let hitTransform = SCNMatrix4(hitResult.worldTransform)
            let hitVector = SCNVector3(hitTransform.m41, hitTransform.m42, hitTransform.m43)
            createSofa(position: hitVector)
        }
        
    }
    
    func createSofa (position: SCNVector3){
        let sofaScene = SCNScene(named: "SceneKit.scnassets/Sofa/sofa.scn")!
        let sofaNode = SCNNode()
        sofaNode.name = "sofa"
        let sofaChildNodes = sofaScene.rootNode.childNodes
        for childNode in sofaChildNodes{
            sofaNode.addChildNode(childNode)
        }
        
        sofaNode.position = position
        arView.scene.rootNode.addChildNode(sofaNode)
    }

}

