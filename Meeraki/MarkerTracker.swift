//
//  MarkerTracker.swift
//  HeroEyez-ClassRoom
//
//  Created by MANISH_iOS on 12/08/16.
//  Copyright © 2016 Grays Communications LLC. All rights reserved.
//

import UIKit

class MarkerTracker: UIView
{
    //MARK: IBOutlets variables    
    @IBOutlet var userImage: UIImageView!
    @IBOutlet var downArrowBaseImgView: UIImageView!
    
    //MARK:- Variables    
    /// Load view on screen
    var view: UIView!
    var isGrayColorOn =  false
    var isYellowColorOn =  false
    
    //MARK:- Default Override Functions    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.initialize()
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        self.initialize()
    }
    
    convenience init() {
        self.init(frame: CGRect.zero)
        self.initialize()
    }
    
    //MARK:- Custom Functions    
    /// Initial method
    func initialize() {
        xibSetup()
    }
    
    /// Set/load XIB on view
    func xibSetup() {
        view = loadViewFromNib()
        // use bounds not frame or it'll be offset
        view.frame = bounds
        // Make the view stretch with containing view
        view.autoresizingMask = [UIViewAutoresizing.flexibleWidth, UIViewAutoresizing.flexibleHeight]
        // Adding custom subview on top of our view (over any custom drawing > see note below)
        addSubview(view)
    }
    
    /// Load nib file on view
    ///
    /// - Returns: A view
    func loadViewFromNib() -> UIView {
        let bundle = Bundle(for: type(of: self))
        let nib = UINib(nibName: "MarkerTracker", bundle: bundle)
        let view = nib.instantiate(withOwner: self, options: nil)[0] as! UIView
        return view
    }
}
