//
//  HitupDetailViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class HitupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    // Concrete UI Elements
    @IBOutlet var tableView: UITableView!
    @IBOutlet var joinButton: UIButton!
    
    // Base Information
    @IBOutlet var nameLabel: UILabel!
    @IBOutlet var profilePicture: UIImageView!
    @IBOutlet var headerLabel: UITextView!
    // Logistical Labels
    @IBOutlet var descriptionLabel: UITextView!
    @IBOutlet var locationLabel: UILabel!
    @IBOutlet var joinedLabel: UILabel!
    @IBOutlet var distanceLabel: UILabel!
    @IBOutlet var timeLabel: UILabel!
    @IBOutlet var typePicture: UIImageView!
    
    enum pictureType{
        case Hosted, NotResponded ,Joined
    }
    
    var savedPictureType = pictureType.NotResponded
    var hitupIndex = 0
    var savedHitup = NSDictionary(objects: ["Studying ECS150 at Temple", "Temple Coffee", "2 Joined", "0.5 miles away", "30m", "Gon be here like 2 hours", false, false], forKeys: ["header", "locationName", "numberJoined", "distance", "recency", "details", "hosted", "joined" ])
    
    internal func setPictureType(type: pictureType){
        savedPictureType=type
        switch savedPictureType {
        case .Hosted:
            typePicture.image = UIImage(named:"Cell_Hosted")
        case .NotResponded:
            typePicture.image = nil
        case .Joined:
            typePicture.image = UIImage(named:"Cell_Joined")
        }
    }
    
    
    func configureTableView() {
        tableView.rowHeight = 34
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        joinButton.addTarget(self, action: "touchJoinButton", forControlEvents: UIControlEvents.TouchUpInside)
        joinButton.layer.borderWidth = 0
        
        // Set Hitup Inforamtion
        savedHitup = Model.getLocalNearbyHitupsAtIndex(hitupIndex)
        headerLabel.text = savedHitup["header"] as? String
        descriptionLabel.text = savedHitup["details"] as? String
        locationLabel.text = savedHitup["locationName"] as? String
        joinedLabel.text = savedHitup["numberJoined"] as? String
        distanceLabel.text = savedHitup["distance"] as? String
        timeLabel.text = savedHitup["recency"] as? String
        //setting the picture event label
        if (savedHitup["joined"] as? Bool == true) {
            setPictureType(pictureType.Joined)
        } else if (savedHitup["hosted"] as? Bool == true) {
            setPictureType(pictureType.Hosted)
        } else {
            setPictureType(pictureType.NotResponded)
        }
        setPictureType(savedPictureType)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func touchJoinButton() {
        
        if (savedHitup.objectForKey("joined") as! Bool != true) {
            joinButton.backgroundColor = UIColor.whiteColor()
            joinButton.tintColor = Functions.themeColor()
            joinButton.setTitle("Joined", forState: UIControlState.Normal)
            joinButton.layer.borderColor = UIColor.blackColor().CGColor
            joinButton.layer.borderWidth = 1
            var temp: NSDictionary = savedHitup.mutableCopy() as! NSDictionary
            temp.setValue(true, forKey: "joined")
            savedHitup = temp
            setPictureType(pictureType.Joined)
        } else {
            joinButton.backgroundColor = Functions.themeColor()
            joinButton.tintColor = UIColor.whiteColor()
            joinButton.setTitle("Join", forState: UIControlState.Normal)
            joinButton.layer.borderWidth = 0
            var temp: NSDictionary = savedHitup.mutableCopy() as! NSDictionary
            temp.setValue(false, forKey: "joined")
            savedHitup = temp
            setPictureType(pictureType.NotResponded)
            
        }
        
        
    }
    
    
    
    
    
    
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 12
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        // Configure the cell...
        
        return cell
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
