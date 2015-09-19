//
//  PermissionRelatedCalls.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/15/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import CoreLocation

class PermissionRelatedCalls: NSObject {

    class func requestNotifications() {
        let application = UIApplication.sharedApplication()
        application.registerUserNotificationSettings(UIUserNotificationSettings(forTypes: UIUserNotificationType.Sound | UIUserNotificationType.Alert | UIUserNotificationType.Badge, categories: nil))
        application.registerForRemoteNotifications()
    }
    
    class func locationEnabled() -> Bool {
        
        if (CLLocationManager.authorizationStatus() == CLAuthorizationStatus.NotDetermined || CLLocationManager.authorizationStatus() == CLAuthorizationStatus.Denied) {
            return false
        } else {
            return true
        }
    }
    
    class func askLocation() {
        var man = CLLocationManager()
        man.requestWhenInUseAuthorization()
    }
    
}
