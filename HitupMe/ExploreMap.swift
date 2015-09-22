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

class ExploreMap: UIViewController, MKMapViewDelegate {
    
    func initialSetup() {
        var nc : DefaultNavController? = navigationController as? DefaultNavController
        if nc != nil {
            nc?.setIsMapTab(true)
            savedSegmentControl = nc?.passSwitch()
            savedSegmentControl?.addTarget(self, action: Selector("switchChange:"), forControlEvents: UIControlEvents.ValueChanged)
        }
    }
    
    func showSwitch(show: Bool) {
        if show == true {
            var nc : DefaultNavController? = navigationController as? DefaultNavController
            if nc != nil {
                nc?.showSwitch(show)
            }
        } else {
            var nc : DefaultNavController? = navigationController as? DefaultNavController
            if nc != nil {
                nc?.showSwitch(show)
            }
        }
    }
    
    @IBOutlet var mapView: MKMapView!
    @IBAction func touchRefresh(sender: AnyObject) {
        Functions.updateLocation()
        refreshMap { (success) -> Void in
        }
    }
    
    var hitupToSend = PFObject(className: "Hitups")
    var savedSegmentControl : UISegmentedControl?
    var activeOnly = false
    var todayOnly = false
    
    func switchChange(sender: UISegmentedControl) {
        if (sender.selectedSegmentIndex == 1) {
            // Today
            activeOnly = false
            todayOnly = true
            refreshMap({ (success) -> Void in
                
            })
            /*
        } else if ( sender.selectedSegmentIndex == 1) {
            // Active
            activeOnly = true
            todayOnly = false
            refreshMap()*/
        } else {
            // All
            activeOnly = false
            todayOnly = false
            refreshMap({ (success) -> Void in
            
            })
        }
    }
    
    func refreshMap( completion: (( success: Bool? ) -> Void)) {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        if PermissionRelatedCalls.locationEnabled() == false {
            completion(success: false)
            Functions.promptLocationTo(self, message: "Aw 💩! Please enable location to see Hitups.")
            Functions.updateLocation()
        } else {
            
            HighLevelCalls.updateExploreHitups(activeOnly, isTodayOnly: todayOnly, completion: { (success, objects) -> Void in
                if success == true {
                    println( objects!.count, "Objects")
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    var defaults = NSUserDefaults.standardUserDefaults()
                    var latitude = defaults.doubleForKey("latitude")
                    var longitude = defaults.doubleForKey("longitude")
                    
                    self.mapView.showsUserLocation = true
                    
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
                        completion(success: true )
                        /*if (self.activeOnly == true || self.todayOnly == true) {
                            self.centerMapOnLocation(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        } else {
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        }*/
                        if self.mapView.annotations.count <= 1 {
                            self.centerMapOnLocation(CLLocationCoordinate2D(latitude: latitude, longitude: longitude))
                        } else {
                            self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                        }
                        
                        
                    } // if casted sucessfully
                } else { // success == true
                    completion(success: false )
                }
                
            }) // updateNearbyHitups
        } // Location enabled
    }
    
    // Set Radius of Map View
    var regionRadius: CLLocationDistance = 6000
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
                
                /*
                var leftView = UIView(frame: CGRectMake(0, 0, 52, 52))
                var profilePicView = UIImageView(frame: CGRectMake(0, 9, 30, 30))
                profilePicView.center = CGPointMake(leftView.frame.size.width/2, profilePicView.center.y)
                var nameLabel = UILabel(frame: CGRectMake(0, 34, 52, 20))
                nameLabel.textAlignment = NSTextAlignment.Center
                nameLabel.font = nameLabel.font.fontWithSize(8)
                nameLabel.text = hitup?.objectForKey("user_hostName") as? String
                leftView.addSubview(nameLabel)
                leftView.addSubview(profilePicView)
                
                pinView?.leftCalloutAccessoryView = leftView
                pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIView
                // Set Profile Picture
                var id = hitup?.objectForKey("user_host") as? String
                Functions.getSmallPictureFromFBId(id!, completion: { (image) -> Void in
                    profilePicView.image = image
                })
                */
                
                //var gest = UIGestureRecognizer(target: self, action: Selector(""))
                //pinView?.addGestureRecognizer(gest)
                
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
                /*
                var leftView = UIView(frame: CGRectMake(0, 0, 52, 52))
                var profilePicView = UIImageView(frame: CGRectMake(0, 9, 30, 30))
                profilePicView.center = CGPointMake(leftView.frame.size.width/2, profilePicView.center.y)
                var nameLabel = UILabel(frame: CGRectMake(0, 34, 52, 20))
                nameLabel.textAlignment = NSTextAlignment.Center
                nameLabel.font = nameLabel.font.fontWithSize(8)
                nameLabel.text = hitup?.objectForKey("user_hostName") as? String
                leftView.addSubview(nameLabel)
                leftView.addSubview(profilePicView)
                
                pinView?.leftCalloutAccessoryView = leftView
                pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.InfoLight) as! UIView
                // Set Profile Picture
                var id = hitup?.objectForKey("user_host") as? String
                Functions.getSmallPictureFromFBId(id!, completion: { (image) -> Void in
                    profilePicView.image = image
                })
                */
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
        performSegueWithIdentifier("showMapDetail", sender: nil)
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
        Functions.updateLocationinBack { (success) -> Void in
            if Functions.refreshTab(1) == true {
                self.refreshMap({ (success) -> Void in
                    
                })
            } else {
                
            }
        }
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        //facebook
        Functions.updateFacebook { (success) -> Void in
            
        }
        
        showSwitch(true)
        if Functions.refreshTab(1) == true {
            self.refreshMap({ (success) -> Void in
                
            })
        } else {
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Showing Detail")
        showSwitch(false)
        if segue.identifier == "showMapDetail" {
            //showSwitch(false)
            var detailController : HitupDetailViewController = segue.destinationViewController as! HitupDetailViewController
            detailController.thisHitup = hitupToSend
        }
        
    }
    
}
