//
//  AppDelegate.swift
//  Meeraki
//
//  Created by NILESH_iOS on 27/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit
import IQKeyboardManagerSwift
import GoogleMaps
import GooglePlaces

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    /// Location manager object to start monitoring location.
    var locationManager: CLLocationManager!
    /// Location object to store last location.
    var lastLoc: CLLocation!
    /// Object of background tasks identifier.
    var backgroundUpdateTask: UIBackgroundTaskIdentifier!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {

        setupIQkeyboardManager()
        googleMapSetup()
        navigationBarSetup()

        return true
    }

    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }

    /**
     IQKeyboard manager setup.
     */
    func setupIQkeyboardManager()
    {
        IQKeyboardManager.sharedManager().enable = true
        IQKeyboardManager.sharedManager().enableAutoToolbar = true
        IQKeyboardManager.sharedManager().shouldShowToolbarPlaceholder = true
        IQKeyboardManager.sharedManager().toolbarDoneBarButtonItemText = NSLocalizedString("Done", comment: "")
        //IQKeyboardManager.sharedManager().keyboardDistanceFromTextField = 40
    }
    
    /**
     Initial set up google map.
     */
    func googleMapSetup()
    {
        //        var isKeyAvailable = false
        //        if let googleMapKey = UserDefault.sharedInstance.getGoogleMapKey()
        //        {
        //            isKeyAvailable = true
        //            Macros.ApiKeys.googleMapKeyProd = googleMapKey
        //        }
        //
        //        #if RELEASE
        //            // All release constants
        //            Macros.Constants.isTesting  = false
        //            if Macros.Constants.plistFileName == "Aegis-Eyez"
        //            {
        //                Macros.ApiKeys.mapKeyGoogle = Macros.ApiKeys.googleMapKeyProd
        //            }else
        //            {
        //                Macros.ApiKeys.mapKeyGoogle = Macros.ApiKeys.googleMapKeyDev
        //            }
        //        #else
        //            // All debug constants
        //            Macros.Constants.isTesting  = true
        //            Macros.ApiKeys.mapKeyGoogle = Macros.ApiKeys.googleMapKeyDev
        //        #endif
        //
        //        if isKeyAvailable == false {
        //            UserDefaults.standard.setValue(Macros.ApiKeys.mapKeyGoogle, forKey: "googleMapConfigKey")
        //        }
        
        GMSServices.provideAPIKey("AIzaSyBh4Px06vNGuFRY1ClNDkJZW65CKSzCdi8")
        GMSPlacesClient.provideAPIKey("AIzaSyBh4Px06vNGuFRY1ClNDkJZW65CKSzCdi8")
        
        setupLocationManager(withDistanceFilter: true, distanceFilter: 50.0)
    }
    
    func navigationBarSetup() {
        let attributes = [NSAttributedStringKey.font: UIFont(name: "ClanPro-News", size: 17)!, NSAttributedStringKey.foregroundColor : UIColor.white]
        UINavigationBar.appearance().titleTextAttributes = attributes
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.gray, NSAttributedStringKey.font: UIFont(name: "ClanPro-News", size: 14)!], for:.normal)
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedStringKey.foregroundColor: UIColor.white, NSAttributedStringKey.font: UIFont(name: "ClanPro-News", size: 14)!], for:.selected)
        
        UITabBar.appearance().tintColor = UIColor(red: 255/255.0, green: 255/255.0, blue: 255/255.0, alpha: 1.0)
    }
}

//MARK:- CLLocation Delegate
extension AppDelegate: CLLocationManagerDelegate {
    @objc(locationManager:didChangeAuthorizationStatus:) func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus)
    {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            locationManager.startUpdatingLocation()
        }
        switch status {
        case .notDetermined:
            locationManager.requestAlwaysAuthorization()
            //removeLocationAlertLabel()
            break
        case .authorizedWhenInUse:
            locationManager.distanceFilter = CLLocationDistance(50.0)
            locationManager.requestAlwaysAuthorization()
            locationManager.startUpdatingLocation()
            //removeLocationAlertLabel()
            break
        case .authorizedAlways:
            locationManager.distanceFilter = CLLocationDistance(50.0)
            locationManager.startUpdatingLocation()
            //removeLocationAlertLabel()
            break
        case .restricted:
            // restricted by e.g. parental controls. User can't enable Location Services
            //NotificationCenter.default.post(name: Notification.Name(rawValue: Macros.Notification.Notification_ShowLocationServiceOffAlert), object: nil)
            break
        case .denied:
            // user denied your app access to Location Services, but can grant access from Settings.app
            //NotificationCenter.default.post(name: Notification.Name(rawValue: Macros.Notification.Notification_ShowLocationServiceOffAlert), object: nil)
            break
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        print("Error Location : \(error.localizedDescription)")
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation])
    {
        if let newLoc = locations.first?.coordinate
        {
            print("arrLat: \(newLoc.latitude) arrLong: \(newLoc.longitude)")
            
            if let newLocation = locations.last
            {
                if(lastLoc == nil)
                {
                    lastLoc = locations.last
                    
                    UserDefaults.standard.set("\(newLoc.latitude)", forKey: "userLastLocationLat")
                    
                    UserDefaults.standard.set("\(newLoc.longitude)", forKey: "userLastLocationLong")
                    
                    Macros.Variables.userCurrentLat = (newLoc.latitude)
                    
                    Macros.Variables.userCurrentLong = (newLoc.longitude)
                    
                    //sendNewLocationToServer(newLoc: newLoc)
                }
                
                let locationAge = -newLocation.timestamp.timeIntervalSinceNow
                if locationAge > 10
                {
                    print("Locaiton is old.")
                    return
                }
                // test that the horizontal accuracy does not indicate an invalid measurement
                if newLocation.horizontalAccuracy < 0
                {
                    print("Latitidue and longitude values are invalid.")
                    return
                }
                
                print("Last Accuracy \(lastLoc.horizontalAccuracy)")
                print("Current Accuracy \(newLocation.horizontalAccuracy)")
                
                // if lastLoc.horizontalAccuracy > newLocation.horizontalAccuracy                 {
                print("Location quality is good enough.")
                //                     showLocalNotification("Location quality is good enough-2. \(newLocation.horizontalAccuracy)")
                lastLoc = locations.last
                
                UserDefaults.standard.set("\(newLoc.latitude)", forKey: "userLastLocationLat")
                
                UserDefaults.standard.set("\(newLoc.longitude)", forKey: "userLastLocationLong")
                
                Macros.Variables.userCurrentLat = (newLoc.latitude)
                
                Macros.Variables.userCurrentLong = (newLoc.longitude)
                
                //sendNewLocationToServer(newLoc: newLoc)
                
                return
                //  }
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didEnterRegion region: CLRegion)
    {
        if region.identifier != "HE_Loc"
        {
            if UIApplication.shared.applicationState == .active
            {
                // Current Location with in inside Geo Fence
                //self.showPopupForRegionStateChange(title: region.identifier, message: "\(NSLocalizedString("You_entered", comment: "")) \(region.identifier)")
            }else
            {
                // Show local notification
                //showLocalNotification("\(NSLocalizedString("You_entered", comment: "")) \(region.identifier)")
            }
            //Macros.Constants.isInsideTheRegion = true
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didExitRegion region: CLRegion)
    {
        if region.identifier != "HE_Loc"
        {
            if UIApplication.shared.applicationState == .active
            {
                // Show enter location popup
                //self.showPopupForRegionStateChange(title: region.identifier, message: "\(NSLocalizedString("You_exited", comment: "")) \(region.identifier)")
            }else
            {
                // Show local notification
                //showLocalNotification("\(NSLocalizedString("You_exited", comment: "")) \(region.identifier)")
            }
            //Macros.Constants.isInsideTheRegion = false
        }else
        {
            if let location = manager.location?.coordinate {
                //startRegionMonitoring(location, notifyOnEntry: false, radiusGet: 100.0, identifierName: "HE_Loc")
            }
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateHeading newHeading: CLHeading) {
        print("trueHeading      : \(newHeading.trueHeading)")
        print("magneticHeading  : \(newHeading.magneticHeading)")
        print("HeadingAcuracy   : \(newHeading.headingAccuracy)")
        //Macros.Constants.azimuthDirection = newHeading.magneticHeading
        
        guard newHeading.headingAccuracy >= 1 else {
            return
        }
        
        //sendAzimuthAngleToServer()
    }
    
//    /// Web API call to send azimuth angle to server
//    func sendAzimuthAngleToServer()
//    {
//        if Macros.Constants.autoLogin == true {
//            if UIDevice.current.orientation == .landscapeLeft || UIDevice.current.orientation == .landscapeRight {
//                Macros.Constants.deviceOrientaion = true
//            }else {
//                Macros.Constants.deviceOrientaion = false
//            }
//
//            if UIDevice.current.orientation == .landscapeRight || UIDevice.current.orientation == .portraitUpsideDown {
//                if Macros.Constants.azimuthDirection >= 0 && Macros.Constants.azimuthDirection <= 179 {
//                    Macros.Constants.azimuthDirection = Macros.Constants.azimuthDirection + 180
//                }else {
//                    Macros.Constants.azimuthDirection = Macros.Constants.azimuthDirection - 180
//                }
//                //0 to 179 -> plus 180
//                //180 - 359 -> minus 180
//            }
//
//            let isAzimuthAPIWithParameter = Macros.ServiceName.updateAzimuthDirection + "?userID=\(Macros.Constants.userId)&azimuthDirection=\(Macros.Constants.azimuthDirection)&isLandscape=\(Macros.Constants.deviceOrientaion ?? false)"
//
//            Webservices.sharedInstance.postRequest(isAzimuthAPIWithParameter, parameters: [:], showLoader: false) { (response, status, error, time) in
//                if status == true && error == nil
//                {
//                    guard let result = ((response?.value(forKey: "Status") as? NSDictionary)?.value(forKey: "Result") as? String), result == "SUCCESS" else
//                    {
//                        return
//                    }
//                    // Singleton.sharedInstance.showToast(NSLocalizedString("Device angle updated successfully", comment: ""), duration: 3.0, view: nil)
//                }else {
//                    if error?.lowercased() == NSLocalizedString("OffLine_connection", comment: "")
//                    {
//                    }
//                }
//            }
//        }
//    }
    
    //MARK: BACKGROUND_UPDATE_TASK
    /**
     Begin background task for updating location on background.
     */
    func beginBackgroundUpdateTask()
    {
        self.backgroundUpdateTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            self?.endBackgroundTask()
        }
    }
    
    /**
     Setup background task for updating location on background.
     */
    func doBackgroundTask()
    {
        DispatchQueue.global(qos: DispatchQoS.QoSClass.default).async
            {
                // Do background work
                self.beginBackgroundUpdateTask()
                // Do something with the result.
                if self.locationManager.location == nil
                {
                    if UserDefaults.standard.value(forKey : "userLastLocationLat") != nil
                    {
                        //self.startRegionMonitoring(CLLocationCoordinate2DMake(Double(UserDefaults.standard.value(forKey : "userLastLocationLat") as! String)!, Double(UserDefaults.standard.value(forKey : "userLastLocationLong") as! String)!), notifyOnEntry: false, radiusGet: 100.0, identifierName: "HE_Loc")
                    }
                }else
                {
                    //self.startRegionMonitoring((self.locationManager.location?.coordinate)!, notifyOnEntry: false, radiusGet: 100.0, identifierName: "HE_Loc")
                }
        }
    }
    
    /**
     End background task when app is in foreground.
     */
    func endBackgroundTask()
    {
        UIApplication.shared.endBackgroundTask(self.backgroundUpdateTask)
        self.backgroundUpdateTask = UIBackgroundTaskInvalid
    }
    
    //MARK: CLLocation setup
    /**
     Authorization for location.
     */
    func updateCustomLocation()
    {
        if locationManager == nil
        {
            setupLocationManager(withDistanceFilter: true, distanceFilter: 50.0)
        }else
        {
            locationManager.distanceFilter = CLLocationDistance(50.0)
            locationManager.startUpdatingLocation()
        }
    }
    
    /// Set default location if app terminate.
    func defaultLocationOnAppTerminate()
    {
        self.doBackgroundTask()
    }
    
    /**
     Setup location manager setting for getting current location while moving.
     
     - Parameters:
     - withDistanceFilter: Distance filter true/false
     - distanceFilter: Value of distance filter
     */
    func setupLocationManager(withDistanceFilter: Bool = false, distanceFilter : Double = 50.0)
    {
        if locationManager != nil
        {
            locationManager.requestAlwaysAuthorization()
            return
        }
        
        locationManager = CLLocationManager()
        locationManager.delegate = self
        locationManager.pausesLocationUpdatesAutomatically = false
        if withDistanceFilter == true
        {
            locationManager.distanceFilter = CLLocationDistance(distanceFilter)
        }
        
        locationManager.desiredAccuracy = kCLLocationAccuracyBestForNavigation
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.requestAlwaysAuthorization()
        locationManager.startMonitoringSignificantLocationChanges()
        
        // Start heading updates.
        if CLLocationManager.headingAvailable() {
            locationManager.headingFilter = 1
            locationManager.startUpdatingHeading()
        }
    }
    
//    /**
//     Start region monitoring if app is in background and terminate mode, for updating current location on server.
//     */
//    func startRegionMonitoring(_ location: CLLocationCoordinate2D, notifyOnEntry: Bool = true, radiusGet : Double = 100.0, identifierName : String = "HE_Loc")
//    {
//        if locationManager == nil
//        {
//            setupLocationManager(withDistanceFilter: true, distanceFilter: 50.0)
//        }
//
//        if Macros.Constants.autoLogin == true
//        {
//            let region = CLCircularRegion(center: location, radius: radiusGet, identifier: identifierName)
//            region.notifyOnExit = true
//            region.notifyOnEntry = notifyOnEntry
//            locationManager.startMonitoring(for: region)
//        }
//    }
    
//    // MARK: Local notifications
//    /// Show local notification with message.
//    func showLocalNotification(_ message: String)
//    {
//        cleanAllNotifications()
//        let localNotification = UILocalNotification()
//        localNotification.alertBody = message
//        localNotification.fireDate = Date(timeIntervalSinceNow: 0.0)
//        localNotification.soundName = "dangerSound.caf"
//        UIApplication.shared.scheduleLocalNotification(localNotification)
//
//        let path = Bundle.main.path(forResource: "My_Hero_Alert", ofType: "mp3")
//        Singleton.sharedInstance.playSound(5.0, filePath: path!)
//    }
    
//    /// To remove location alert label
//    func removeLocationAlertLabel()
//    {
//        if Macros.Constants.locationAlertLabel != nil
//        {
//            Macros.Constants.locationAlertLabel.removeFromSuperview()
//        }
//    }
    
//    /**
//     To check whether user is inside the region or not without identifier.
//     */
//    func checkIfUserInsideTheRegionShowPopUp()
//    {
//        Singleton.sharedInstance.checkLocationService { (isEnabled) in
//            if isEnabled == true
//            {
//                for regionsCustom in self.locationManager.monitoredRegions
//                {
//                    guard let circularRegion = regionsCustom as? CLCircularRegion, circularRegion.identifier != "HE_Loc", let coordinate = self.locationManager.location?.coordinate else { return }
//
//                    if circularRegion.contains(coordinate)
//                    {
//                        // Current Location with in inside Geo Fence
//                        self.showPopupForRegionStateChange(title: regionsCustom.identifier, message: "\(NSLocalizedString("You_inside", comment: "")) \(regionsCustom.identifier)")
//                        break
//                    }
//                }
//            }else
//            {
//                Singleton.sharedInstance.showAlertWithText(NSLocalizedString("Enable_Location_Services_Title", comment: ""), text:NSLocalizedString("Enable_Location_Services_Msg", comment: ""), target: nil)
//            }
//        }
//    }
    
    /**
     To check whether user is inside the region or not with identifier.
     */
    func checkIfUserInsideTheRegion(identifier : String) -> Bool
    {
        print(locationManager)
        print(locationManager.monitoredRegions)
        
        for regionsCustom in locationManager.monitoredRegions
        {
            if let circularRegion = regionsCustom as? CLCircularRegion, circularRegion.identifier == identifier, let coordinate = self.locationManager.location?.coordinate
            {
                if circularRegion.contains(coordinate)
                {
                    // Current Location with in inside Geo Fence
                    return true
                }
            }
        }
        return false
    }
    
//    /**
//     To check whether geofence setup or not.
//     */
//    func checkIfRegisteredToGeofence(_ identifier : String) -> Bool
//    {
//        if locationManager == nil
//        {
//            setupLocationManager()
//        }
//
//        for regionsCustom in locationManager.monitoredRegions
//        {
//            if regionsCustom.identifier == identifier
//            {
//                return true
//            }
//        }
//
//        return false
//
//    }
    
//    /**
//     To remove all geofences.
//     */
//    func removeAllgeofences()
//    {
//        if locationManager == nil
//        {
//            setupLocationManager()
//        }
//
//        for regionsCustom in locationManager.monitoredRegions
//        {
//            locationManager.stopMonitoring(for: regionsCustom)
//        }
//    }
    
//    //MARK: Region popups
//    func showPopupForRegionStateChange(title : String, message: String)
//    {
//        Singleton.sharedInstance.showPopupForWithCustomArguments(title: title, message: message)
//    }
}
