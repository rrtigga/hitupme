//
//  Hitup.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/31/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//
//  Note: there are two locally stored Arrays
//          - NearbyHitups array  (Near)
//          - MyHitups array      (My)

import UIKit

class Hitup: NSObject {
    
    var hitupData = NSDictionary()
    
    // Each hitup keeps track of where it is in Near Array and My Array
    
    class func makeHitup() {
        // Makes a Hitup Object, Stores in Near and My, and uploads to Database.
        var hit = Hitup()
        
        // Store in Near and My
            // As this Hitup is more recent, Insert Hitup at top of both Near and My Arrays
        
        // Upload Hitup to Database
        
    }
    
    func toggleJoin() {
        // Upload Changes to My and Near and Database
        
        // If join == false -> JOIN
            // Add Hitup to MyHitup Databas
        
        // If join == true -> UNJOIN
        //   remove Hitup from MyHitup Screen
        
        
    }
    
    func remove() {
        // IF is created by user, remove Locally and on Database
        
        
    }
}
