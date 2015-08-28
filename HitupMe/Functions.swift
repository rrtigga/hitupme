//
//  Functions.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class Functions: NSObject {
    
    class func themeColor() -> UIColor {
    return Functions.colorWithHexString("F9687E")
    }
    
    class func defaultFadedColor() -> UIColor {
    return Functions.colorWithHexString("ADB4BD")
    }
    
    class func defaultLocationColor() -> UIColor {
        return Functions.colorWithHexString("4A90E2")
    }
    
    class func getPictureFromFBId(fbId:String, completion: ((image: UIImage?) -> Void)) {
        var urL: NSURL = NSURL(string: String(format: "https://graph.facebook.com/%@/picture?type=large", fbId) )!
        let request = NSURLRequest(URL: urL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse!, data: NSData!, error: NSError!) -> Void in
            completion( image: UIImage(data: data) )
        }
        
    }
    
    class func updateLocation() {
        // Update one Guaranteed
        var locationManager = LocationManager.sharedInstance
        locationManager.showVerboseMessage = false
        locationManager.autoUpdate = true
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
            //println(verboseMessage)
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setDouble(latitude, forKey: "latitude")
            defaults.setDouble(longitude, forKey: "longitude")
            locationManager.stopUpdatingLocation()
            
            locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
                var geoInfo: NSDictionary = reverseGecodeInfo! as NSDictionary
                println( geoInfo)
                defaults.setValue( geoInfo["locality"] as! String, forKey: "city")
                defaults.setValue( geoInfo["administrativeArea"] as! String, forKey: "state")
                defaults.setValue( geoInfo["postalCode"] as! String, forKey: "postalCode")
            })
            
            
            
            // Update Location when significant changes
            locationManager.autoUpdate = false
            locationManager.startUpdatingLocationWithCompletionHandler(completionHandler: { (latitude, longitude, status, verboseMessage, error) -> () in
                println("lat:\(latitude) lon:\(longitude) status:\(status) error:\(error)")
                //println(verboseMessage)
                defaults.setDouble(latitude, forKey: "latitude")
                defaults.setDouble(longitude, forKey: "longitude")
                
                locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
                    var geoInfo: NSDictionary = reverseGecodeInfo! as NSDictionary
                    println( geoInfo)
                    defaults.setValue( geoInfo["locality"] as! String, forKey: "City")
                    defaults.setValue( geoInfo["administrativeArea"] as! String, forKey: "State")
                    defaults.setValue( geoInfo["postalCode"] as! String, forKey: "postalCode")
                })
            })
            
        }
    }
    
    class func colorWithHexString (hex:String) -> UIColor {
        var cString:String = hex.stringByTrimmingCharactersInSet(NSCharacterSet.whitespaceAndNewlineCharacterSet()).uppercaseString
        
        if (cString.hasPrefix("#")) {
            cString = (cString as NSString).substringFromIndex(1)
        }
        
        if (count(cString) != 6) {
            return UIColor.grayColor()
        }
        
        var rString = (cString as NSString).substringToIndex(2)
        var gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        var bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}
