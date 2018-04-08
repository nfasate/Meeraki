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
    @IBOutlet var menuView: UIView!
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        setupDropDownItem()
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

}
