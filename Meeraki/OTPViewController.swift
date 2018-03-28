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
    @IBOutlet var lblTimer: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup()
        setRoundedImageView()
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
    
    @IBAction func submitOTPBtnTapped(_ sender: RoundButton) {
    }
    
    @IBAction func resendOTPBtnTapped(_ sender: UIButton) {
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
        }
        showHideBtnSubmit()
        return true
    }
}
