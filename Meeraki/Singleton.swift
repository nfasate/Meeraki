//
//  Singleton.swift
//  Meeraki
//
//  Created by NILESH_iOS on 29/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import Foundation

//MARK:- Singleton class
final class Singleton: NSObject
{
    
    //MARK:- Variables    
    static let shared = Singleton()
    
    //MARK:- Delay Function
    /// function to create delay
    ///
    /// - Parameters:
    ///   - delay: delay time
    ///   - closure: closure object to perform task after the delay
    func delay(_ delay:Double, closure:@escaping ()->())
    {
        DispatchQueue.main.asyncAfter(
            deadline: DispatchTime.now() + Double(Int64(delay * Double(NSEC_PER_SEC))) / Double(NSEC_PER_SEC), execute: closure)
    }
}
