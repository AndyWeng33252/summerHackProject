//
//  CategoryViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/27/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: UIViewController!
    var categoryText: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryName.text = categoryText
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
