//
//  ViewController.swift
//  Meeraki
//
//  Created by NILESH_iOS on 27/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITextFieldDelegate {

    @IBOutlet var cardBaseView: UIView!
    @IBOutlet var cardTextField: HoshiTextField!
    @IBOutlet var mobNumberTextField: HoshiTextField!
    
    @IBOutlet var cardView: UIView!
    @IBOutlet var cardNumberLabel: UILabel!
    
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        cardTextField.addTarget(self, action: #selector(reformatAsCardNumber), for: .editingChanged)
        mobNumberTextField.addTarget(self, action: #selector(reformatMobileNumber), for: .editingChanged)
        cardTextField.delegate = self
        mobNumberTextField.delegate = self
        setGradientBackground()
        //setBorderToCardBaseView()
        setShadowEffectToCard()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        setCardBackground()
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
//        let colorTop =  UIColor(red: 55/255.0, green: 125/255.0, blue: 160/255.0, alpha: 1.0).cgColor
//        let colorBottom = UIColor(red: 80/255.0, green: 177/255.0, blue: 186/255.0, alpha: 1.0).cgColor
        
        let colorTop = UIColor(red: 80/255.0, green: 184/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        let colorBottom = UIColor(red: 97/255.0, green: 202/255.0, blue: 146/255.0, alpha: 1.0).cgColor
        
        let gradientLayer = CAGradientLayer()
        gradientLayer.colors = [ colorTop, colorBottom]
        //gradientLayer.locations = [ 0.0, 1.0]
        gradientLayer.startPoint = CGPoint.init(x: 0.0, y: 0.5)
        gradientLayer.endPoint = CGPoint.init(x: 0.5, y: 1.0)  //
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
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        setCardBackground()
        return true
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        return true
    }
    
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

