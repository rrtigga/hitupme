//
//  Hitup.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/1/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//


import Foundation
import CoreData

class Hitup: NSManagedObject {

    @NSManaged var header: String
    @NSManaged var desc: String
    //@NSManaged var creatorName: String
    @NSManaged var latitude: NSNumber
    @NSManaged var locationName: String
    @NSManaged var longtitude: NSNumber
    @NSManaged var timeCreated: NSNumber
    @NSManaged var uniqueId: String // ID = timeCreated-header-userID
    @NSManaged var userId: String
    @NSManaged var firstName: String
    @NSManaged var lastName: String
    @NSManaged var hosted: Bool
    @NSManaged var nearby: Bool
    @NSManaged var joined: Bool
    
    
    // Each hitup keeps track of where it is in Near Array and My Array
    class func makeHitup(header:String, desc:String, latitude:NSNumber, locationName:String, longtitude:NSNumber, uniqueId:String) {
        
        // Preliminary Information
        var defaults = NSUserDefaults.standardUserDefaults()
        var userDict = defaults.objectForKey("userInfo_dict") as! NSDictionary
        var userId = userDict.objectForKey("id") as! String
        var firstName = userDict.objectForKey("first_name") as! String
        var lastName = userDict.objectForKey("last_name") as! String

        // 1 Core Data object creation
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        var error: NSError?
        let entity =  NSEntityDescription.entityForName("Hitup", inManagedObjectContext: context)
        let hitup = Hitup(entity:entity!, insertIntoManagedObjectContext: context) as Hitup
        
        // 3 Set
        hitup.header = header
        hitup.desc = desc
        hitup.latitude = latitude
        hitup.longtitude = longtitude
        hitup.locationName = locationName
        hitup.timeCreated = NSDate().timeIntervalSince1970
        hitup.userId = userId
        hitup.firstName = firstName
        hitup.lastName = lastName
        hitup.nearby = true
        hitup.hosted = true
        hitup.joined = false
        hitup.timeCreated = NSDate().timeIntervalSince1970
        hitup.uniqueId = String(format: "%d-%@-%@", hitup.timeCreated, hitup.header, hitup.userId)
        
        
        // 5
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        } else {
            println("CoreData Save Success")
            Hitup.remove(hitup)
        }
    }
    
    // Good
    func toggleJoin() {
        
        println(String(format: "  Join Toggle Started for %@", uniqueId))
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        var fetch = NSFetchRequest(entityName: "Hitup")
        var predicate = NSPredicate(format: "uniqueId == %@", uniqueId)
        fetch.predicate = predicate
        var error: NSError?
        if let result = context.executeFetchRequest(fetch, error: nil) as? [NSManagedObject] {
            var hitup = result.first as! Hitup
            if hitup.hosted == false {
                
                // Toggle Join
                if hitup.joined == true {
                    hitup.joined = false
                    println("   -unJoined")
                } else {
                    hitup.joined = true
                    println("   -Joined")
                }
                
                // Save Changes
                var error: NSError?
                if !context.save(&error) {
                    println("Could not save \(error), \(error?.userInfo)")
                } else {
                    //println("CoreData Update Success")
                    if (joined == true) { println("   ^Joined")}
                    else { println("   ^unJoined (Just checking if Synchronized)")}
                }
                
                // Check for overlap in uniqueIds
                if result.count != 1 {
                    println("Warning (Hitup.uniqueId): More than one object with the same uniqueId :/")
                }
                
            } else {
                println("You can't Join/Unjoin your own event!")
            } // hosted == true
            
        } else {
            println("Error with Fetch")
        } // result was successful
        
    }
    
    // Good
    class func remove(hitup:Hitup) {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        context.deleteObject(hitup)
        
        /*
        // Get Actual hitup to be removed
        var fetch = NSFetchRequest(entityName: "Hitup")
        var predicate = NSPredicate(format: "uniqueId == %@", hitup.uniqueId)
        fetch.predicate = predicate
        if let result = context.executeFetchRequest(fetch, error: nil) as? [NSManagedObject] {
            context.deleteObject(result.first!)
        }*/
        
        var error: NSError?
        if !context.save(&error) {
            println("Could not save \(error), \(error?.userInfo)")
        } else {
        }
    }

    
    class func checkCoreData {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        var fetch = NSFetchRequest(entityName: "Hitup")
        var sort = NSSortDescriptor(key: "timeCreated", ascending: true)
        fetch.sortDescriptors = [sort]
        
        if let fetchResults = context.executeFetchRequest(fetch, error: nil) as? [NSManagedObject] {
            for h in fetchResults {
                var hit = h as! Hitup
                println(String(format: " - %@, %d, %@", hit.firstName, hit.timeCreated, hit.uniqueId))
            }
        }
    }
    
}
