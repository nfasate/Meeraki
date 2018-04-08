//
//  RegistrationViewController.swift
//  CustomerSupport
//
//  Created by Nilesh's MAC on 2/20/18.
//  Copyright © 2018 Nilesh's MAC. All rights reserved.
//

import UIKit
import CountryPicker

class RegistrationViewController: UIViewController {
    //MARK:- IBOutlet variables
    @IBOutlet var txtCountryCode: HoshiTextField!
    @IBOutlet var txtMobileNumber: HoshiTextField!
    @IBOutlet var txtEmailId: HoshiTextField!
    @IBOutlet var txtPassword: HoshiTextField!
    @IBOutlet var txtConfirmPassword: HoshiTextField!
    @IBOutlet var txtAreaCode: HoshiTextField!
    @IBOutlet var baseView: UIView!
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var picker: CountryPicker!
    @IBOutlet var countryView: UIView!
    
    //MARK:- Private variables
    private var previousTextFieldContent: String?
    private var previousSelection: UITextRange?
    
    //MARK:- Variables
    var mobileNumber:String?
    var countryCode = ""
    
    //MARK:- Controller life cycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        presentLetsBeginScreen()
        setGradientBackground()
        setCountryPickerView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK:- Custom methods
    func setupUI() {
        txtMobileNumber.addTarget(self, action: #selector(reformatNumber), for: .editingChanged)
        txtAreaCode.addTarget(self, action: #selector(reformatNumber), for: .editingChanged)
        
        txtMobileNumber.delegate = self
        txtEmailId.delegate = self
        txtPassword.delegate = self
        txtConfirmPassword.delegate = self
        txtAreaCode.delegate = self
        countryView.isHidden = true
        
        txtMobileNumber.text = mobileNumber
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
    
    func presentLetsBeginScreen() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let letsBeginController = storyboard.instantiateViewController(withIdentifier: "LetsBeginViewController") as! LetsBeginViewController
        letsBeginController.isAfterReg = false
        letsBeginController.mobileNumber = mobileNumber
        letsBeginController.modalPresentationStyle = .overCurrentContext
        present(letsBeginController, animated: false, completion: nil)
    }
    
    func presentHomeScreen() {
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let homeVC = storyboard.instantiateViewController(withIdentifier: "MainTabBarController") as! UITabBarController
        Macros.Variables.isProfileCreated = true
        Macros.Variables.targetController?.present(homeVC, animated: true, completion: nil)
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
            if cardNumberWithoutSpaces.count > 6 {
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
    
    func setCountryPickerView() {
        let locale = Locale.current
        let code = (locale as NSLocale).object(forKey: NSLocale.Key.countryCode) as! String?
        //init Picker
        picker.countryPickerDelegate = self
        picker.showPhoneNumbers = true
        let theme = CountryViewTheme(countryCodeTextColor: .white, countryNameTextColor: .white, rowBackgroundColor: .black, showFlagsBorder: true) //optional
        picker.theme = theme //optional
        picker.setCountry(code!)
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
    
    func showCountryPicker() {
        countryView.isHidden = false
        countryView.transform = CGAffineTransform(translationX: 0, y: countryView.frame.height)
        countryView.alpha = 1
        UIView.animate(withDuration: 0.5, animations: {
            self.countryView.transform = .identity
        })
    }
    
    func hideCountryPicker() {
        UIView.animate(withDuration: 0.5, animations: {
            self.countryView.alpha = 0
            self.countryView.transform = CGAffineTransform(translationX: 0, y: self.countryView.frame.height)
        }, completion: { (success) in
            self.countryView.isHidden = true
        })
    }
    
    //MARK:- IBAction methods
    @IBAction func submitBtnTapped(_ sender: RoundButton) {
        self.dismiss(animated: false, completion: nil)
        presentHomeScreen()
        //If failed
        //presentLetsBeginScreen()
    }
    
    @IBAction func pickerCancelBtnTapped(_ sender: UIButton) {
        hideCountryPicker()
    }
    
    @IBAction func countryCodeBtnTapped(_ sender: UIButton) {
        self.view.endEditing(true)
        showCountryPicker()
    }
    
    @IBAction func countryDoneBtnTapped(_ sender: UIButton) {
        self.txtCountryCode.text = self.countryCode
        hideCountryPicker()
    }
}

//MARK:- UITextFieldDelegate
extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        previousTextFieldContent = textField.text;
        previousSelection = textField.selectedTextRange;
        return true
    }
}

//MARK:- CountryPickerDelegate
extension RegistrationViewController: CountryPickerDelegate {
    public func countryPhoneCodePicker(_ picker: CountryPicker, didSelectCountryWithName name: String, countryCode: String, phoneCode: String, flag: UIImage) {
        self.countryCode = phoneCode
    }
}
