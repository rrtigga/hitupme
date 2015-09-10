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
    
    func refreshMap() {
        HighLevelCalls.updateNearbyHitups { (success, objects) -> Void in
            if success == true {
                
                self.mapView.removeAnnotations(self.mapView.annotations)
                
                self.mapView.showsUserLocation = true
                self.mapView.centerCoordinate =  CLLocationCoordinate2D( latitude: LocationManager.sharedInstance.lastKnownLatitude, longitude: LocationManager.sharedInstance.lastKnownLongitude)
                
                if let objects = objects as? [PFObject] {
                    for object in objects {
                        var thisHitup = object
                        var coords = thisHitup.objectForKey("coordinates") as! PFGeoPoint
                        
                        var annotation = MKPointAnnotation()
                        annotation.title = thisHitup.objectForKey("header") as? String
                        annotation.coordinate = CLLocationCoordinate2D(latitude: coords.latitude, longitude: coords.longitude)
                        
                        self.mapView.addAnnotation(annotation)
                    } // For object in objects
                    self.mapView.showAnnotations(self.mapView.annotations, animated: true)
                } // if casted sucessfully
            } // success == true
        } // updateNearbyHitups
    }

    /*
    func mapView(mapView: MKMapView!, viewForAnnotation annotation: MKAnnotation!) -> MKAnnotationView! {
            
            let reuseId = "pin"
            var pinView = mapView.dequeueReusableAnnotationViewWithIdentifier(reuseId) as? MKPinAnnotationView
            if pinView == nil {
                pinView = MKPinAnnotationView(annotation: annotation, reuseIdentifier: reuseId)
                pinView!.canShowCallout = true
                pinView!.animatesDrop = true
                pinView!.pinColor = .
            }
            else {
                pinView!.annotation = annotation
            }
            
            return pinView
    }*/
    
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
    
}
