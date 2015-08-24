//
//  HitupCell.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class HitupCell: UITableViewCell {
    
    // Base Information
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var HeaderLabel: UITextView!
    // Logistical Labels
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var joinedLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var pastTimeLabel: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        HeaderLabel.text = "ksdjfld"
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
