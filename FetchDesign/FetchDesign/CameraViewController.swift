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

    @IBOutlet weak var sceneView: ARSCNView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var funitureCategory = String()
    var isCancel = Bool()
    
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configuration.planeDetection = .horizontal
        configuration.environmentTexturing = .automatic
        self.sceneView.session.run(configuration)
        
        sceneView.addGestureRecognizer(UIPanGestureRecognizer(target: self, action: #selector(panGesture(_:))))
        sceneView.addGestureRecognizer(UIRotationGestureRecognizer(target: self, action: #selector(rotatePiece(_:))))
        
        // cancel
        if (isCancel) {
            cancelButton.isHidden = false
        } else {
            cancelButton.isHidden = true
        }
    }
    
    // rotation
    var currentAngleY: Float = 0.0
    var currentNode: SCNNode!
    @objc
    func rotatePiece(_ gesture: UIRotationGestureRecognizer) {
        // user's two fingers. This creates a more natural looking rotation.
        let location = gesture.location(in: self.view)
        guard let hitNodeResult = sceneView.hitTest(location, options: nil).first else { return }
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
    
    // transaction
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
                guard let hitNodeResult = sceneView.hitTest(location, options: nil).first else { return }
                lastPanLocation = hitNodeResult.worldCoordinates
                panStartZ = CGFloat(sceneView.projectPoint(lastPanLocation!).z)
                draggingNode = hitNodeResult.node
            case .changed:
                guard panStartZ != nil, draggingNode != nil else { return }

                // the touch has moved and worldTouchPosition is the new position in 3d space that the touch is at.
                // We use the panStartZ and never change it because panning should never change the z position (relative to the camera)
                // This is similar to getting the hitTest location of the gesture again,
                // but does not require the gesture to still intersect with the dragging object.
                let worldTouchPosition = sceneView.unprojectPoint(SCNVector3(location.x, location.y, panStartZ!))

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
    
    // create object
    var created = false
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first else{return}
        let sceneResult = sceneView.hitTest(touch.location(in: sceneView), options: nil)
        let sceneNode = sceneResult.last?.node
        if sceneNode?.parent?.name == "sofa"{
        }
        else {
            let result = sceneView.hitTest(touch.location(in: sceneView), types: ARHitTestResult.ResultType.existingPlane)
            guard let hitResult = result.last else{return}
            let hitTransform = SCNMatrix4(hitResult.worldTransform)
            let hitVector = SCNVector3(hitTransform.m41, hitTransform.m42, hitTransform.m43)
            if (!created) {
                createFurniture(position: hitVector)
                created = true
            }
        }
        
    }
    
//    func createSofa(position: SCNVector3){
//        let sofaScene = SCNScene(named: "SceneKit.scnassets/Sofa/sofa.scn")!
//        let sofaNode = SCNNode()
//        sofaNode.name = "sofa"
//        let sofaChildNodes = sofaScene.rootNode.childNodes
//        for childNode in sofaChildNodes{
//            sofaNode.addChildNode(childNode)
//        }
//
//        //adds gravity to Sofa nodes
//        sofaNode.position = position
//        sceneView.scene.rootNode.addChildNode(sofaNode)
//    }
    
    func createFurniture(position: SCNVector3){
        var path = String()
        var name = String()
        print(funitureCategory)
        if (funitureCategory == "Sofas") {
            path = "SceneKit.scnassets/Sofa/sofa.scn"
            name = "sofa"
        } else if (funitureCategory == "Beds") {
            path = "SceneKit.scnassets/Bed/bed.scn"
            name = "sofa"
        } else if (funitureCategory == "Desks") {
            path = "SceneKit.scnassets/Desk/desk.scn"
            name = "sofa"
        } else if (funitureCategory == "Dining Tables") {
            path = "SceneKit.scnassets/Table/table.scn"
            name = "sofa"
        } else if (funitureCategory == "Armchairs") {
            path = "SceneKit.scnassets/Armchair/armchair.scn"
            name = "sofa"
        }
        let furnitureScene = SCNScene(named: path)!
        let node = SCNNode()
        node.name = name
        let childNodes = furnitureScene.rootNode.childNodes
        for childNode in childNodes {
            node.addChildNode(childNode)
        }

        //adds gravity to Sofa nodes
        node.position = position
        sceneView.scene.rootNode.addChildNode(node)
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
}

