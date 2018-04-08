//
//  ItemListViewController.swift
//  Meeraki
//
//  Created by Nilesh's MAC on 4/8/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

protocol ItemListViewControllerDelegate: class {
    func itemDidSelect(_ itemName: String, isCategory: Bool)
}

class ItemListViewController: UIViewController {

    @IBOutlet var collectionView: UICollectionView!
    
    @IBOutlet var lblTitle: UILabel!
    let itemsCategory = ["Mobile", "Fridge", "AC", "Bike", "Car"]
    let itemsCompany = ["Apple", "Samsung", "MI", "Moto", "Oppo"]
    
    let imageCategory = ["mobileIcon", "fridgeIcon", "acIcon", "bikeIcon", "carIcon"]
    let imageCompany = ["appleIcon", "samsungIcon", "miIcon", "motoIcon", "oppoIcon"]
    
    var isCategory: Bool = false
    
    weak var delegate: ItemListViewControllerDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if isCategory {
            lblTitle.text = "Select category"
        }else {
            lblTitle.text = "Select company"
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
}

extension ItemListViewController: UICollectionViewDelegate, UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if isCategory {
            return itemsCategory.count
        }
        return itemsCompany.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemListViewCell", for: indexPath)
        if let annotateCell = cell as? ItemListViewCell {
            if isCategory {
                annotateCell.lblItemName.text = itemsCategory[indexPath.item]
                
                let image = UIImage(named: imageCategory[indexPath.item])!.withRenderingMode(.alwaysTemplate)
                annotateCell.itemImageView.image = image
                annotateCell.itemImageView.tintColor = UIColor.white
            }else {
                annotateCell.lblItemName.text = itemsCompany[indexPath.item]
                
                let image = UIImage(named: imageCompany[indexPath.item])!.withRenderingMode(.alwaysTemplate)
                annotateCell.itemImageView.image = image
                annotateCell.itemImageView.tintColor = UIColor.white
            }
        }
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        if isCategory {
            delegate?.itemDidSelect(itemsCategory[indexPath.item], isCategory: isCategory)
        }else {
            delegate?.itemDidSelect(itemsCompany[indexPath.item], isCategory: isCategory)
        }
        self.dismiss(animated: true, completion: nil)
    }
}
