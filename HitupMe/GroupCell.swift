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
    @IBOutlet var moreButton: UIButton!
    @IBOutlet var numberLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        var more = UIImageView(image: UIImage(named: "Cell_More"))
        more.frame = CGRectMake(0, 0, 20, 20)
        more.center = CGPointMake(moreButton.frame.width/2, moreButton.frame.height/2)
        moreButton.addSubview(more)
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
