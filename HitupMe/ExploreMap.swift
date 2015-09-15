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
        if defaults.boolForKey("locationEnabled") == false {
            Functions.promptLocationTo(self, message: "Aw 💩! Please enable location to see Hitups.")
            Functions.updateLocation()
        } else {
            
            HighLevelCalls.updateNearbyHitups { (success, objects) -> Void in
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
                var user_hosted = hitup?.objectForKey("user_host") as! String
                var users_joined = hitup?.objectForKey("users_joined") as! [AnyObject]
                var currentUser_fbId = PFUser.currentUser()!.objectForKey("fb_id") as! String
                
                if(currentUser_fbId == user_hosted) {
                    // User is host
                    pinView!.pinColor = MKPinAnnotationColor.Green
                } else if ( (users_joined as NSArray).containsObject(currentUser_fbId) ) {
                    // Joined
                    pinView!.pinColor = MKPinAnnotationColor.Green
                } else {
                    // Not Responded
                    pinView!.pinColor = MKPinAnnotationColor.Red
                }
                
                
            } else {
                pinView!.annotation = annotation
            }
            
            return pinView
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
