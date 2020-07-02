//
//  LoginViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/27/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import Firebase

class LoginViewController: UIViewController {

    @IBOutlet weak var loginButton: UIButton!
    @IBOutlet weak var createAccount: UIButton!
    @IBOutlet weak var forgotPassword: UIButton!
    @IBOutlet weak var passwordSecureButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var createAccountSegueIdentifier = "CreateAccountSegue"
    var loginSegueSegueIdentifier = "LoginSegue"
    var forgotPasswordSegueSegueIdentifier = "ForgotPasswordSegue"
    
    var UserID: String = ""
    var isPasswordSecure = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        passwordTextField.isSecureTextEntry = true
    }
    
    @IBAction func loginPressed(_ sender: Any) {
        guard let email = emailTextField.text,
            let password = passwordTextField.text,
            email.count > 0,
            password.count > 0
        else {
            popUnimplementedAlert(message: "Email or password can't be empty")
            return
        }
        Auth.auth().signIn(withEmail: email, password: password) {
            user, error in
            if let _ = error, user == nil {
                self.popUnimplementedAlert(message: "Please check to make sure you used the right e-mail address and password")
            } else {
                self.UserID = Auth.auth().currentUser!.uid
                self.performSegue(withIdentifier: "LoginSegue", sender: nil)
            }
        }
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        if let nextVC = segue.destination as? MainTabBarController {
            nextVC.modalPresentationStyle = .fullScreen
        }
    }
    
    func popUnimplementedAlert(message:String) {
        let controller = UIAlertController(
            title: "Attention",
            message: message,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller,animated:true,completion:nil)
    }

}
