//
//  myHitupCell.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/1/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class myHitupCell: UITableViewCell {

    @IBOutlet var typeLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var headerLabel: UILabel!
    @IBOutlet var joinLabel: UILabel!
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var activeIndicator: UIView!
    
    var savedCellType = cellType.Joined
    enum cellType {
        case Joined, Hosted
    }
    
    func setActive(isActive: Bool) {
        if (isActive) {
            activeIndicator.backgroundColor = UIColor.greenColor()
        } else {
            activeIndicator.backgroundColor = UIColor.redColor()
        }
    }
    
    internal func setCellType(type: cellType) {
        
        savedCellType = type
        switch savedCellType {
        case .Joined:
            typeLabel.text = "JOINED"
            typeLabel.textColor = Functions.defaultLocationColor()
        case .Hosted:
            typeLabel.text = "HOSTED"
            typeLabel.textColor = Functions.themeColor()
        }
    }
    
    
    
    
}
