//
//  PickGroupCell.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/27/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class PickGroupCell: UITableViewCell {

    @IBOutlet var GroupName: UILabel!
    
    @IBOutlet var GroupImage: UIImageView!
    
    @IBOutlet var Num_Members: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
