//
//  CategoryDetailsViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 7/9/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CategoryDetailsViewController: UIViewController {

    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var furnitureNameLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var colorLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var cameraButton: UIButton!
    
    var delegate: UIViewController!
    var furnitureName = String()
    var category = String()
    var color = String()
    var size = String()
    var image = UIImage()
    
    let furnitureCameraSugueIdentifier = "FurnitureCameraSugue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        imageView.image = image
        furnitureNameLabel.text = furnitureName
        categoryLabel.text = category
        colorLabel.text = "Color: " + color
        colorLabel.adjustsFontSizeToFitWidth = true
        sizeLabel.text = "Size: " + size
        sizeLabel.adjustsFontSizeToFitWidth = true
        
        
    }
    
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
