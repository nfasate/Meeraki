//
//  OTPViewController.swift
//  Meeraki
//
//  Created by NILESH_iOS on 28/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class OTPViewController: UIViewController {

    @IBOutlet var imageView: UIImageView!
    @IBOutlet var txtOTP1: UITextField!
    @IBOutlet var txtOTP2: UITextField!
    @IBOutlet var txtOTP3: UITextField!
    @IBOutlet var txtOTP4: UITextField!
    @IBOutlet var btnSubmit: RoundButton!
    @IBOutlet var resendOTPView: UIView!
    @IBOutlet var btnResendOTP: UIButton!
    @IBOutlet var lblTimer: UILabel!
    @IBOutlet var topView: UIView!
    
    weak var timer:Timer?
    var totalSeconds = 60
    var seconds = 60
    var mobileNumber: String?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setRoundedImageView()
        
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        btnResendOTP.isEnabled = false
        initiateTimer()
        setGradientBackground()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func setup() {
        btnSubmit.isHidden = true
        txtOTP1.delegate = self
        txtOTP2.delegate = self
        txtOTP3.delegate = self
        txtOTP4.delegate = self
        
        txtOTP1.layer.borderWidth = 2
        txtOTP1.layer.borderColor = UIColor.gray.cgColor
        txtOTP2.layer.borderWidth = 2
        txtOTP2.layer.borderColor = UIColor.gray.cgColor
        txtOTP3.layer.borderWidth = 2
        txtOTP3.layer.borderColor = UIColor.gray.cgColor
        txtOTP4.layer.borderWidth = 2
        txtOTP4.layer.borderColor = UIColor.gray.cgColor
        
        txtOTP1.becomeFirstResponder()
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(red: 80/255.0, green: 184/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 97/255.0, green: 202/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        gradientLayer.frame = topView.bounds
        
        topView.layer.insertSublayer(gradientLayer, at: 0)
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.colors = [ colorTop, colorBottom]
        gradientLayer1.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer1.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        gradientLayer1.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer1, at: 0)
    }
    
    func initiateTimer() {
        seconds = totalSeconds
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
            self.seconds -= 1
            self.lblTimer.text = self.timeString(time: TimeInterval(self.seconds))
            if self.seconds == 0 {
                self.invalidateTimer()
            }
        })
    }
    
    func invalidateTimer() {
        timer?.invalidate()
        btnResendOTP.isEnabled = true
    }
    
    func timeString(time:TimeInterval) -> String {
        //let hours = Int(time) / 3600
        let minutes = Int(time) / 60 % 60
        let seconds = Int(time) % 60
        //return String(format:”%02i:%02i:%02i”, hours, minutes, seconds)
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    func setRoundedImageView() {
        imageView.layer.cornerRadius = imageView.frame.width/2
    }
    
    func showHideBtnSubmit() {
        if txtOTP1.text != "", txtOTP2.text != "", txtOTP3.text != "", txtOTP4.text != "" {
            btnSubmit.isHidden = false
            resendOTPView.isHidden = true
        }else {
            btnSubmit.isHidden = true
            resendOTPView.isHidden = false
        }
    }
    
    func presentLetsBeginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let letsBeginController = storyboard.instantiateViewController(withIdentifier: "LetsBeginViewController") as! LetsBeginViewController
        letsBeginController.isAfterReg = false
        letsBeginController.modalPresentationStyle = .overCurrentContext
        present(letsBeginController, animated: true, completion: nil)
    }
    
    @IBAction func submitOTPBtnTapped(_ sender: RoundButton) {
        presentLetsBeginScreen()
    }
    
    @IBAction func resendOTPBtnTapped(_ sender: UIButton) {
        timer?.invalidate()
        btnResendOTP.isEnabled = false
        initiateTimer()
    }
}

extension OTPViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        if (textField.text?.count)! < 1, string.count > 0  {
            if textField == txtOTP1 {
                txtOTP2.becomeFirstResponder()
            }
            
            if textField == txtOTP2 {
                txtOTP3.becomeFirstResponder()
            }
            
            if textField == txtOTP3 {
                txtOTP4.becomeFirstResponder()
            }
            
            if textField == txtOTP4 {
                txtOTP4.resignFirstResponder()
            }
            
            textField.text = string
            showHideBtnSubmit()
            return false
        }else if (textField.text?.count)! >= 1, string.count == 0 {
            
            if textField == txtOTP2 {
                txtOTP1.becomeFirstResponder()
            }
            
            if textField == txtOTP3 {
                txtOTP2.becomeFirstResponder()
            }
            
            if textField == txtOTP4 {
                txtOTP3.becomeFirstResponder()
            }
            
            if textField == txtOTP1 {
                txtOTP1.resignFirstResponder()
            }
            
            textField.text = ""
            showHideBtnSubmit()
            return false
        }else if (textField.text?.count)! >= 1 {
            textField.text = string
            return false
        }
        showHideBtnSubmit()
        return true
    }
}
