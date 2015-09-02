//
//  Model.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/28/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

// For each insert, make sure its in the right order.

class Model: NSObject {
    
    
    
    class func createKeysIfEmpty() {
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.objectForKey("NearbyHitups") == nil {
            defaults.setObject( NSArray(), forKey: "NearbyHitups")
        }
        if defaults.objectForKey("MyHitups") == nil {
            defaults.setObject( NSArray(), forKey: "MyHitups")
        }
    }
    
    // ---------- Local Hitups ---------- //
    
    class func setLocalNearbyHitups(hitups: NSArray){
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(hitups, forKey: "NearbyHitups")
        
    }
    
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
    
    class func deleteLocalNearbyHitupAtIndex(index: NSInteger) {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        savedNearbyHitups.removeObjectAtIndex(index)
        defaults.setObject(savedNearbyHitups, forKey: "NearbyHitups")
    }
    
    class func getLocalNearbyHitupsCount() -> NSInteger {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        return savedNearbyHitups.count
    }
    
    class func setJoinLocalNearbyHitupsAtIndex(index: NSInteger, joined:Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("NearbyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        var hitup = (savedNearbyHitups.objectAtIndex(index).mutableCopy()) as! NSDictionary
        hitup.setValue(joined, forKey: "joined")
        savedNearbyHitups.replaceObjectAtIndex(index, withObject: hitup)
        defaults.setObject(savedNearbyHitups, forKey: "NearbyHitups")
    }
    
    // ---------- My Hitups ---------- //
    
    class func setMyHitups(hitups: NSArray){
        var defaults = NSUserDefaults.standardUserDefaults()
        defaults.setObject(hitups, forKey: "MyHitups")
    }
    
    class func addToMyHitups(hitupDict: NSDictionary){
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        // Save Hitup
        var savedNearbyHitups: NSMutableArray = (defaults.objectForKey("MyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        savedNearbyHitups.insertObject(hitupDict, atIndex: 0)
        defaults.setObject(savedNearbyHitups, forKey: "MyHitups")
        
    }
    
    class func getMyHitups() -> NSMutableArray {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        return (defaults.objectForKey("MyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        
    }
    
    class func getMyHitupsAtIndex(index: NSInteger) -> NSDictionary {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("MyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        return savedNearbyHitups.objectAtIndex(index) as! NSDictionary
    }
    
    class func deleteMyHitupAtIndex(index: NSInteger) {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("MyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        savedNearbyHitups.removeObjectAtIndex(index)
        defaults.setObject(savedNearbyHitups, forKey: "MyHitups")
    }
    
    class func getMyHitupsCount() -> NSInteger {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("MyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        return savedNearbyHitups.count
    }
    
    class func setJoinMyHitupsAtIndex(index: NSInteger, joined:Bool) {
        var defaults = NSUserDefaults.standardUserDefaults()
        createKeysIfEmpty()
        var savedNearbyHitups = (defaults.objectForKey("MyHitups") as! NSArray).mutableCopy() as! NSMutableArray
        var hitup = (savedNearbyHitups.objectAtIndex(index).mutableCopy()) as! NSDictionary
        hitup.setValue(joined, forKey: "joined")
        savedNearbyHitups.replaceObjectAtIndex(index, withObject: hitup)
        defaults.setObject(savedNearbyHitups, forKey: "MyHitups")
    }
    
    
    
}
