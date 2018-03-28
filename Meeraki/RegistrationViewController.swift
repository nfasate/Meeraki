//
//  RegistrationViewController.swift
//  CustomerSupport
//
//  Created by Nilesh's MAC on 2/20/18.
//  Copyright © 2018 Nilesh's MAC. All rights reserved.
//

import UIKit

class RegistrationViewController: UIViewController {

    @IBOutlet var txtCountryCode: HoshiTextField!
    @IBOutlet var txtMobileNumber: HoshiTextField!
    @IBOutlet var txtEmailId: HoshiTextField!
    @IBOutlet var txtPassword: HoshiTextField!
    @IBOutlet var txtConfirmPassword: HoshiTextField!
    @IBOutlet var txtAreaCode: HoshiTextField!
    @IBOutlet var baseView: UIView!
    @IBOutlet var contentView: UIView!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
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
        txtMobileNumber.addTarget(self, action: #selector(reformatNumber), for: .editingChanged)
        txtAreaCode.addTarget(self, action: #selector(reformatNumber), for: .editingChanged)
        
        txtMobileNumber.delegate = self
        txtEmailId.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtAreaCode.delegate = self        
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(red: 80/255.0, green: 184/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 97/255.0, green: 202/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        gradientLayer.frame = contentView.bounds
        
        contentView.layer.insertSublayer(gradientLayer, at: 0)
        
        let gradientLayer1 = CAGradientLayer()
        gradientLayer1.colors = [ colorTop, colorBottom]
        gradientLayer1.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer1.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        gradientLayer1.frame = baseView.bounds
        
        baseView.layer.insertSublayer(gradientLayer1, at: 0)
    }

    @objc func reformatNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if textField == txtMobileNumber {
            if cardNumberWithoutSpaces.count > 10 {
                textField.text = previousTextFieldContent
                textField.selectedTextRange = previousSelection
                return
            }
        }else if textField == txtAreaCode {
            if cardNumberWithoutSpaces.count > 4 {
                textField.text = previousTextFieldContent
                textField.selectedTextRange = previousSelection
                return
            }
        }
        
        textField.text = cardNumberWithoutSpaces
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    func removeNonDigits(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var digitsOnlyString = ""
        let originalCursorPosition = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            let characterToAdd = string[string.index(string.startIndex, offsetBy: i)]
            if characterToAdd >= "0" && characterToAdd <= "9" {
                digitsOnlyString.append(characterToAdd)
            }
            else if i < originalCursorPosition {
                cursorPosition -= 1
            }
        }
        
        return digitsOnlyString
    }
    
    func presentLetsBeginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let letsBeginController = storyboard.instantiateViewController(withIdentifier: "LetsBeginViewController") as! LetsBeginViewController
        letsBeginController.isAfterReg = true
        letsBeginController.isSuccess = true
        letsBeginController.modalPresentationStyle = .overCurrentContext
        present(letsBeginController, animated: true, completion: nil)
    }
    
    @IBAction func submitBtnTapped(_ sender: RoundButton) {
        presentLetsBeginScreen()
    }
    

}

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        return true
    }
}
