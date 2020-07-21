//
//  CategoryViewController.swift
//  FetchDesign
//
//  Created by Jing Fang on 6/27/20.
//  Copyright © 2020 J.A.M. All rights reserved.
//

import UIKit

class CategoryViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var categoryName: UILabel!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var categoryTableView: UITableView!
    
    var delegate: UIViewController!
    var categoryText: String = String()
    
    var detailsList: [String] = []
    var colorList: [String] = []
    var sizeList: [String] = []
    
    let categoryTableViewCell = "CategoryTableViewCell"
    let categoryTableViewSegueIdentifier = "CategoryTableViewSegue"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        categoryName.text = categoryText
        
        categoryTableView.delegate = self
        categoryTableView.dataSource = self
        
        // change
        // "Sofas", "Beds", "Desks", "Dining Tables", "Armchairs", "View All"
        if (categoryText == "Beds") {
            detailsList = ["bed1"]
            colorList = ["White, Black, Brown"]
            sizeList = ["Full, King, Queen"]
        } else if (categoryText == "Sofas") {
            detailsList = ["sofa1"]
            colorList = ["Beige, Black, Gray"]
            sizeList = ["H: 85cm W: 240cm D: 98cm"]
        } else if (categoryText == "Desks") {
            detailsList = ["desk1"]
            colorList = ["White, Beige, Gray, Black"]
            sizeList = ["142x50 cm"]
        } else if (categoryText == "Dining Tables") {
            detailsList = ["dining table1"]
            colorList = ["Beige, Brown, Gray"]
            sizeList = ["125x75 cm"]
        } else if (categoryText == "Armchairs") {
            detailsList = ["armchair1"]
            colorList = ["Beige, Black, Gray"]
            sizeList = ["H: 75cm W: 83cm D: 47cm"]
        } else {
            detailsList = ["bed1", "sofa1", "desk1", "dining table1", "armchair1"]
            colorList = ["White, Black, Brown", "Beige, Black, Gray", "White, Beige, Gray, Black", "Beige, Brown, Gray", "Beige, Black, Gray"]
            sizeList = ["Full, King, Queen", "H: 85cm W: 240cm D: 98cm", "142x50 cm", "125x75 cm", "H: 75cm W: 83cm D: 47cm"]
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return detailsList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = categoryTableView.dequeueReusableCell(withIdentifier: categoryTableViewCell, for: indexPath) as! CategoryTableViewCell
        let cellSize = categoryTableView.bounds.width / 2.8
        cell.categoryImageView.contentMode = .scaleAspectFit
        cell.categoryImageView.frame.size.width = cellSize
        cell.categoryImageView.frame.size.height = cellSize
        cell.nameLabel.text = detailsList[indexPath.row]
        cell.categoryImageView.image = UIImage(named: cell.nameLabel.text ?? "")
        cell.sizeLabel.text = sizeList[indexPath.row]
        cell.priceLabel.text = "Price: $$"
        cell.sizeLabel.adjustsFontSizeToFitWidth = true
        cell.color = colorList[indexPath.row]
        cell.awakeFromNib()
        return cell
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == categoryTableViewSegueIdentifier,
        let nextVC = segue.destination as? CategoryDetailsViewController,
        let index = categoryTableView.indexPathForSelectedRow?.row {
            nextVC.delegate = self
            nextVC.furnitureName = detailsList[index]
            if (categoryText == "View All") {
                let text = detailsList[index]
                let range = text.index(after: text.startIndex)..<text.index(before: text.endIndex)
                var category = text[text.startIndex].uppercased() + text[range] + "s"
                if (category == "Dining tables") {
                    category = "Dining Tables"
                }
                nextVC.category = category
            } else {
                nextVC.category = categoryText
            }
            
            nextVC.color = colorList[index]
            nextVC.size = sizeList[index]
            nextVC.image = UIImage(named: detailsList[index])!
        }
    }
    

    @IBAction func cancelPressed(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

}
