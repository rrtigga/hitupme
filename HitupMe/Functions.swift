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
        
        let defaults = NSUserDefaults.standardUserDefaults()
        switch num {
            case 0:
                let refresh = defaults.objectForKey("refreshTab0") as! Bool
                defaults.setObject(false, forKey: "refreshTab0")
                return refresh
            case 1:
                let refresh = defaults.objectForKey("refreshTab1") as! Bool
                defaults.setObject(false, forKey: "refreshTab1")
                return refresh
            case 2:
                let refresh = defaults.objectForKey("refreshTab2") as! Bool
                defaults.setObject(false, forKey: "refreshTab2")
                return refresh
            case 3:
                let refresh = defaults.objectForKey("refreshTab3") as! Bool
                defaults.setObject(false, forKey: "refreshTab3")
                return refresh
            default:
                print("Unexpected number: %i", num)
                return true
            }
    }
    
    class func setRefreshAllTabsTrue() {
        for (var i=0; i<4; i++) {
            Functions.setRefreshTabTrue(i)
        }
    }
    
    class func updateLocation() {
        LocationManager.sharedInstance.startUpdatingLocation()
    }
    
    class func updateLocationinBack( completion:(success: Bool) -> Void) {
        LocationManager.sharedInstance.waitForLocation { (success2) -> Void in
            completion(success: true)
        }
    }
    
    class func setRefreshTabTrue(num:NSNumber) {
        let defaults = NSUserDefaults.standardUserDefaults()
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
            print("Unexpected number:", num)
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
        let urL: NSURL = NSURL(string: String(format: "https://graph.facebook.com/%@/picture?type=large", fbId) )!
        let request = NSURLRequest(URL: urL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if (data == nil) {
                completion( image: UIImage(named: "SHIBA"))
            } else {
                completion( image: UIImage(data: data!) )
            }
        }
    }
    
    class func getSmallPictureFromFBId(fbId:String, completion: ((image: UIImage?) -> Void)) {
        let urL: NSURL = NSURL(string: String(format: "https://graph.facebook.com/%@/picture?type=small", fbId) )!
        let request = NSURLRequest(URL: urL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if (data == nil) {
                completion( image: UIImage(named: "SHIBA"))
            } else {
                completion( image: UIImage(data: data!) )
            }
        }
    }
    
    class func getMediumPictureFromFBId(fbId:String, completion: ((image: UIImage?) -> Void)) {
        let urL: NSURL = NSURL(string: String(format: "https://graph.facebook.com/%@/picture", fbId) )!
        let request = NSURLRequest(URL: urL)
        NSURLConnection.sendAsynchronousRequest(request, queue: NSOperationQueue.mainQueue()) {
            (response: NSURLResponse?, data: NSData?, error: NSError?) -> Void in
            if (data == nil) {
                completion( image: UIImage(named: "SHIBA"))
            } else {
                completion( image: UIImage(data: data!) )
            }
        }
    }
    
    class func initializeUserDefaults() {
        let defaults = NSUserDefaults.standardUserDefaults()
        if nil == defaults.objectForKey("city") {
            defaults.setObject("Location Not Enabled? 😢", forKey: "city")
        }
        if nil == defaults.objectForKey("state") {
            defaults.setObject("", forKey: "state")
        }
        if nil == defaults.objectForKey("postalCode") {
            defaults.setObject("", forKey: "postalCode")
        }
        if nil == defaults.objectForKey("state") {
            defaults.setObject("", forKey: "state")
        }
        if nil == defaults.objectForKey("locationEnabled") {
            defaults.setBool(false, forKey: "locationEnabled")
        }
        if nil == defaults.objectForKey("latitude") {
            defaults.setObject(37.3175, forKey: "latitude")
        }
        if nil == defaults.objectForKey("longtitude") {
            defaults.setObject( 122.0419, forKey: "longtitude")
        }
    }
    
    /*class func updateLocationinBack(completion: ((success: Bool?) -> Void)) {
        let locationManager = LocationManager.sharedInstance
        
        
        locationManager.showVerboseMessage = false
        locationManager.autoUpdate = true
        locationManager.startUpdatingLocationWithCompletionHandler { (latitude, longitude, status, verboseMessage, error) -> () in
            if error != nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setDouble(latitude, forKey: "latitude")
                defaults.setDouble(longitude, forKey: "longitude")
                completion(success: false)
            } else {
                 print("lat:\(latitude) lon:\(longitude)")
                completion(success: true)
            }
        }
    }*/
    
    class func promptLocationTo(vc: UIViewController, message:String) {
        let alert = UIAlertController(title: message, message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Enable", style: UIAlertActionStyle.Default, handler: { action in
            let appSettings = NSURL(string: UIApplicationOpenSettingsURLString)
            UIApplication.sharedApplication().openURL(appSettings!)
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: { action in
        }))
        
        vc.presentViewController(alert, animated: true, completion: nil)
    }
    
    class func updateFacebook( completion: ((success: Bool?) -> Void)) {
        let requestMe = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name", parameters: nil)
        let requestFriends = FBSDKGraphRequest(graphPath: "me?fields=friends{first_name,last_name}", parameters: nil)
        let connection = FBSDKGraphRequestConnection()
        connection.addRequest(requestMe, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
            let defaults = NSUserDefaults.standardUserDefaults()
            defaults.setObject(result, forKey: "userInfo_dict")
            } else {
                completion(success: false)
            }
        })
        connection.addRequest(requestFriends, completionHandler: { (connection, result, error: NSError!) -> Void in
        
            if error == nil {
                // Save Raw Friend Information
                let friends = result["friends"] as! NSDictionary
                let friendData = friends["data"] as! NSArray
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(friendData, forKey: "arrayOfFriend_dicts")
                
                // Save Array of friend IDs
                var idArray = [AnyObject]()
                let userInfo_dict = defaults.objectForKey("userInfo_dict") as! NSDictionary
                idArray.insert(userInfo_dict.objectForKey("id") as! String, atIndex:0)
                for friend in friendData {
                    let dict : NSDictionary? = friend as? NSDictionary
                    
                    if dict != nil {
                        if var id = dict!.objectForKey("id") as? String {
                            idArray.insert(dict!.objectForKey("id")!, atIndex:0)
                        } else {
                            print("Functions: id missing?")
                        }

                    } else {
                        print("Functions: dict missing?")
                    }
                    
                }
                defaults.setObject(idArray, forKey: "friend_ids")
                
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
        
        if (cString.characters.count != 6) {
            return UIColor.grayColor()
        }
        
        let rString = (cString as NSString).substringToIndex(2)
        let gString = ((cString as NSString).substringFromIndex(2) as NSString).substringToIndex(2)
        let bString = ((cString as NSString).substringFromIndex(4) as NSString).substringToIndex(2)
        
        var r:CUnsignedInt = 0, g:CUnsignedInt = 0, b:CUnsignedInt = 0;
        NSScanner(string: rString).scanHexInt(&r)
        NSScanner(string: gString).scanHexInt(&g)
        NSScanner(string: bString).scanHexInt(&b)
        
        
        return UIColor(red: CGFloat(r) / 255.0, green: CGFloat(g) / 255.0, blue: CGFloat(b) / 255.0, alpha: CGFloat(1))
    }
    
}
