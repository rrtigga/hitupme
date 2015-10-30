//
//  HitupCalloutView.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/18/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class HitupCalloutView: UIButton {

    var profilePic = UIImageView()
    var nameLabel = UILabel()
    var headerLabel = UITextView()
    var joinImageView = UIImageView()
    var timeImageView = UIImageView()
    var joinLabel = UILabel()
    var timeLabel = UILabel()
    var height = CGFloat( 65.0)
    var width = CGFloat(245.0)
    
    class func initView() -> HitupCalloutView {
        
        let hcv = HitupCalloutView()
        hcv.layoutUI()
        hcv.profilePic.image = UIImage(named: "SHIBA")
        hcv.nameLabel.text = "SHIBA"
        hcv.headerLabel.text = "Shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba shiba"
        hcv.joinLabel.text = "2 joined"
        hcv.timeLabel.text = "30 min left"
        
        return hcv
    }
    
    func layoutUI() {
        
        backgroundColor = UIColor.whiteColor()
        layer.cornerRadius = 5
        layer.masksToBounds = true
        frame = CGRectMake(-width/2 + 5 , -(height + 4), width, height)
        
        profilePic.frame = CGRectMake(10, 5, 40, 40)
        profilePic.layer.cornerRadius = 20
        profilePic.layer.masksToBounds = true
        
        nameLabel.frame = CGRectMake(0, 45, 60, 15)
        nameLabel.center = CGPointMake(profilePic.center.x, nameLabel.center.y)
        nameLabel.textAlignment = NSTextAlignment.Center
        nameLabel.font = UIFont(name: "Avenir-Book", size: 7)
        
        headerLabel.frame = CGRectMake(57, 0, width - 50, height - 23)
        headerLabel.font = UIFont(name: "Avenir-Medium", size: 12)
        headerLabel.userInteractionEnabled = false

        joinImageView.frame = CGRectMake(63, height - 19, 12, 12)
        joinImageView.image = UIImage(named: "Cell_Group")
        joinLabel.frame = CGRectMake(80, height - 17, 100, 10)
        joinLabel.font = UIFont(name: "Avenir-Book", size: 10)
        
        timeImageView.frame = CGRectMake(150, height - 19, 12, 12)
        timeImageView.image = UIImage(named: "Cell_Time")
        timeLabel.frame = CGRectMake(167, height - 17, 100, 10)
        timeLabel.font = UIFont(name: "Avenir-Book", size: 10)
        
        addSubview(profilePic)
        addSubview(nameLabel)
        addSubview(headerLabel)
        addSubview(joinImageView)
        addSubview(timeImageView)
        addSubview(joinLabel)
        addSubview(timeLabel)
    }
    
    /*
    // Only override drawRect: if you perform custom drawing.
    // An empty implementation adversely affects performance during animation.
    override func drawRect(rect: CGRect) {
        // Drawing code
    }
    */

}
