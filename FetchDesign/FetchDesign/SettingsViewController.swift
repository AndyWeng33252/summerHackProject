//
//  SettingsViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/27/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
