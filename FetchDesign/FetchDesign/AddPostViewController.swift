//
//  AddPostViewController.swift
//  FetchDesign
//
//  Created by Andy Weng on 8/2/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class AddPostViewController: UIViewController {

    let ref = Database.database().reference()
    // Create a storage reference from our storage service
    var postImage: UIImage!
    var postImageURL: String!
    let UserID = Auth.auth().currentUser!.uid
    
    @IBOutlet weak var postPicture: UIImageView!
 
    @IBOutlet weak var postText: UITextField!
    
    override func viewDidLoad() {
         super.viewDidLoad()
         
         // Do any additional setup after loading the view.
     }
     override func viewDidAppear(_ animated: Bool) {
         if let image = postImage{
             postPicture.image = image
         }
     }
    
    @IBAction func createPost(_ sender: Any) {
        if postPicture.image != nil && postText != nil {
            ref.child("users").child(self.UserID).child("Posts").observeSingleEvent(of:.value, with: {(snapshot)
                in
                self.ref.child("users").child(self.UserID).child("Posts").child("post\(snapshot.childrenCount)").updateChildValues(["Text": self.postText.text, "Image": self.postImageURL, "Likes": 0])
                self.dismiss(animated: true, completion: nil)
            })
        }
        else {
             popUnimplementedAlert(message: "Insert a Picture")
        }
     }
    
    // code to enable tapping on the background to remove software keyboard
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func popUnimplementedAlert(message:String) {
        let controller = UIAlertController(
            title: "Attention",
            message: message,
            preferredStyle: .alert)
        
        controller.addAction(UIAlertAction(title: "OK", style: .default, handler: nil))
        present(controller,animated:true,completion:nil)
    }
    
    @IBAction func unwindToPostController(segue: UIStoryboardSegue) {
    }
}
