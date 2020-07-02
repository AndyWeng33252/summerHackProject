//
//  CreateAccountViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 7/1/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSecureButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var isPasswordSecure = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func passwordSecurePressed(_ sender: Any) {
        if (isPasswordSecure) {
            passwordSecureButton.setImage(UIImage(named: "closedEye"), for: .normal)
            passwordTextField.isSecureTextEntry = false
            isPasswordSecure = false
        } else {
            passwordSecureButton.setImage(UIImage(named: "eye"), for: .normal)
            passwordTextField.isSecureTextEntry = true
            isPasswordSecure = true
        }
    }
    
    @IBAction func createPressed(_ sender: Any) {
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
