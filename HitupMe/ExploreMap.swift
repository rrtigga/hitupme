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
    
    @IBOutlet var mapView: MKMapView!
    @IBAction func touchRefresh(sender: AnyObject) {
        refreshMap()
    }
    var hitupToSend = PFObject(className: "Hitups")
    
    func refreshMap() {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        if PermissionRelatedCalls.locationEnabled() == false {
            Functions.promptLocationTo(self, message: "Aw 💩! Please enable location to see Hitups.")
            Functions.updateLocation()
        } else {
            
            HighLevelCalls.updateExploreHitups { (success, objects) -> Void in
                if success == true {
                    
                    self.mapView.removeAnnotations(self.mapView.annotations)
                    
                    self.mapView.showsUserLocation = true
                    self.mapView.centerCoordinate =  CLLocationCoordinate2D( latitude: LocationManager.sharedInstance.lastKnownLatitude, longitude: LocationManager.sharedInstance.lastKnownLongitude)
                    
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
                            annotation.coordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
                            annotation.hitup = thisHitup
                            
                            self.mapView.addAnnotation(annotation)
                            
                        } // For object in objects
                        self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                    } // if casted sucessfully
                } // success == true
            } // updateNearbyHitups
        } // Location enabled
    }

    
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
        
        if (annotation is MKUserLocation) {
            return nil
            
        } else {
        
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
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
                
                pinView?.rightCalloutAccessoryView = UIButton.buttonWithType(UIButtonType.DetailDisclosure) as! UIView
                
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
            }
            
            return pinView
        }
        
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
        mapView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        if Functions.refreshTab(1) == true {
            refreshMap()
        } else {
            
        }
    }
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Showing Detail")
        if segue.identifier == "showMapDetail" {
            var detailController : HitupDetailViewController = segue.destinationViewController as! HitupDetailViewController
            detailController.thisHitup = hitupToSend
        }
        
    }
    
}
