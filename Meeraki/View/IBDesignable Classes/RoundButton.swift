//
//  RoundButton.swift
//  Meeraki
//
//  Created by NILESH_iOS on 27/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable class RoundButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 15 {
        didSet {
            refreshCorners(value: cornerRadius)
        }
    }
    
    @IBInspectable var clearBackground: Bool = false {
        didSet {
            setBorder(color: UIColor.white)
        }
    }
    
    @IBInspectable var backgroundImageColor: UIColor = UIColor.init(red: 0, green: 122/255.0, blue: 255/255.0, alpha: 1) {
        didSet {
            refreshColor(color: backgroundImageColor)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        sharedInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        sharedInit()
    }
    
    override func prepareForInterfaceBuilder() {
        sharedInit()
    }
    
    func sharedInit() {
        refreshCorners(value: cornerRadius)
        refreshColor(color: backgroundImageColor)
        updateLayerProperties()
        setBorder(color: UIColor.white)
    }
    
    func refreshCorners(value: CGFloat) {
        layer.cornerRadius = value
    }
    
    func refreshColor(color: UIColor) {
        if clearBackground == false {
            let image = createImage(color: color)
            setBackgroundImage(image, for: .normal)
            clipsToBounds = true
        }
    }
    
    func setBorder(color: UIColor) {
        if clearBackground == true {
            layer.borderWidth = 1
            layer.borderColor = color.cgColor
            backgroundColor = UIColor.clear
            setBackgroundImage(nil, for: .normal)
        }
    }
    
    func createImage(color: UIColor) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(CGSize(width: 1, height: 1), true, 0.0)
        color.setFill()
        UIRectFill(CGRect(x: 0, y: 0, width: 1, height: 1))
        let image = UIGraphicsGetImageFromCurrentImageContext()!
        return image
    }

    func updateLayerProperties() {
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOffset = CGSize(width: 0.0, height: 2.0)
        layer.shadowRadius = cornerRadius
        layer.shadowOpacity = 0.5
    }
}
