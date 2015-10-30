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
    class func makeHitup(header:String, desc:String, latitude:NSNumber, locationName:String, longtitude:NSNumber) {
        
        // Preliminary Information
        let defaults = NSUserDefaults.standardUserDefaults()
        let userDict = defaults.objectForKey("userInfo_dict") as! NSDictionary
        let userId = userDict.objectForKey("id") as! String
        let firstName = userDict.objectForKey("first_name") as! String
        let lastName = userDict.objectForKey("last_name") as! String

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
        do {
            try context.save()
            Hitup.checkCoreData()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    // Each hitup keeps track of where it is in Near Array and My Array
    class func addHitupFromServer(header:String, desc:String, latitude:NSNumber, locationName:String, longtitude:NSNumber, userId:String, firstName:String, lastName:String, joined:Bool) {
        
        // Preliminary Information
        let defaults = NSUserDefaults.standardUserDefaults()
        let userDict = defaults.objectForKey("userInfo_dict") as! NSDictionary
        let savedId = userDict.objectForKey("id") as! String
        
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
        hitup.timeCreated = NSDate().timeIntervalSince1970
        hitup.uniqueId = String(format: "%d-%@-%@", hitup.timeCreated, hitup.header, hitup.userId)
        
        // 4 Set Joined / Hosted
        if savedId == userId {
            hitup.hosted = true
            hitup.joined = false
        } else {
            hitup.hosted = false
            hitup.joined = joined
        }
        
        // 5
        do {
            try context.save()
            Hitup.checkCoreData()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }
    
    // Good
    func toggleJoin() {
        
        print(String(format: "  Join Toggle Started for %@", uniqueId))
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        
        let fetch = NSFetchRequest(entityName: "Hitup")
        let predicate = NSPredicate(format: "uniqueId == %@", uniqueId)
        fetch.predicate = predicate
        var error: NSError?
        if let result = (try? context.executeFetchRequest(fetch)) as? [NSManagedObject] {
            let hitup = result.first as! Hitup
            if hitup.hosted == false {
                
                // Toggle Join
                if hitup.joined == true {
                    hitup.joined = false
                    print("   -unJoined")
                } else {
                    hitup.joined = true
                    print("   -Joined")
                }
                
                // Save Changes
                var error: NSError?
                do {
                    try context.save()
                    //println("CoreData Update Success")
                    if (joined == true) { print("   ^Joined")}
                    else { print("   ^unJoined (Just checking if Synchronized)")}
                } catch let error1 as NSError {
                    error = error1
                    print("Could not save \(error), \(error?.userInfo)")
                }
                
                // Check for overlap in uniqueIds
                if result.count != 1 {
                    print("Warning (Hitup.uniqueId): More than one object with the same uniqueId :/")
                }
                
            } else {
                print("You can't Join/Unjoin your own event!")
            } // hosted == true
            
        } else {
            print("Error with Fetch")
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
        do {
            try context.save()
        } catch let error1 as NSError {
            error = error1
            print("Could not save \(error), \(error?.userInfo)")
        }
    }

    class func resetCoreData() {
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetch = NSFetchRequest(entityName: "Hitup")
        
        if let fetchResults = (try? context.executeFetchRequest(fetch)) as? [NSManagedObject] {
            for h in fetchResults {
                context.deleteObject(h)
            }
            print("Finished Deleting")
        }
    }
    
    class func checkCoreData() {
        
        let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
        let context = appDelegate.managedObjectContext!
        let fetch = NSFetchRequest(entityName: "Hitup")
        let sort = NSSortDescriptor(key: "timeCreated", ascending: true)
        fetch.sortDescriptors = [sort]
        
        if let fetchResults = (try? context.executeFetchRequest(fetch)) as? [NSManagedObject] {
            print("Checking Core Data")
            for h in fetchResults {
                let hit = h as! Hitup
                print(String(format: " - %@, %d, %@", hit.firstName, hit.timeCreated, hit.uniqueId))
            }
            print("Fin Checking")
        }
    }
    
}
