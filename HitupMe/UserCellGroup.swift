//
//  UserCellGroup.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class UserCellGroup: UITableViewCell {

    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var userName: UILabel!
    @IBOutlet var selectView: UIView!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
        if (selected == true) {
            selectView.backgroundColor = Functions.themeColor()
            selectView.layer.borderWidth = 0
        } else {
            selectView.backgroundColor = UIColor.whiteColor()
            selectView.layer.borderWidth = 1
        }
    }

}
