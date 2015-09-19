//
//  HighLevelCalls.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/29/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import CoreData
import Parse

class HighLevelCalls: NSObject {
    
    // ---------- 1. Main Tab ---------- //
    class func updateNearbyHitups( completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        
        var yesterday = NSDate().dateByAddingTimeInterval(-432000.0)

        var defaults = NSUserDefaults.standardUserDefaults()
        var latitude = defaults.doubleForKey("latitude")
        var longitude = defaults.doubleForKey("longitude")
        //println("Getting from lat:\(latitude) lon:\(longitude)")
        
        
        var query = PFQuery(className: "Hitups")
        //query.whereKey("createdAt", greaterThan: yesterday)
        query.whereKey("expire_time", greaterThan: NSDate())
        query.whereKey("coordinates", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude), withinMiles: 20.0)
        query.orderByDescending("createdAt")
        query.limit = 20;
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                completion(success: false, objects: [AnyObject]())
            }
        }
    }
    
    
    
    class func getMyHitups( completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        
        var LIKEAWEEKAGO = NSDate().dateByAddingTimeInterval(-604800.0 )
        
        // create a relation based on the myhitups key
        let relation = PFUser.currentUser()!.relationForKey("my_hitups")
        
        //generate a query based on that relation
        var query = relation.query()
        query!.whereKey("createdAt", greaterThan: LIKEAWEEKAGO)
        query!.orderByDescending("createdAt")
        query!.limit = 20;
        query!.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                completion(success: false, objects: [AnyObject]())
            }
        }
    }
    
    class func getTesters( completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        var query = PFUser.query()
        query?.orderByDescending("createdAt")
        query!.selectKeys(["fb_id", "first_name", "last_name"])
        query?.findObjectsInBackgroundWithBlock({ (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                completion(success: false, objects: [AnyObject]())
            }
        })
        
    }
    
    class func updateExploreHitups( completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        
        var lastWeek = NSDate().dateByAddingTimeInterval(-432000.0)
        
        var query = PFQuery(className: "Hitups")
        //query.whereKey("createdAt", greaterThan: lastWeek)
        var defaults = NSUserDefaults.standardUserDefaults()
        var latitude = defaults.doubleForKey("latitude")
        var longitude = defaults.doubleForKey("longitude")
        query.whereKey("coordinates", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude), withinMiles: 200.0)
        query.orderByDescending("createdAt")
        query.limit = 30;
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                println(error?.description)
                completion(success: false, objects: [AnyObject]())
            }
        }
    }
    
    
    class func getLocalNearbyHitups() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
    
        var fetch = NSFetchRequest(entityName: "Hitup")
        var sort = NSSortDescriptor(key: "timeCreated", ascending: false)
        fetch.sortDescriptors = [sort]
        var predicate = NSPredicate(format: "nearby == %@", true)
        fetch.predicate = predicate
        
        if let fetchResults = context.executeFetchRequest(fetch, error: nil) as? [NSManagedObject] {
            return fetchResults
        } else {
            return NSArray()
        }
    }
    
    class func getLocalMyHitups() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        var fetch = NSFetchRequest(entityName: "Hitup")
        var sort = NSSortDescriptor(key: "timeCreated", ascending: false)
        fetch.sortDescriptors = [sort]
        var predicate = NSPredicate(format: "hosted == %@ || joined == %@ ", true, true)
        fetch.predicate = predicate
        
        if let fetchResults = context.executeFetchRequest(fetch, error: nil) as? [NSManagedObject] {
            return fetchResults
        } else {
            return NSArray()
        }
    }
    
    class func refreshAfterCreateHitup() {
        Functions.setRefreshTabTrue(0)
        Functions.setRefreshTabTrue(3)
    }
    
    // ---------- 2. City Tab ---------- //
    class func getCitiesData( completion: ((success: Bool?, cities: NSArray) -> Void)) {
        var cities = NSArray() // BackendAPI.getCities
        completion(success:true, cities: cities)
    }
    
    class func getSpecificCityData(cityPlusCode:NSString, completion: ((success: Bool?, cityHitups: NSArray) -> Void)) {
        var cityHitups = NSArray() // BackendAPI.getCities
        completion(success:true, cityHitups: cityHitups)
    }
    
    
    // ---------- 3. Notifications Tab ---------- //
    class func getNotificationData( completion: ((success: Bool?, notifications: NSArray) -> Void)) {
        var notifications = NSArray() // BackendAPI.getNotifications
        completion(success:true, notifications: notifications)
    }
    
    
    // ---------- 4. Profile Tab ---------- //
    class func updateMyHitupsData( completion: ((success: Bool?) -> Void)) {
        var hitups = NSArray() // BackendAPI.getMyHitups
        Model.setMyHitups(hitups)
        // Signal that LocalNearbyHitups needs to be updated next WillAppear
        completion(success: true)
    }
    
    
}
