//
//  Functions.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class Functions: NSObject {
    
    
    // ----- These functions manage refreshing of each tab ----- //
    
    class func refreshTab(num:NSNumber) -> Bool {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        switch num {
            case 0:
                var refresh = defaults.objectForKey("refreshTab0") as! Bool
                defaults.setObject(false, forKey: "refreshTab0")
                return refresh
            case 1:
                var refresh = defaults.objectForKey("refreshTab1") as! Bool
                defaults.setObject(false, forKey: "refreshTab1")
                return refresh
            case 2:
                var refresh = defaults.objectForKey("refreshTab2") as! Bool
                defaults.setObject(false, forKey: "refreshTab2")
                return refresh
            case 3:
                var refresh = defaults.objectForKey("refreshTab3") as! Bool
                defaults.setObject(false, forKey: "refreshTab3")
                return refresh
            default:
                println("Unexpected number: %i", num)
                return true
            }
    }
    
    class func setRefreshAllTabsTrue() {
        for (var i=0; i<4; i++) {
            Functions.setRefreshTabTrue(i)
        }
    }
    
    class func setRefreshTabTrue(num:NSNumber) {
        var defaults = NSUserDefaults.standardUserDefaults()
        switch num {
        case 0:
            defaults.setObject(true, forKey: "refreshTab0")
        case 1:
            defaults.setObject(true, forKey: "refreshTab1")
        case 2:
            defaults.setObject(true, forKey: "refreshTab2")
        case 3:
            defaults.setObject(true, forKey: "refreshTab3")
        default:
            println("Unexpected number:", num)
        }
    }
    
    
    class func themeColor() -> UIColor {
    return Functions.colorWithHexString("F9687E")
    }
    
    class func defaultFadedColor() -> UIColor {
    return Functions.colorWithHexString("F6F6F6")
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
            
            if error != nil {
                println("Erorr updating Location, trying again", error)
            } else if error == nil {
                println("lat:\(latitude) lon:\(longitude)")
                //println(verboseMessage)
                var defaults = NSUserDefaults.standardUserDefaults()
                defaults.setDouble(latitude, forKey: "latitude")
                defaults.setDouble(longitude, forKey: "longitude")
                locationManager.stopUpdatingLocation()
                
                locationManager.reverseGeocodeLocationUsingGoogleWithLatLon(latitude: latitude, longitude: longitude, onReverseGeocodingCompletionHandler: { (reverseGecodeInfo, placemark, error) -> Void in
                    var geoInfo: NSDictionary = reverseGecodeInfo! as NSDictionary
                    println( geoInfo["locality"], geoInfo["postalCode"])
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
    }
    
    class func updateFacebook( completion: ((success: Bool?) -> Void)) {
        var requestMe = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name", parameters: nil)
        var requestFriends = FBSDKGraphRequest(graphPath: "me?fields=friends{first_name,last_name}", parameters: nil)
        var connection = FBSDKGraphRequestConnection()
        connection.addRequest(requestMe, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(result, forKey: "userInfo_dict")
            } else {
                completion(success: false)
            }
        })
        connection.addRequest(requestFriends, completionHandler: { (connection, result, error: NSError!) -> Void in
        
            if error == nil {
            var friends = result["friends"] as! NSDictionary
            var friendData = friends["data"] as! NSArray
            var defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(friendData, forKey: "arrayOfFriend_dicts")
            completion(success: true)
            } else {
                completion(success: false)
            }
        })
        
        connection.start()
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
