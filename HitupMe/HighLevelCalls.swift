//
//  HighLevelCalls.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/29/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class HighLevelCalls: NSObject {
    
    
    // ---------- 1. Main Tab ---------- //
    class func updateMainFeedData( completion: ((success: Bool?) -> Void)) {
        var hitups = NSArray() // BackendAPI.getMainHitups
        Model.setLocalNearbyHitups(hitups)
        // Signal that MyHitups needs to be updated next WillAppear
        completion(success: true)
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
