//
//  HitupDetailViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

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
    
    var thisHitup = PFObject(className: "Hitups")
    var joined_before = false
    
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
        
        headerLabel.text = thisHitup.objectForKey("header") as! String
        descriptionLabel.text = thisHitup.objectForKey("description") as? String
        locationLabel.text = thisHitup.objectForKey("location_name") as? String
        nameLabel.text = thisHitup.objectForKey("user_hostName") as? String
        joinedLabel.text = "2 Joined"
        
        // Set Number Joined
        var joinedArray = thisHitup.objectForKey("users_joined") as! [AnyObject]
        var num = joinedArray.count
        joinedLabel.text = String(format: "%i Joined", num - 1 )
        
        // Set Profile Picture
        Functions.getPictureFromFBId(thisHitup.objectForKey("user_host") as! String, completion: { (image) -> Void in
            self.profilePicture.image = image
        })
        
        // Set Distance Label
        var coords = thisHitup.objectForKey("coordinates") as! PFGeoPoint
        var dist = coords.distanceInMilesTo(PFGeoPoint(latitude: LocationManager.sharedInstance.lastKnownLatitude, longitude: LocationManager.sharedInstance.lastKnownLongitude))
        distanceLabel.text = String(format: "%.1f miles away", dist)
        
        // Set Time Label
        var created = thisHitup.createdAt
        var seconds =  NSDate().timeIntervalSinceDate(created!)
        timeLabel.text = String(format: "%.1fhr", seconds/3600)
        
        var user_hosted = thisHitup["user_host"] as! String
        var users_joined = thisHitup["users_joined"] as! [AnyObject]
        var currentUser_fbId = PFUser.currentUser()!.objectForKey("fb_id") as! String
        if(currentUser_fbId == user_hosted){
            setType(0)
        }
        else if( (users_joined as NSArray).containsObject(currentUser_fbId) ){
            setType(1)
        }
        else {
            setType(2)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func touchJoinButton() {
        var user_hosted = thisHitup["user_host"] as! String
        var users_joined = thisHitup["users_joined"] as! [AnyObject]
        var currentUser_fbId = PFUser.currentUser()!.objectForKey("fb_id") as! String
        var user = PFUser.currentUser()
        var fullName = (user?.objectForKey("first_name") as! String) + " " + (user?.objectForKey("last_name") as! String)
        if(currentUser_fbId == user_hosted){
            // If Hosted
            promptDeleteAlert()
        } else if ( (users_joined as NSArray).containsObject(currentUser_fbId) ) {
            // If Joined
            thisHitup.removeObjectsInArray( [ currentUser_fbId ], forKey: "users_joined")
            thisHitup.removeObjectsInArray( [ fullName ] , forKey: "users_joinedNames")
            thisHitup.save()
            let rel = PFUser.currentUser()?.relationForKey("my_hitups")
            rel?.removeObject(thisHitup)
            PFUser.currentUser()?.incrementKey("num", byAmount: -1)
            PFUser.currentUser()?.saveInBackground()
            setType(2)
            
            Functions.setRefreshTabTrue(3)
        } else {
            thisHitup.addUniqueObjectsFromArray( [ currentUser_fbId ], forKey: "users_joined")
            thisHitup.addUniqueObjectsFromArray( [ fullName ] , forKey: "users_joinedNames")
            thisHitup.save()
            let rel = PFUser.currentUser()?.relationForKey("my_hitups")
            rel?.addObject(thisHitup)
            PFUser.currentUser()?.incrementKey("num")
            PFUser.currentUser()?.saveInBackground()
            setType(1)
            Functions.setRefreshTabTrue(3)
            
            // send fresh push notification for user joining the Hitup
            if(!joined_before) {
                //push notification for user joining the Hitup
                // Create our query to notify all users joined
                let pushQuery = PFInstallation.query()
                pushQuery!.whereKey("fb_id", containedIn: thisHitup.objectForKey("users_joined") as! [AnyObject] )
                pushQuery!.whereKey("fb_id", notEqualTo: user?.objectForKey("fb_id") as! String)
                // Send push notification to query
                let push = PFPush()
                push.setQuery(pushQuery) // Set our Installation query
                //header text
                var header_text = thisHitup.objectForKey("header") as! String
                push.setMessage(fullName + " has joined " + header_text)
                push.sendPushInBackground()
                joined_before = true
            }

        } // else
        
    }
    
    func promptDeleteAlert() {
        var alert = UIAlertController(title: "Cancel Hitup?", message: "😦", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            println("Yes")
            self.navigationController?.popViewControllerAnimated(true)
            //var feed = self.navigationController?.topViewController as! HitupFeed
            
            self.thisHitup.deleteInBackground()
            Functions.setRefreshAllTabsTrue()
            
            var user = PFUser.currentUser()
            var fullName = (user?.objectForKey("first_name") as! String) + (user?.objectForKey("last_name") as! String)
            
            // Create our query to notify all users joined
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("fb_id", containedIn: self.thisHitup.objectForKey("users_joined") as! [AnyObject] )
            pushQuery!.whereKey("fb_id", notEqualTo: user?.objectForKey("fb_id") as! String)
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            //header text
            var header_text = self.thisHitup.objectForKey("header") as! String
            push.setMessage(fullName + " has deleted " + header_text)
            push.sendPushInBackground()
            self.joined_before = true
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: { action in
            println("No")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    
    func setType(typeNum: NSNumber) {
        
        switch typeNum{
        case 0: // Hosted
            typePicture.image = UIImage(named:"Cell_Hosted")
            joinButton.setTitle("Cancel Hitup?", forState: UIControlState.Normal)
            joinButton.backgroundColor = UIColor.whiteColor()
            joinButton.tintColor = Functions.defaultLocationColor()
            joinButton.layer.borderColor = UIColor.blackColor().CGColor
            joinButton.layer.borderWidth = 1
            break;
        
        case 1: // Joined
            typePicture.image = UIImage(named:"Cell_Joined")
            joinButton.backgroundColor = UIColor.whiteColor()
            joinButton.tintColor = Functions.themeColor()
            joinButton.setTitle("joined", forState: UIControlState.Normal)
            joinButton.layer.borderColor = UIColor.blackColor().CGColor
            joinButton.layer.borderWidth = 1
            tableView.reloadData()
            break;
            
        case 2: // NotResponded
            typePicture.image = nil
            joinButton.backgroundColor = Functions.themeColor()
            joinButton.tintColor = UIColor.whiteColor()
            joinButton.setTitle("JOIN", forState: UIControlState.Normal)
            joinButton.layer.borderWidth = 0
            tableView.reloadData()
            break;
        default:
            println("Error: In Detail Controller, unrecognized type Number")
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
        // Set Number Joined
        var joinedArray = thisHitup.objectForKey("users_joined") as! [AnyObject]
        var num = joinedArray.count
        return num
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! DetailActionCell
        // Configure the cell...
        
        // set name
        var joinedName = thisHitup.objectForKey("users_joinedNames") as! [AnyObject]
        cell.actionLabel.text = joinedName[indexPath.row] as? String
        
        // set profile picture
        var joinedIds = thisHitup.objectForKey("users_joined") as! [AnyObject]
        var currentJoinedId = joinedIds[indexPath.row] as? String
        
        Functions.getPictureFromFBId(currentJoinedId!) { (image) -> Void in
            cell.profilePicture.image = image
        }
        
        
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
