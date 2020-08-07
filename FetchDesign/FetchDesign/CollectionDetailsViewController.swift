//
//  CollectionDetailsViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 7/3/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CollectionDetailsViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var detailsCollectionView: UICollectionView!
    @IBOutlet weak var cancelButton: UIButton!
    
    var delegate: UIViewController!
    var collection: String = String()
    
    var detailsList: [String] = []
    var colorList: [String] = []
    var sizeList: [String] = []
    
    let detailCollectionViewCell = "DetailCollectionViewCell"
    let collectionCameraSegueIdentifier = "CollectionCameraSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        detailsCollectionView.delegate = self
        detailsCollectionView.dataSource = self
        
        // change here after creating a database
        // "Bedroom", "Living room", "Home office", "Kids room", "Dinning room"
        if (collection == "Bedroom") {
            detailsList = ["bed1"]
            colorList = ["White, Black, Brown"]
            sizeList = ["Full, King, Queen"]
        } else if (collection == "Living room") {
            detailsList = ["sofa1", "armchair1"]
            colorList = ["Beige, Black, Gray", "Beige, Black, Gray"]
            sizeList = ["H: 85cm W: 240cm D: 98cm", "H: 75cm W: 83cm D: 47cm"]
        } else if (collection == "Home office") {
            detailsList = ["desk1"]
            colorList = ["White, Beige, Gray, Black"]
            sizeList = ["142x50 cm"]
        } else if (collection == "Dining room") {
            detailsList = ["dining table1"]
            colorList = ["Beige, Brown, Gray"]
            sizeList = ["125x75 cm"]
        }
        // end of change
    }
    
    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return detailsList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = detailsCollectionView.dequeueReusableCell(withReuseIdentifier: detailCollectionViewCell, for: indexPath) as! DetailsCollectionViewCell
        let padding = 20
        let cellSize = (collectionView.bounds.width - CGFloat(padding)) / 2.0
        cell.frame.size.width = cellSize
        cell.frame.size.height = cellSize * 1.6
        cell.detailsImageView.contentMode = .scaleAspectFit
        
        cell.detailsImageView.frame.size.width = cellSize
        cell.detailsImageView.frame.size.height = cellSize * 1.2
        cell.furnitureNameLabel.text = detailsList[indexPath.row]
        cell.detailsImageView.image = UIImage(named: cell.furnitureNameLabel.text ?? "")
        cell.colorLabel.text = colorList[indexPath.row]
        cell.sizeLabel.text = sizeList[indexPath.row]
        cell.colorLabel.adjustsFontSizeToFitWidth = true
        cell.sizeLabel.adjustsFontSizeToFitWidth = true
        return cell
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == collectionCameraSegueIdentifier,
        let nextVC = segue.destination as? MainTabBarController,
        let vc = nextVC.viewControllers?[1] as? CameraViewController,
            let index = detailsCollectionView.indexPathsForSelectedItems?[0].row {
            // change here
            let text = detailsList[index]
            let range = text.index(after: text.startIndex)..<text.index(before: text.endIndex)
            var category = text[text.startIndex].uppercased() + text[range] + "s"
            if (category == "Dining tables") {
                category = "Dining Tables"
            }
            vc.furnitureCategory = category
            nextVC.selectedIndex = 1
        }
    }

}
