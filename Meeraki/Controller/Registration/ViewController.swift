//
//  ViewController.swift
//  Meeraki
//
//  Created by NILESH_iOS on 27/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    //MARK:- IBOutlet variables
    @IBOutlet var cardBaseView: UIView!
    @IBOutlet var cardTextField: HoshiTextField!
    @IBOutlet var mobNumberTextField: HoshiTextField!
    @IBOutlet var cardView: UIView!
    @IBOutlet var cardNumberLabel: UILabel!
    @IBOutlet var cardImageView: UIImageView!
    
    //MARK:- Private variables
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCardBackground()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Custom methods
    func setupView() {
        cardTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        mobNumberTextField.addTarget(self, action: #selector(reformatMobileNumber), for: .editingChanged)
        cardTextField.delegate = self
        mobNumberTextField.delegate = self
        
        let image = UIImage(named: "card")!.withRenderingMode(.alwaysTemplate)
        cardImageView.image = image
        cardImageView.tintColor = UIColor.white
        
        setGradientBackground()
        setShadowEffectToCard()
    }
    
    func setBorderToCardBaseView() {
        cardBaseView.layer.borderWidth = 2
        cardBaseView.layer.borderColor = UIColor.brown.cgColor
        cardBaseView.layer.cornerRadius = 5
    }
    
    func setShadowEffectToCard() {
        cardView.layer.shadowColor = UIColor.black.cgColor
        cardView.layer.cornerRadius = 10
        cardView.layer.shadowOffset = CGSize(width: 0, height: 2.0)
        cardView.layer.shadowOpacity = 0.6
    }
    
    func setGradientBackground() {
        let colorTop = UIColor(red: 80/255.0, green: 184/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 97/255.0, green: 202/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)
        gradientLayer.frame = self.view.bounds
        
        self.view.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func setCardBackground() {
        let colorTop = UIColor(red: 77/255.0, green: 156/255.0, blue: 246/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 38/255.0, green: 112/255.0, blue: 210/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)  //
        gradientLayer.frame = cardView.bounds
        gradientLayer.cornerRadius = 10
        cardView.layer.insertSublayer(gradientLayer, at: 0)
    }
    
    func validateFields() -> Bool {
        if cardTextField.text == "" {
            showAlert("Validation alert", message: "Please enter your 16-digit card number")
            return false
        }else if (cardTextField.text?.count)! < 19 {
            showAlert("Validation alert", message: "Please enter valid card number")
            return false
        }
        
        if mobNumberTextField.text == "" {
            showAlert("Validation alert", message: "Please enter your mobile number")
            return false
        }else if (mobNumberTextField.text?.count)! < 10 {
            showAlert("Validation alert", message: "Please enter valid mobile number")
            return false
        }
        
        return true
    }
    
    func showAlert(_ title: String, message: String) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let alertAction = UIAlertAction(title: "Ok", style: .default) { (action) in
            
        }
        
        alertController.addAction(alertAction)
        present(alertController, animated: true, completion: nil)
    }
    
    func presentOTPViewController() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let otpController = storyboard.instantiateViewController(withIdentifier: "OTPViewController") as! OTPViewController
        otpController.mobileNumber = mobNumberTextField.text!
        Macros.Variables.targetController?.present(otpController, animated: true, completion: nil)
    }
    
    func presentHomeScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        present(homeVC, animated: true, completion: nil)
    }
    
    //MARK:- IBAction methods
    @IBAction func backBtnTapped(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func generateOTPBtnTapped(_ sender: RoundButton) {
        if validateFields() == true {
            self.dismiss(animated: false, completion: nil)
            presentOTPViewController()
        }
    }
    
    @IBAction func skipBtnTapped(_ sender: RoundButton) {
        
    }
}

//MARK:- UITextFieldDelegate
extension ViewController: UITextFieldDelegate {
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setCardBackground()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        return true
    }
    
    //MARK: Textfield custom methods
    @objc func reformatAsCardNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 16 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            return
        }
        
        let cardNumberWithSpaces = self.insertSpacesEveryFourDigitsIntoString(string: cardNumberWithoutSpaces, andPreserveCursorPosition: &targetCursorPosition)
        textField.text = cardNumberWithSpaces
        cardNumberLabel.text = cardNumberWithSpaces
        
        if cardNumberWithSpaces == "" {
            cardNumberLabel.text = "XXXX XXXX XXXX XXXX"
        }
        
        if let targetPosition = textField.position(from: textField.beginningOfDocument, offset: targetCursorPosition) {
            textField.selectedTextRange = textField.textRange(from: targetPosition, to: targetPosition)
        }
    }
    
    @objc func reformatMobileNumber(textField: UITextField) {
        var targetCursorPosition = 0
        if let startPosition = textField.selectedTextRange?.start {
            targetCursorPosition = textField.offset(from: textField.beginningOfDocument, to: startPosition)
        }
        
        var cardNumberWithoutSpaces = ""
        if let text = textField.text {
            cardNumberWithoutSpaces = self.removeNonDigits(string: text, andPreserveCursorPosition: &targetCursorPosition)
        }
        
        if cardNumberWithoutSpaces.count > 10 {
            textField.text = previousTextFieldContent
            textField.selectedTextRange = previousSelection
            mobNumberTextField.resignFirstResponder()
            return
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
    
    func insertSpacesEveryFourDigitsIntoString(string: String, andPreserveCursorPosition cursorPosition: inout Int) -> String {
        var stringWithAddedSpaces = ""
        let cursorPositionInSpacelessString = cursorPosition
        
        for i in Swift.stride(from: 0, to: string.count, by: 1) {
            if i > 0 && (i % 4) == 0 {
                stringWithAddedSpaces.append("-")
                if i < cursorPositionInSpacelessString {
                    cursorPosition += 1
                }
            }
            let characterToAdd = string[string.index(string.startIndex, offsetBy:i)]
            stringWithAddedSpaces.append(characterToAdd)
        }
        
        return stringWithAddedSpaces
    }
}
