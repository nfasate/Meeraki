//
//  LetsBeginViewController.swift
//  Meeraki
//
//  Created by Nilesh's MAC on 3/28/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class LetsBeginViewController: UIViewController {

    @IBOutlet var baseView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet var lblTitle: UILabel!
    @IBOutlet var lblSubTitle: UILabel!
    @IBOutlet var btnLetsBegin: RoundButton!
    
    let subTitle1 = "Your profile is being created"
    let subTitle2 = "We are extremely sorry as your pincode is not yet being serviced by meeraki cards. But we will be available in your area soon"
    let subTitle3 = "Your account has been verified. Now lets quickly create your profile."
    
    var isSuccess = false
    var isAfterReg = false
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setGradientBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func setupUI() {
        contentView.layer.cornerRadius = 10
        baseView.alpha = 0.7
        
        if isAfterReg {
            if isSuccess {
                lblSubTitle.text = subTitle1
            }else {
                lblTitle.isHidden = true
                lblSubTitle.text = subTitle2
                btnLetsBegin.setTitle("Close", for: .normal)
            }
        }else {
            lblSubTitle.text = subTitle3
        }
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(red: 80/255.0, green: 184/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 97/255.0, green: 202/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)  //
        gradientLayer.frame = contentView.bounds
        gradientLayer.cornerRadius = 10
        contentView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func presentRegistrationScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let regController = storyboard.instantiateViewController(withIdentifier: "RegistrationViewController") as! RegistrationViewController
        present(regController, animated: true, completion: nil)
    }
    
    func presentHomeScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "NAVVCID") as! UINavigationController
        present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func letsBeginBtnTapped(_ sender: RoundButton) {
        if isAfterReg {
            if isSuccess {
                presentHomeScreen()
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }else {
            presentRegistrationScreen()
        }
    }
}
