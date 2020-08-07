//
//  albumCell.swift
//  FetchDesign
//
//  Created by Andy Weng on 8/4/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit
import FirebaseStorage

class albumCell: UICollectionViewCell {
    
    let storage = Storage.storage()
    
    @IBOutlet weak var photo: UIImageView!

    func configCell(imageURL: String){
        let httpRef = storage.reference(forURL: imageURL)
        // Download in memory with a maximum allowed size of 1MB (1 * 1024 * 1024 bytes)
        httpRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
          if let error = error {
            return
          } else {
            self.photo.image = UIImage(data: data!)
          }
        }
    }
}
