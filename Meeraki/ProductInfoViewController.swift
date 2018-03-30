//
//  ProductInfoViewController.swift
//  Meeraki
//
//  Created by NILESH_iOS on 29/03/18.
//  Copyright © 2018 iDev. All rights reserved.
//

import UIKit
import MapKit
import GoogleMaps
import GooglePlaces

class ProductInfoViewController: UIViewController {

    @IBOutlet var mapBaseView: UIView!
    /// Google maps object
    var objGMVC : GoogleMapViewController!
    /// maker for lat
    var marker_Lat:CLLocationDegrees! = nil
    /// maker for long
    var marker_Long:CLLocationDegrees! = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        initializeGoogleMap()
        
        addShadowEffectToViewWithSize(mapBaseView, cornerRadius: 5.0, size: 10.0, border: UIColor.green)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    /// Initialize google map
    func initializeGoogleMap()
    {
        if Macros.Constants.userCurrentLat != nil
        {
            //GraysLoader.sharedInstance.showLoader(NSLocalizedString("Restoring", comment: ""), blockUI: true, passedView: nil)
            self.addMapToView()
            return
        }else
        {
            //GraysLoader.sharedInstance.showLoader(NSLocalizedString("Restoring", comment: ""), blockUI: true, passedView: nil)
            Singleton.shared.delay(2.0, closure:
                {
                    if Macros.Constants.userCurrentLat != nil
                    {
                        self.addMapToView()
                    }
            })
        }
    }
    
    func addShadowEffectToViewWithSize(_ view : UIView, cornerRadius : CGFloat, size : CGFloat, border color: UIColor)
    {
        if cornerRadius > 0.0
        {
            // corner radius
            view.layer.cornerRadius = cornerRadius
            view.layer.borderColor = color.cgColor
            //border
            view.layer.borderWidth = 1
        }
        
        //shodow effect
        view.layer.shadowColor = UIColor.black.cgColor
        view.layer.shadowOffset = CGSize(width: 2, height: 2)
        view.layer.shadowOpacity = 0.65
        view.layer.shadowRadius = size
    }
    
    /**
     Adding google map to tracking view controller
     */
    func addMapToView()
    {
        if objGMVC == nil
        {
            objGMVC = GoogleMapViewController()
            objGMVC.showCurrentLoc = true
            objGMVC.mapType = .currentLoc
            objGMVC.currentLoc = CLLocationCoordinate2DMake(Macros.Constants.userCurrentLat, Macros.Constants.userCurrentLong)
            objGMVC.view.frame = mapBaseView.bounds
            objGMVC.view.autoresizingMask = [.flexibleWidth, .flexibleHeight]
            objGMVC.customMapView.padding = UIEdgeInsetsMake(0.0, 0.0, 0.0, 0.0)
            objGMVC.showCurrentLocBTN = true
            self.addChildViewController(objGMVC)
            self.mapBaseView.addSubview(self.objGMVC.view)
            objGMVC.delegate = self
        }
        
        Singleton.shared.delay(4)
        {
            //self.WebServiceToSetCurrentLocationOnServer()
        }
        
        // Delete this above for loop.
//        if Macros.Constants.organizationDetailObj != nil
//        {
//            Macros.Constants.orgGeoFenceModel =  objGMVC.drawAssociatedRegion(Macros.Constants.organizationDetailObj, true)
//        }
        
        //GraysLoader.sharedInstance.hideLoader()
        //mapSearchStackView.superview?.bringSubview(toFront: mapSearchStackView)
        //mapLocationStackView.superview?.bringSubview(toFront: mapLocationStackView)
    }

}

//MARK:- Google Map view controller delegate
extension ProductInfoViewController: GoogleMapViewControllerDelegate {
    /**
     To show Google Map Direction Btn tap on marker.
     */
    func showMapDirectionBtn()
    {
//        self.googleMapsDirectionBtn.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//        self.googleMapsDirectionBtn.alpha = 0
//        self.googleMapsDirectionBtn.isHidden = false
//        self.mapBaseTracking.bringSubview(toFront: self.googleMapsDirectionBtn)
//        UIView.animate(withDuration: 0.25, animations: {() -> Void in
//            self.googleMapsDirectionBtn.alpha = 1
//            self.googleMapsDirectionBtn.transform = CGAffineTransform(scaleX: 1, y: 1)
//        })
    }
    
    /**
     To hide Google Map Direction Btn tap on map view.
     */
    func hideMapDirectionBtn()
    {
//        UIView.animate(withDuration: 0.25, animations: {() -> Void in
//            self.googleMapsDirectionBtn.transform = CGAffineTransform(scaleX: 1.3, y: 1.3)
//            self.googleMapsDirectionBtn.alpha = 0.0
//        }, completion: {(finished: Bool) -> Void in
//            if finished {
//                self.googleMapsDirectionBtn.isHidden = true
//            }
//        })
    }
    
    /// To hide and show map type button
    func mapTypeButtonVisibility()
    {
        // Hiding unhiding map setting button.
//        if mapTypeButton.isHidden == false
//        {
//            mapTypeButton.isHidden = true
//        }else if mapTypeButton.isHidden == true
//        {
//            mapTypeButton.isHidden = false
//        }
    }
    
    //MARK: Google map view delegates
    /// This function will provide information that where the marker tap
    ///
    /// - Parameters:
    ///   - mapView: GMSMapView obj
    ///   - marker: Marker obj
    func mapViewMarkerTapped(_ mapView: GMSMapView, marker: GMSMarker)
    {
        if let myMarker = marker as? CustomMarker
        {
//            if myMarker.markerID != nil, (myMarker.markerID == 5 ||  myMarker.markerID == 6), Macros.Constants.orgGeoFenceModel != nil
//            {
//                marker_Lat = marker.position.latitude
//                marker_Long = marker.position.longitude
//                marker_LocName = marker.title
//            }
        }
    }
    
    /**
     Called when the marker's info window is closed.
     */
    func mapViewMarkerInfoSnippetDidClose()
    {
        hideMapDirectionBtn()
    }
    
    /**
     Called when the marker's info window is open.
     */
    func mapViewMarkerInfoSnippetDidOpen()
    {
        Singleton.shared.delay(0.3) {
            self.showMapDirectionBtn()
        }
    }
    
    /// Called after a tap gesture at a particular coordinate, but only if a marker was not tapped.
    ///
    /// - Parameters:
    ///   - mapView: The map view that was tap
    ///   - cordinate: The location that was tap
    func mapViewCordinateTap(_ mapView: GMSMapView, cordinate: CLLocationCoordinate2D)
    {
        mapTypeButtonVisibility()
    }
    
    /// Called after a long-press gesture at a particular coordinate.
    ///
    /// - Parameters:
    ///   - mapView: The map view that was long pressed
    ///   - cordinate: The location that was long pressed
    func mapViewCordinateLongPress(_ mapView: GMSMapView, cordinate: CLLocationCoordinate2D)
    {
//        objGMVC .getReverseGeoFromCordinate(cordinate, marker: nil) { (addModel) in
//            Singleton.sharedInstance.showAlertWithText(addModel.address, text: addModel.subLocal, target: self)
//        }
    }
    
    /// Called before the camera on the map changes, either due to a gesture, animation (e.g., by a user tapping on the "My Location" button) or by being updated explicitly via the camera or a zero-length animation on layer.
    ///
    /// - Parameters:
    ///   - mapView: The map view where dragged
    ///   - marker: The marker which is dragged
    func mapViewDidDrageed(_ mapView: GMSMapView, marker: GMSMarker!) {
        
    }
    
    /// Called when the map becomes idle, after any outstanding gestures or animations have completed (or after the camera has been explicitly set).
    ///
    /// - Parameters:
    ///   - mapView: The map view
    ///   - position: The camera position
    func idleMapViewAt(_ mapView: GMSMapView, idleAt position: GMSCameraPosition) {
        
    }
    
    
    /// Create marker and add marker at particular coordinate.
    ///
    /// - Parameters:
    ///   - loc: The location
    ///   - model: The user info model
//    func createMarkerAtLoc(_ loc : CLLocationCoordinate2D, model : FamilyListModel)
//    {
//        checkAndDeleteExistingMarkerForModel(model: model)
//        // Annotation Placer
//        let marker = CustomMarker()
//
//        let embeddedView = MarkerTracker(frame: CGRect(x: 0, y: 0, width: 55, height: 65))
//        embeddedView.downArrowBaseImgView.image = embeddedView.downArrowBaseImgView.image!.withRenderingMode(UIImageRenderingMode.alwaysTemplate)
//        embeddedView.userImage.imageFromUrl(model.imgURL, placeHolderImage: UIImage(named: "defaultUser"), shouldResize: true, showActivity: true)
//        embeddedView.downArrowBaseImgView.tintColor = Macros.Colors.yellowColor
//        embeddedView.userImage.layer.cornerRadius = CGFloat((65 * 0.62) / 2.0)
//        embeddedView.userImage.layer.masksToBounds = true
//        embeddedView.userImage.layer.borderColor = Macros.Colors.yellowColor.cgColor
//        embeddedView.userImage.layer.borderWidth = 1.0
//
//        if model.isPeerTrackable == false
//        {
//            let locCord =  CLLocationCoordinate2DMake(Double(model.lastLocationLat)! , Double(model.lastLocationLong)!)
//
//            marker.coordinate = locCord
//            marker.position = locCord
//
//        }else
//        {
//            marker.coordinate = loc
//            marker.position = loc
//        }
//        model.marker = marker
//        marker.iconView = embeddedView // Adding Xib View to base view.
//
//        self.objGMVC.placePinAtCoordinateWithTrackerUserName(marker, mapView: self.objGMVC.customMapView, name: model.name)
//    }
    
    
//    func checkAndDeleteExistingMarkerForModel(model : FamilyListModel)
//    {
//        if model.marker != nil
//        {
//            if model.marker.map != nil
//            {
//                model.marker.map = nil
//            }
//        }
//    }
}

struct Macros
{
    /// Variables to use globally in application
    struct Constants
    {
        /// To save user's current location's Latitude Globally
        static var userCurrentLat: CLLocationDegrees!
        /// To save user's current location's Longitude Globally
        static var userCurrentLong: CLLocationDegrees!
    }
}
