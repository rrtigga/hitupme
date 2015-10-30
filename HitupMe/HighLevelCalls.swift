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

        let defaults = NSUserDefaults.standardUserDefaults()
        let latitude = defaults.doubleForKey("latitude")
        let longitude = defaults.doubleForKey("longitude")
        //println("Getting from lat:\(latitude) lon:\(longitude)")
        
        
        let query = PFQuery(className: "Hitups")
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
        
        let LIKEAWEEKAGO = NSDate().dateByAddingTimeInterval(-604800.0 )
        
        // create a relation based on the myhitups key
        let relation = PFUser.currentUser()!.relationForKey("my_hitups")
        
        //generate a query based on that relation
        let query = relation.query()
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
        let query = PFUser.query()
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
    
    class func updateGroupHitups( groupID: String, isActiveOnly: Bool, isTodayOnly: Bool, completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        // Update User and make Query
        PFUser.currentUser()?.fetchInBackground()
        var user = PFUser.currentUser()!
        var defaults = NSUserDefaults.standardUserDefaults()
        let query = PFQuery(className: "Hitups")
        query.whereKey("has_group", equalTo: true)
        
        // Set Restrictions
        if isActiveOnly == true {
            query.whereKey("expire_time", greaterThan: NSDate())
        }
        if isTodayOnly == true {
            let yesterday = NSDate().dateByAddingTimeInterval(-86400)
            query.whereKey("createdAt", greaterThan: yesterday)
        }
        query.orderByDescending("createdAt")
        query.limit = 30
        query.whereKey("to_group", equalTo: groupID)
        
        // Find
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                print(error?.description)
                completion(success: false, objects: [AnyObject]())
            }
        }
    
    }
    
    class func updateExploreHitups( isActiveOnly: Bool, isTodayOnly: Bool, completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        PFUser.currentUser()?.fetchInBackground()
        let user = PFUser.currentUser()!
        let defaults = NSUserDefaults.standardUserDefaults()

        // Group Query
        let groupQuery = PFQuery(className: "Hitups")
        groupQuery.whereKey("has_group", equalTo: true)
        let groups_joined = user.objectForKey("groups_joined") as? [AnyObject]
        if groups_joined == nil {
            groupQuery.whereKey("to_group", containedIn: [] )
        } else {
            groupQuery.whereKey("to_group", containedIn: groups_joined! )
        }
        
        // Regular Query
        let regularQuery = PFQuery(className: "Hitups")
        let friendIds : [AnyObject]? = defaults.arrayForKey("friend_ids")
        if friendIds != nil {
            regularQuery.whereKey("user_host", containedIn: friendIds!)
        } else {
            print("HLC: friendIds was nil?")
        }
        regularQuery.whereKey("has_group", notEqualTo: true)
        
        // Combine Queries (group or regular)
        let query = PFQuery.orQueryWithSubqueries([groupQuery, regularQuery])
        var lastWeek = NSDate().dateByAddingTimeInterval(-432000.0)
        //query.whereKey("createdAt", greaterThan: lastWeek)
        let latitude = defaults.doubleForKey("latitude")
        let longitude = defaults.doubleForKey("longitude")
        if isActiveOnly == true {
            query.whereKey("expire_time", greaterThan: NSDate())
        }
        if isTodayOnly == true {
            let yesterday = NSDate().dateByAddingTimeInterval(-86400)
            query.whereKey("createdAt", greaterThan: yesterday)
        }
        
        query.whereKey("coordinates", nearGeoPoint: PFGeoPoint(latitude: latitude, longitude: longitude), withinMiles: 20.0)
        query.orderByDescending("createdAt")
        query.limit = 30;
        
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                print(error?.description)
                completion(success: false, objects: [AnyObject]())
            }
        }
    }
    
    class func updateProfileMapHitups( userId: NSString, completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        
        var lastWeek = NSDate().dateByAddingTimeInterval(-432000.0)
        
        let query = PFQuery(className: "Hitups")
        query.orderByDescending("createdAt")
        query.whereKey("user_host", equalTo: userId)
        query.limit = 30;
        query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
            if error == nil {
                completion(success: true, objects: objects)
            } else {
                print(error?.description)
                completion(success: false, objects: [AnyObject]())
            }
        }
    }
    
    class func getGroups( completion: (( success: Bool?, objects: [AnyObject]? ) -> Void)) {
        PFUser.currentUser()?.fetchInBackground()
        let query = PFQuery(className: "Groups")
        let id =   PFUser.currentUser()!.objectForKey("fb_id") as? String
        let groups: [AnyObject]? = PFUser.currentUser()!.objectForKey("groups_joined") as? [AnyObject]
        print(groups)
        if groups != nil {
        
            query.whereKey("group_id", containedIn: groups!)
            query.whereKey("users_joined", containsAllObjectsInArray: [id!])
                query.orderByDescending("createdAt")
                query.findObjectsInBackgroundWithBlock { (objects, error) -> Void in
                    if error == nil {
                        completion(success: true, objects: objects)
                    } else {
                        print("HLC error getGroups", error!.description)
                        completion(success: false, objects: [AnyObject]())
                    }
                }
        } else {
            completion(success: false, objects: [AnyObject]())
        }
    }
    
    
    class func getLocalNearbyHitups() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
    
        let fetch = NSFetchRequest(entityName: "Hitup")
        let sort = NSSortDescriptor(key: "timeCreated", ascending: false)
        fetch.sortDescriptors = [sort]
        let predicate = NSPredicate(format: "nearby == %@", true)
        fetch.predicate = predicate
        
        if let fetchResults = (try? context.executeFetchRequest(fetch)) as? [NSManagedObject] {
            return fetchResults
        } else {
            return NSArray()
        }
    }
    
    class func getLocalMyHitups() -> NSArray {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetch = NSFetchRequest(entityName: "Hitup")
        let sort = NSSortDescriptor(key: "timeCreated", ascending: false)
        fetch.sortDescriptors = [sort]
        let predicate = NSPredicate(format: "hosted == %@ || joined == %@ ", true, true)
        fetch.predicate = predicate
        
        if let fetchResults = (try? context.executeFetchRequest(fetch)) as? [NSManagedObject] {
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
        let cities = NSArray() // BackendAPI.getCities
        completion(success:true, cities: cities)
    }
    
    class func getSpecificCityData(cityPlusCode:NSString, completion: ((success: Bool?, cityHitups: NSArray) -> Void)) {
        let cityHitups = NSArray() // BackendAPI.getCities
        completion(success:true, cityHitups: cityHitups)
    }
    
    
    // ---------- 3. Notifications Tab ---------- //
    class func getNotificationData( completion: ((success: Bool?, notifications: NSArray) -> Void)) {
        let notifications = NSArray() // BackendAPI.getNotifications
        completion(success:true, notifications: notifications)
    }
    
    
    // ---------- 4. Profile Tab ---------- //
    class func updateMyHitupsData( completion: ((success: Bool?) -> Void)) {
        let hitups = NSArray() // BackendAPI.getMyHitups
        Model.setMyHitups(hitups)
        // Signal that LocalNearbyHitups needs to be updated next WillAppear
        completion(success: true)
    }
    
    
}
