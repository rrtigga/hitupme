//
//  HitupAnnotation.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/10/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import MapKit
import Parse

class HitupAnnotation: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    var subtitle: String?
    var hitup: PFObject?
    
    override init() {
        self.coordinate = CLLocationCoordinate2D()
        self.title = String()
        self.subtitle = String()
        //self.hitup = PFObject()
    }
}
