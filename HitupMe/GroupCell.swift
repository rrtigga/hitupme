//
//  GroupCell.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/23/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class GroupCell: UITableViewCell {

    @IBOutlet var groupName: UILabel!
    
    @IBOutlet var profilePic: UIImageView!
    
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var headerLabel: UITextView!
    
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var joinedLabel: UILabel!
    @IBOutlet var mileLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
