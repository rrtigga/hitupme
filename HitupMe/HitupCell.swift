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
    @IBOutlet var typePic: UIImageView!
    // Logistical Labels
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var joinedLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var pastTimeLabel: UILabel!
    
    enum cellType {
        case Joined, Hosted, NotResponded
    }
    
    var savedCellType = cellType.Hosted
    
    override func awakeFromNib() {
        super.awakeFromNib()
        HeaderLabel.text = "Programming at Peet's Coffee, feel free to join"
        locationLabel.text = "Peet's Coffee"
        setCellType(savedCellType)
    }
    
    internal func setCellType(type: cellType) {
        savedCellType = type
        switch savedCellType {
        case .Joined:
            typePic.image = UIImage(named: "Cell_Joined")
        case .Hosted:
            typePic.image = UIImage(named: "Cell_Hosted")
        case .NotResponded:
            typePic.image = nil
            
        }
        
    }
    

    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
