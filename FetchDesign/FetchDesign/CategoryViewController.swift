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
    
    var delegate: UIViewController!
    var categoryText: String = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryName.text = categoryText
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
