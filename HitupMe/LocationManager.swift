//
//  LocationManager.swift
//  HitupMe
//
//  Created by Arthur Shir on 10/24/15.
//  Copyright © 2015 HitupDev. All rights reserved.
//

import UIKit
import MapKit

class LocationManager: NSObject, CLLocationManagerDelegate {
    static let sharedInstance = LocationManager()
    var coreLocMan: CLLocationManager
    var wait: Bool
    var lat: Double
    var lng: Double
    var coords: CLLocationCoordinate2D
    
    override init() {
        
        // Initialize Locaiton Manager with Accuracy
        coreLocMan = CLLocationManager()
        coreLocMan.desiredAccuracy = kCLLocationAccuracyHundredMeters
        
        // Get Stored Lat/Lng if saved
        let defaults = NSUserDefaults.standardUserDefaults()
        let latitude = defaults.objectForKey("latitude") as? Double
        let longitude = defaults.objectForKey("longitude") as? Double
        if (latitude != nil && longitude != nil) {
            lat = latitude!
            lng = longitude!
        } else {
            // If there is no saved location, set location as Fremont, CA
            lat = 121.9886
            lng = 37.5483
        }
        
        // Set Coordinates
        coords = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        
        wait = false
        
    }
    
    func startUpdatingLocation(){
        coreLocMan.startMonitoringSignificantLocationChanges()
    }
    
    func waitForLocation(completion:((success:Bool) -> Void)) {
        wait = true
        startUpdatingLocation()
        while (wait == true ) {
            completion(success: true)
        }
        
    }
    

    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if (locations.last != nil) {
            let mostRecentLoc = locations.last
            lat = (mostRecentLoc?.coordinate.latitude)!
            lng = (mostRecentLoc?.coordinate.longitude)!
            coords = CLLocationCoordinate2D(latitude: lat, longitude: lng)
        } else {
            print("LM: Location was nil?")
        }
        
        wait = false
    }
    
    
}
