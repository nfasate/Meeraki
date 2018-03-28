//
//  HomeViewController.swift
//  Meeraki
//
//  Created by Nilesh's MAC on 3/29/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
       
        //custom.tabBarItem = UITabBarItem(title: "Home", image: UIImage(named: "tab_icon_normal"), selectedImage: UIImage(named: "tab_icon_seelcted"))

        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont(name: "Georgia-Bold", size: 15)!], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "Georgia-Bold", size: 15)!], for:.selected)
        
        UITabBar.appearance().tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
