//
//  EditPhotoViewController.swift
//  FetchDesign
//
//  Created by Andy Weng on 8/2/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class EditPhotoViewController: UIViewController {

    @IBOutlet weak var tookedPhoto: UIImageView!
    let UserID = Auth.auth().currentUser!.uid
    var imageFromCamera: UIImage!
    let storageRef = Storage.storage().reference()
    let dataRef = Database.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tookedPhoto.image = imageFromCamera
        // Do any additional setup after loading the view.
    }
    
    @IBAction func savePhoto(_ sender: Any) {

        // Create a reference to the file you want to upload
        
        //NEED TO CHANGE IMAGE REF TO THE USERS)
        var numberOfPhotos = 0
        self.dataRef.child("users").child(self.UserID).child("images").observeSingleEvent(of: .value, with: {(snapshot)
            in
            numberOfPhotos = Int(snapshot.childrenCount)
            guard let imageData = self.tookedPhoto.image!.jpegData(compressionQuality: 0.2) else { return}
            let imageRef = self.storageRef.child("users").child(self.UserID).child("image\(numberOfPhotos + 1)")
            
            // Upload the file to the path "images/rivers.jpg"
            let uploadTask = imageRef.putData(imageData, metadata: nil) { (metadata, error) in
              guard let metadata = metadata else {
                return
              }
              // Metadata contains file metadata such as size, content-type.
              let size = metadata.size
              // You can also access to download URL after upload.
              imageRef.downloadURL { (url, error) in
                guard let downloadURL = url else {
                  // Uh-oh, an error occurred!
                  return
                }
                self.dataRef.child("users").child(self.UserID).child("images").updateChildValues(["image\(numberOfPhotos + 1)":downloadURL.absoluteString])
              }
            }
            self.dismiss(animated: true, completion: nil)
        })
        
    }
    
    @IBAction func cancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

}
