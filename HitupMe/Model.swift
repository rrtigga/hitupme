//
//  Model.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/28/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class Model: NSObject {
    class func createKeysIfEmpty() {
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("NearbyHitups") == nil {
            defaults.setObject( NSArray(), forKey: "NearbyHitups")
        }
    }
    
    // ---------- Local Hitups ---------- //
    
    class func addToLocalNearbyHitups(hitupDict: NSDictionary){
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        // Save Hitup
        var savedNearbyHitups: NSMutableArray = (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        savedNearbyHitups.insertObject(hitupDict, atIndex: 0)
        defaults.setObject(savedNearbyHitups, forKey: "NearbyHitups")
        
    }
    
    class func getLocalNearbyHitups() -> NSMutableArray {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        return (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray

    }
    
    class func getLocalNearbyHitupsAtIndex(index: NSInteger) -> NSDictionary {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        return savedNearbyHitups.objectAtIndex(index) as! NSDictionary
    }
    
    class func getLocalNearbyHitupsCount() -> NSInteger {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        return savedNearbyHitups.count
    }
}
