//
//  HitupAnnotationView.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/18/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import MapKit

class HitupAnnotationView: MKPinAnnotationView {
    
    override func hitTest(point: CGPoint, withEvent event: UIEvent?) -> UIView? {
        let hitView = super.hitTest(point, withEvent: event)
        if hitView != nil {
            superview?.bringSubviewToFront(self)
        }
        return hitView
    }
    
    override func pointInside(point: CGPoint, withEvent event: UIEvent?) -> Bool {
        let rect = bounds
        var isInside = CGRectContainsPoint(rect, point)
        if (isInside == false) {
            for view in subviews {
                isInside = CGRectContainsPoint(view.frame, point)
                if (isInside == true) {
                    break;
                }
            }
        }
        return isInside
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
