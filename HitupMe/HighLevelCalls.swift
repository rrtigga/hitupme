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
        
        // 1 - Remove all local Hitups
        Hitup.resetCoreData()
        
        var query = PFQuery(className: "Hitups")
        var hitups = query.findObjects()
        
        // 4 - Make sure to reload whichever view you're in
        
        // Signal that MyHitups needs to be updated next WillAppear
        completion(success: true, objects: hitups)
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
