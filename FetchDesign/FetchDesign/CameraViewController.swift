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
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        self.arView.session.run(configuration)
        //arView.delegate = self
        
        arView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        arView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:))))
    }
    
//________________________________Rotation_________________________________________________\\
    
    var currentAngleY: Float = 0.0
    var currentNode: SCNNode!
    @objc
    func rotatePiece(_ gesture: UIRotationGestureRecognizer) {
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
    
//___________________________Translation_______________________________________________________\\
    
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
                                            0,
                                            worldTouchPosition.y - lastPanLocation!.y)
            
            let boxTransform = (draggingNode?.transform)!

            // Let's make a new matrix for translation +2 along X axis
            let xTranslation = SCNMatrix4MakeTranslation(movementVector.x, movementVector.y, movementVector.z)

            // Combine the two matrices, THE ORDER MATTERS !
            // if you swap the parameters you will move it in parent's coord system
            let newTransform = SCNMatrix4Mult(xTranslation, boxTransform)

            // Allply the newly generated transform
            draggingNode?.transform = newTransform
            self.lastPanLocation = worldTouchPosition
            
        case .ended:
            (panStartZ, draggingNode) = (nil, nil)

        default:
            break
    }
}
    
//____________________________Creating Object_________________________________________________\\
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let sceneResult = arView.hitTest(touch.location(in: arView), options: nil)
        let sceneNode = sceneResult.last?.node
        if sceneNode?.parent?.name == "sofa"{
        }
        else {
            let result = arView.hitTest(touch.location(in: arView), types: ARHitTestResult.ResultType.existingPlane)
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
        
        //adds gravity to Sofa nodes
        sofaNode.position = position
        arView.scene.rootNode.addChildNode(sofaNode)
    }

}
//___________________________Plane Detection and Physics ______________________________________\\
//
//extension CameraViewController: ARSCNViewDelegate {
//    /* Method gets called every time the scene view’s session has a new
//    ARAnchor added. An ARAnchor is an object that represents a physical
//    location and orientation in 3D space.*/
//    func renderer(_ renderer: SCNSceneRenderer, didAdd node: SCNNode, for anchor: ARAnchor) {
//        guard let planeAnchor = anchor as? ARPlaneAnchor else { return }
//
//
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.z)
//        let plane = SCNPlane(width: width + 1100, height: height + 1100)
//
//        let planeNode = SCNNode(geometry: plane)
//
//
//        let x = CGFloat(planeAnchor.center.x)
//        let y = CGFloat(planeAnchor.center.y)
//        let z = CGFloat(planeAnchor.center.z)
//        planeNode.position = SCNVector3(x,y,z)
//        planeNode.eulerAngles.x = -.pi / 2
//        let planePhysicsBody = SCNPhysicsBody(type: .static, shape: nil)
//        planePhysicsBody.allowsResting = true
//        planeNode.physicsBody = planePhysicsBody
//
//        node.addChildNode(planeNode)
//    }
//
//    /* Method gets called to update the original plane's position and size */
//    func renderer(_ renderer: SCNSceneRenderer, didUpdate node: SCNNode, for anchor: ARAnchor) {
//        // 1
//        guard let planeAnchor = anchor as?  ARPlaneAnchor,
//            let planeNode = node.childNodes.first,
//            let plane = planeNode.geometry as? SCNPlane
//            else { return }
//
//        // 2
//        let width = CGFloat(planeAnchor.extent.x)
//        let height = CGFloat(planeAnchor.extent.z)
//        plane.width = width
//        plane.height = height
//
//        // 3
//        let x = CGFloat(planeAnchor.center.x)
//        let y = CGFloat(planeAnchor.center.y)
//        let z = CGFloat(planeAnchor.center.z)
//        planeNode.position = SCNVector3(x, y, z)
//    }
// }
