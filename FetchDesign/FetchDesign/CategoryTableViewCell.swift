//
//  CategoryTableViewCell.swift
//  FetchDesign
//
//  Created by Jing Fang on 7/9/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CategoryTableViewCell: UITableViewCell, UICollectionViewDelegate, UICollectionViewDataSource {

    @IBOutlet weak var categoryImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var sizeLabel: UILabel!
    @IBOutlet weak var colorCollectionView: UICollectionView!
    
    var delegate: UIViewController!
    var color: String = String()
   
    var uicolors: [UIColor] = []
    // used for UI color
    var colorDict: [String: UIColor] = ["White": UIColor.white, "Black": UIColor.black, "Brown": UIColor.brown, "Gray": UIColor.gray, "Beige": UIColor(hue: 0.1667, saturation: 0.1, brightness: 0.96, alpha: 1.0), "Blue": UIColor.cyan]
    let colorCollectionViewCell = "ColorCollectionViewCell"
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        colorCollectionView.delegate = self
        colorCollectionView.dataSource = self
        let colors = color.components(separatedBy: ", ")
        for color in colors {
            if (color != "") {
                uicolors.append(colorDict[color]!)
            }
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return uicolors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = colorCollectionView.dequeueReusableCell(withReuseIdentifier: colorCollectionViewCell, for: indexPath) as! CategoryColorCollectionViewCell
        let padding = 5
        let cellSize = (colorCollectionView.bounds.width - CGFloat(padding)) / 8.0
        cell.colorImageView.frame.size.width = cellSize
        cell.colorImageView.frame.size.height = cellSize
        cell.colorImageView.layer.masksToBounds = true
        cell.colorImageView.layer.cornerRadius = cell.colorImageView.bounds.width / 2
        cell.colorImageView.layer.borderWidth = 0.5
        cell.colorImageView.backgroundColor = uicolors[indexPath.row]
        return cell
    }

}
