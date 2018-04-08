//
//  LoginViewController.swift
//  DemoApp
//
//  Created by NILESH_iOS on 03/04/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {

    @IBOutlet var txtEmail: HoshiTextField!
    @IBOutlet var txtPassword: HoshiTextField!
    @IBOutlet var btnSignIn: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Macros.Variables.targetController = self
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        //btnSignIn.applyGradient(withColours: [#colorLiteral(red: 0.0390000008, green: 0.3140000105, blue: 0.3689999878, alpha: 1), #colorLiteral(red: 0.06700000167, green: 0.4819999933, blue: 0.5730000138, alpha: 1)], gradientOrientation: .horizontal)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func showHomeScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        present(homeVC, animated: true, completion: nil)
    }
    
    @IBAction func signInBtnTapped(_ sender: UIButton) {
        showHomeScreen()
    }
}

typealias GradientPoints = (startPoint: CGPoint, endPoint: CGPoint)

enum GradientOrientation {
    case topRightBottomLeft
    case topLeftBottomRight
    case horizontal
    case vertical
    
    var startPoint : CGPoint {
        return points.startPoint
    }
    
    var endPoint : CGPoint {
        return points.endPoint
    }
    
    var points : GradientPoints {
        get {
            switch(self) {
            case .topRightBottomLeft:
                return (CGPoint(x: 0.0,y: 1.0), CGPoint(x: 1.0,y: 0.0))
            case .topLeftBottomRight:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 1,y: 1))
            case .horizontal:
                return (CGPoint(x: 0.0,y: 0.5), CGPoint(x: 1.0,y: 0.5))
            case .vertical:
                return (CGPoint(x: 0.0,y: 0.0), CGPoint(x: 0.0,y: 1.0))
            }
        }
    }
}

extension UIView {
    
    func applyGradient(withColours colours: [UIColor], locations: [NSNumber]? = nil, radius:CGFloat = 10) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = radius
        gradient.colors = colours.map { $0.cgColor }
        gradient.locations = locations
        self.layer.insertSublayer(gradient, at: 0)
    }
    
    func applyGradient(withColours colours: [UIColor], gradientOrientation orientation: GradientOrientation, radius:CGFloat = 10) -> Void {
        let gradient = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.cornerRadius = radius
        gradient.colors = colours.map { $0.cgColor }
        gradient.startPoint = orientation.startPoint
        gradient.endPoint = orientation.endPoint
        self.layer.insertSublayer(gradient, at: 0)
    }
}
