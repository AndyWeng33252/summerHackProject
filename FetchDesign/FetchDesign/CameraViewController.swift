//
//  CameraViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/26/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import ARKit

class CameraViewController: UIViewController {

    @IBOutlet weak var sceneView: ARSCNView!
    let configuration = ARWorldTrackingConfiguration()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.sceneView.debugOptions = [ARSCNDebugOptions.showFeaturePoints,
                                       ARSCNDebugOptions.showWorldOrigin]
        self.sceneView.session.run(configuration)
        // Do any additional setup after loading the view.
    }


}

