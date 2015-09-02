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
    var savedHitup:Hitup?
    
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
        headerLabel.text = savedHitup?.header
        descriptionLabel.text = savedHitup?.desc
        locationLabel.text = savedHitup?.locationName
        joinedLabel.text = "2 Joined"
        distanceLabel.text = "how far lolol"
        timeLabel.text = "1 hr"
        
        setType()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func touchJoinButton() {
        if (savedHitup?.hosted == true) {
            promptDeleteAlert()
        } else if (savedHitup?.joined != true) {
            savedHitup?.toggleJoin()
            setType()
        }
        
        
    }
    
    func promptDeleteAlert() {
        var alert = UIAlertController(title: "Cancel Hitup?", message: "😦", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            println("Yes")
            self.navigationController?.popViewControllerAnimated(true)
            var feed = self.navigationController?.topViewController as! HitupFeed
            
            Hitup.remove(self.savedHitup!)
            //feed.removeHitupfrom(self.hitupIndex)
            /*BackendAPI.removeHitup(savedHitup.objectForKey("hitupId") as! String, completion: { (success) -> Void in
            println("Successful Remove")
            })*/
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: { action in
            println("No")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func setType() {
        if (savedHitup?.hosted == true) {
            // Set Hosted
            typePicture.image = UIImage(named:"Cell_Hosted")
            joinButton.setTitle("Cancel Hitup?", forState: UIControlState.Normal)
            joinButton.backgroundColor = UIColor.whiteColor()
            joinButton.tintColor = Functions.defaultLocationColor()
            joinButton.layer.borderColor = UIColor.blackColor().CGColor
            joinButton.layer.borderWidth = 1
        } else if (savedHitup?.joined == true) {
            // Set Joined
            typePicture.image = UIImage(named:"Cell_Joined")
            joinButton.backgroundColor = UIColor.whiteColor()
            joinButton.tintColor = Functions.themeColor()
            joinButton.setTitle("joined", forState: UIControlState.Normal)
            joinButton.layer.borderColor = UIColor.blackColor().CGColor
            joinButton.layer.borderWidth = 1
        } else {
            // Set NotResponded
            typePicture.image = nil
            joinButton.backgroundColor = Functions.themeColor()
            joinButton.tintColor = UIColor.whiteColor()
            joinButton.setTitle("JOIN", forState: UIControlState.Normal)
            joinButton.layer.borderWidth = 0
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
