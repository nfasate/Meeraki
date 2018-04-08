//
//  GradientView.swift
//  DemoApp
//
//  Created by NILESH_iOS on 03/04/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import Foundation
import UIKit

@IBDesignable public class GradientView: UIView {
    
    @IBInspectable public var topColor: UIColor? {
        didSet {
            configureGradientView()
        }
    }
    @IBInspectable public var bottomColor: UIColor? {
        didSet {
            configureGradientView()
        }
    }
    @IBInspectable var startX: CGFloat = 0.0 {
        didSet{
            configureGradientView()
        }
    }
    @IBInspectable var startY: CGFloat = 1.0 {
        didSet{
            configureGradientView()
        }
    }
    @IBInspectable var endX: CGFloat = 0.0 {
        didSet{
            configureGradientView()
        }
    }
    @IBInspectable var endY: CGFloat = 0.0 {
        didSet{
            configureGradientView()
        }
    }
    
    override public class var layerClass: AnyClass {
        return CAGradientLayer.self
    }
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        configureGradientView()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configureGradientView()
    }
    
    public override func tintColorDidChange() {
        super.tintColorDidChange()
        configureGradientView()
    }
    
    func configureGradientView() {
        
        let color1 = topColor ?? self.tintColor as UIColor
        let color2 = bottomColor ?? UIColor.black as UIColor
        let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
        let layer = self.layer as! CAGradientLayer
        
        layer.colors = colors
        layer.startPoint = CGPoint(x: startX, y: startY)
        layer.endPoint = CGPoint(x: endX, y: endY)
    }
    
    func configureView() {
        let layer = self.layer as! CAGradientLayer
        let locations = [ 0.0, 1.0 ]
        layer.locations = locations as [NSNumber]
        let color1 = topColor ?? self.tintColor as UIColor
        let color2 = bottomColor ?? UIColor.black as UIColor
        let colors: Array <AnyObject> = [ color1.cgColor, color2.cgColor ]
        layer.colors = colors
    }
}
