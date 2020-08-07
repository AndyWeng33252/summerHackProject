//
//  ViewImageViewController.swift
//  FetchDesign
//
//  Created by Andy Weng on 8/5/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import FirebaseStorage

class ViewImageViewController: UIViewController {

    @IBOutlet weak var image: UIImageView!
    var imageURL: String!
    override func viewDidLoad() {
        super.viewDidLoad()
        guard (imageURL != nil) else {
            return
        }
        Storage.storage().reference(forURL: imageURL).getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            return
          } else {
            self.image.image = UIImage(data: data!)
          }
        }
        // Do any additional setup after loading the view.
    }

    @IBAction func back(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}
