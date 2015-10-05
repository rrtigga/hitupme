//
//  ExploreMap.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/10/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import MapKit
import Parse

class ProfileMapView: UIViewController, MKMapViewDelegate {
    
    var userID : String?
    var userName : String?
    
    
    
    func initialSetup() {
    }
    
   
    
    @IBOutlet var mapView: MKMapView!
    @IBAction func touchRefresh(sender: AnyObject) {
        Functions.updateLocation()
        refreshMap()
    }
    
    
    var hitupToSend = PFObject(className: "Hitups")
    var savedSegmentControl : UISegmentedControl?
    var activeOnly = false
    
    func switchChange(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 0) {
            // All
            activeOnly = false
            refreshMap()
        } else {
            // Active Only
            activeOnly = true
            refreshMap()
        }
    }
    
    func refreshMap() {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        if PermissionRelatedCalls.locationEnabled() == false {
            Functions.promptLocationTo(self, message: "Aw 💩! Please enable location to see Hitups.")
            Functions.updateLocation()
        } else {
            
            HighLevelCalls.updateProfileMapHitups(userID!, completion: { (success, objects) -> Void in
                if success == true {
                    println( objects!.count, "Objects")
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    var defaults = NSUserDefaults.standardUserDefaults()
                    var latitude = defaults.doubleForKey("latitude")
                    var longitude = defaults.doubleForKey("longitude")
                    
                    //self.mapView.showsUserLocation = true
                    self.mapView.showsUserLocation = false
                    
                    if let objects = objects as? [PFObject] {
                        for object in objects {
                            var thisHitup = object
                            var coords = thisHitup.objectForKey("coordinates") as! PFGeoPoint
                            
                            var annotation = HitupAnnotation()
                            var host = thisHitup.objectForKey("user_hostName") as? String
                            var header = thisHitup.objectForKey("header") as? String
                            var users_joined = thisHitup.objectForKey("users_joined") as! [AnyObject]
                            
                            annotation.title = header
                            annotation.subtitle = String(format: "%i joined", (users_joined.count - 1) )
                            //annotation.subtitle = host
                            annotation.coordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
                            annotation.hitup = thisHitup
                            
                            self.mapView.addAnnotation(annotation)
                            
                        } // For object in objects
                        if (self.activeOnly == false) {
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        } else {
                            self.centerMapOnLocation(self.mapView.userLocation.coordinate)
                        }
                    } // if casted sucessfully
                } // success == true
            }) // updateNearbyHitups
        } // Location enabled
    }
    
    // Set Radius of Map View
    var regionRadius: CLLocationDistance = 5000
    func centerMapOnLocation( coords :CLLocationCoordinate2D) {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(coords, regionRadius * 2.0, regionRadius * 2.0)
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if (annotation is MKUserLocation) {
            return nil
            
        } else {
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? HitupAnnotationView
            if pinView == nil {
                pinView = HitupAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = false
                pinView!.animatesDrop = true
                
                
                var hAnnotation = annotation as! HitupAnnotation
                var hitup = hAnnotation.hitup
                
                
                // Set Active/nonActive
                var expireDate : NSDate? = hitup!.objectForKey("expire_time") as? NSDate
                if (expireDate == nil) {
                    pinView!.pinColor = MKPinAnnotationColor.Red
                } else {
                    if ( NSDate().compare(expireDate!) == NSComparisonResult.OrderedAscending) {
                        pinView!.pinColor = MKPinAnnotationColor.Green
                    } else {
                        pinView!.pinColor = MKPinAnnotationColor.Red
                    }
                }
                
                
            } else {
                pinView!.annotation = annotation
                
                
                var hAnnotation = annotation as! HitupAnnotation
                var hitup = hAnnotation.hitup
                
                
                // Set Active/nonActive
                var expireDate : NSDate? = hitup!.objectForKey("expire_time") as? NSDate
                if (expireDate == nil) {
                    pinView!.pinColor = MKPinAnnotationColor.Red
                } else {
                    if ( NSDate().compare(expireDate!) == NSComparisonResult.OrderedAscending) {
                        pinView!.pinColor = MKPinAnnotationColor.Green
                    } else {
                        pinView!.pinColor = MKPinAnnotationColor.Red
                    }
                }

            }
            
            return pinView
        }
        
    }
    
    func mapView(mapView: MKMapView!, didSelectAnnotationView view: MKAnnotationView!) {
        
        // Save Hitup to be used in Segue
        var annotation: HitupAnnotation? = view.annotation as? HitupAnnotation
        if (annotation != nil) {
            
            var calloutView = HitupCalloutView.initView()
            
            hitupToSend = annotation!.hitup!
            var hitup = hitupToSend
            var header = hitup.objectForKey("header") as! String
            var name = hitup.objectForKey("user_hostName") as? String
            calloutView.headerLabel.text = header
            calloutView.nameLabel.text = name
            
            // Set Image
            if let fb_id = hitup.objectForKey("user_host") as? String {
                Functions.getPictureFromFBId(fb_id, completion: { (image) -> Void in
                    calloutView.profilePic.image = image
                })
            }
            
            var formatter = NSDateFormatter()
            formatter.dateFormat = "M/d"
            var expireDate : NSDate? = hitup.objectForKey("expire_time") as? NSDate
            if (expireDate == nil) {
                calloutView.timeLabel.text = "Ended"
            } else {
                if ( NSDate().compare(expireDate!) == NSComparisonResult.OrderedAscending) {
                    var seconds =  NSDate().timeIntervalSinceDate(expireDate!) * -1
                    calloutView.timeLabel.text = String(format: "%.0f min left", seconds / 60)
                } else {
                    calloutView.timeLabel.text = String(format:"Ended %@", formatter.stringFromDate(expireDate!))
                }
            }
            
            
            var joinedArray = hitup.objectForKey("users_joined") as! [AnyObject]
            calloutView.joinLabel.text = String(format: "%i joined", joinedArray.count - 1)
            
            calloutView.addTarget(self, action: Selector("touchCallout"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(calloutView)
        }
    }
    
    /// If user unselects callout annotation view, then remove it.
    
    func mapView(mapView: MKMapView!, didDeselectAnnotationView view: MKAnnotationView!) {
        for subView in view.subviews {
            subView.removeFromSuperview()
        }
    }
    
    func touchCallout() {
        var pmv = storyboard!.instantiateViewControllerWithIdentifier("MapDetail") as! HitupDetailViewController
        pmv.thisHitup = hitupToSend
        navigationController!.showViewController(pmv, sender: self)
    }
    
    func mapView(mapView: MKMapView!, annotationView view: MKAnnotationView!, calloutAccessoryControlTapped control: UIControl!) {
        println("dd:")
        
        var annotation: HitupAnnotation? = view.annotation as? HitupAnnotation
        if (annotation != nil) {
            hitupToSend = annotation!.hitup!
            performSegueWithIdentifier("showMapDetail", sender: nil)
        }
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        PermissionRelatedCalls.requestNotifications()
        
        mapView.delegate = self
        self.refreshMap()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.refreshMap()
        navigationItem.title = userName! + "'s " + "Hitups"

    }
    
}
