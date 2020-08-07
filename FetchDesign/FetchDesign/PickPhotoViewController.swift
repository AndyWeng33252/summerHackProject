//
//  PickPhotoViewController.swift
//  FetchDesign
//
//  Created by Andy Weng on 8/5/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import FirebaseAuth

class PickPhotoViewController: UIViewController {
    
    let UserID = Auth.auth().currentUser!.uid
    let dataRef = Database.database().reference()
    let storage = Storage.storage()
    @IBOutlet weak var collectionView: UICollectionView!
    var photoArray = [String]()
    var selectedImage: UIImage!
    var selectedImageURL: String!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        getPhotoUpdate()
        collectionView.delegate = self
        collectionView.dataSource = self
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func getPhotoUpdate() {
        
        dataRef.child("users").child(UserID).child("images").observe(.value, with:{(snapshot) in
                for child in snapshot.children {
                    self.photoArray.append((child as! DataSnapshot).value as! String)
                }
            self.collectionView.reloadData()
        })
    }
    
    /*
    // MARK: - Navigation
    // In a storyboard-based application, you will often want to do a little preparation before navigation
        override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    // Get the new view controller using segue.destination.
    // Pass the selected object to the new view controller.
    }
    */
}

extension PickPhotoViewController:UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        storage.reference(forURL: photoArray[indexPath.item]).getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            return
          } else {
            self.selectedImage = UIImage(data: data!)
            self.selectedImageURL = self.photoArray[indexPath.item]
            self.performSegue(withIdentifier: "goBackToPost", sender: nil)
          }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? AddPostViewController {
            vc.postImage = self.selectedImage
            vc.postImageURL = self.selectedImageURL
        }
        
    }
    
        
}

extension PickPhotoViewController:UICollectionViewDataSource {
        
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "albumCell", for: indexPath) as! albumCell
            cell.configCell(imageURL: photoArray[indexPath.item])
        
        return cell
    }
        
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        photoArray.count
    }
}
