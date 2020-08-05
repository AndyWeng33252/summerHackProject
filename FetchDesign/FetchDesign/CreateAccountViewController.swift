//
//  CreateAccountViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 7/1/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class CreateAccountViewController: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var passwordSecureButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var isPasswordSecure = true
    var ref: DatabaseReference!
    var createAccountMainSegueIdentifier = "CreateAccountMainSegue"
    
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
        guard let newEmail = emailTextField.text,
            let newPassword = passwordTextField.text,
            newEmail.count > 0,
            newPassword.count > 0
            else {
                let alert = UIAlertController(
                    title: "Attention",
                    message: "Please enter a valid email or password.",
                    preferredStyle: .alert)
                
                alert.addAction(UIAlertAction(title:"OK",style:.default))
                self.present(alert, animated: true, completion: nil)
                return
        }
        
        Auth.auth().createUser(withEmail: emailTextField.text!, password: passwordTextField.text!)
        { user, error in
            if error == nil {
                Auth.auth().signIn(withEmail: self.emailTextField.text!, password: self.passwordTextField.text!)
                UserID = Auth.auth().currentUser!.uid
                self.addInfoToDatabase(username: self.usernameTextField.text ?? "new user")
            }else {
                self.popUpUnimplementedAlert(message: error!.localizedDescription)
            }
        }
        
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func addInfoToDatabase(username: String){
        ref = Database.database().reference()
        let path = "users/" + UserID
        let val = ["displayName": username, "email": emailTextField.text!] as [String : Any]
        
        ref.child(path).setValue(val) { (error, ref) in
            if (error == nil) {
                self.performSegue(withIdentifier: self.createAccountMainSegueIdentifier, sender: self)
            } else {
                self.popUpUnimplementedAlert(message: "Unable to update database, please contact our team.")
                
            }
        }
        
    }
    
    func popUpUnimplementedAlert(message:String) {
        let controller = UIAlertController(
            title: "Attention",
            message: message,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller,animated:true,completion:nil)
    }

}
