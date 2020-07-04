//
//  CollectionViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 7/3/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CollectionViewController: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var collectionList: [String] = ["Bedroom", "Living room", "Home office", "Kids room", "Dinning room"]
    let collectionCollectionViewCell = "CollectionCollectionViewCell"
    let collectionSegueIdentifier = "CollectionSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        collectionView.delegate = self
        collectionView.dataSource = self
        
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return collectionList.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: collectionCollectionViewCell, for: indexPath) as! CollectionCollectionViewCell
        let padding = 16
        cell.collectionImage.contentMode = .scaleAspectFill
        cell.collectionImage.alpha = 0.5
        cell.collectionImage.frame.size.width = collectionView.bounds.width - CGFloat(padding)
        cell.collectionImage.frame.size.height = collectionView.bounds.width / 1.8
        cell.collectionLabel.text = collectionList[indexPath.row]
        cell.collectionImage.image = UIImage(named: cell.collectionLabel.text ?? "")
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == collectionSegueIdentifier,
        let nextVC = segue.destination as? CollectionDetailsViewController,
        let _ = collectionView.indexPathsForSelectedItems?[0].row {
            nextVC.delegate = self
        }
    }

}
