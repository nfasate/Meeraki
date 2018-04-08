//
//  GlobalVariables.swift
//  Meeraki
//
//  Created by Nilesh's MAC on 4/7/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import Foundation
import UIKit
import MapKit

struct Macros
{
    /// Variables to use globally in application
    struct Constants {
        
    }
    
    struct Variables {
        static var targetController: UIViewController?
        static var isProfileCreated = false
        /// To save user's current location's Latitude Globally
        static var userCurrentLat: CLLocationDegrees!
        /// To save user's current location's Longitude Globally
        static var userCurrentLong: CLLocationDegrees!
    }
}
