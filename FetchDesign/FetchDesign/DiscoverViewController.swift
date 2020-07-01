//
//  DiscoverViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/26/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class DiscoverViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    

    @IBOutlet weak var searchTextField: UITextField!
    @IBOutlet weak var collectionView: UICollectionView!
    
    var imageList: [UIImage] = []
    var categoryList: [String] = ["Sofas", "Beds", "Desks", "Dining Tables", "Armchairs", "View All"]
    let categoryCollectionViewCell = "CategoryCollectionViewCell"
    let categorySegueIdentifier = "CategorySegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchTextField.placeholder = "Search"
        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return categoryList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: categoryCollectionViewCell, for: indexPath) as! CategoryCollectionViewCell
        let padding = 20
        let cellSize = (collectionView.bounds.width - CGFloat(padding)) / 2.0
        cell.imageView.contentMode = .scaleAspectFill
        cell.imageView.alpha = 0.5
        cell.imageView.frame.size.width = cellSize
        cell.imageView.frame.size.height = cellSize
        cell.categoryLabel.text = categoryList[indexPath.row]
        cell.imageView.image = UIImage(named: cell.categoryLabel.text ?? "")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == categorySegueIdentifier,
        let nextVC = segue.destination as? CategoryViewController,
        let index = collectionView.indexPathsForSelectedItems?[0].row {
            nextVC.delegate = self
            nextVC.categoryText = categoryList[index]
        }
    }
    
    // code to enable tapping on the background to remove software keyboard
    func textFieldShouldReturn(textField:UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
}

