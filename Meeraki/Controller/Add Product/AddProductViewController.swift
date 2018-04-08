//
//  AddProductViewController.swift
//  Meeraki
//
//  Created by Nilesh's MAC on 4/7/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit
import Dropdowns

class AddProductViewController: UIViewController {

    //MARK:- IBOutlet variables
    @IBOutlet var btnCategary: UIButton!
    @IBOutlet var txtCategory: HoshiTextField!
    @IBOutlet var txtCompany: HoshiTextField!
    @IBOutlet var txtProductName: HoshiTextField!
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "Add product"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Custom methods
    func setupDropDownItem() {
        let items = ["World", "Sports", "Culture", "Business", "Travel"]
        let titleView = TitleView(navigationController: navigationController!, title: "Menu", items: items)
        titleView?.action = { [weak self] index in
            self?.btnCategary.setTitle(items[index], for: .normal)
            self?.btnCategary.layoutIfNeeded()
        }
        btnCategary.addSubview(titleView!)
        //navigationItem.titleView = titleView
    }
    
    func showItemListScreen(isCategory: Bool) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let itemController = storyboard.instantiateViewController(withIdentifier: "ItemListViewController") as! ItemListViewController
        itemController.isCategory = isCategory
        itemController.delegate = self
        present(itemController, animated: true, completion: nil)
    }

    @IBAction func categoryBtnTapped(_ sender: UIButton) {
        showItemListScreen(isCategory: true)
    }
    
    @IBAction func companyBtnTapped(_ sender: UIButton) {
        showItemListScreen(isCategory: false)
    }
    
    @IBAction func addProductBtnTapped(_ sender: RoundButton) {
        self.navigationController?.popViewController(animated: true)
    }
}

extension AddProductViewController: ItemListViewControllerDelegate {
    func itemDidSelect(_ itemName: String, isCategory: Bool) {
        if isCategory {
            txtCategory.text = itemName
            txtCompany.text = ""
        }else {
            txtCompany.text = itemName
        }
    }
}
