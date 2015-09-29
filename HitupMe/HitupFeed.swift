//
//  HitupFeed.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class HitupFeed: UITableViewController, FBSDKLoginButtonDelegate  {
    
    var loadedOnce = false
    var refreshController = UIRefreshControl()
    var hitups = [AnyObject]()
    let loginView : FBSDKLoginButton = FBSDKLoginButton()// Note for some reason this button must be allocated here.
    var hitupToSend = PFObject(className: "Hitups")

    
    // ----- Login Button Methods ----- //
    @IBAction func touchLogout(sender: AnyObject) {
        loginView.delegate = self
        loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    @IBAction func touchRefreshButton(sender: AnyObject) {
        pullRefresh()
    }
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOutInBackground()
        performSegueWithIdentifier("logout", sender: nil)
        println("User Logged Out of App")
    }
    // ----- End ----- //
    
    
    
    func configureTableView() {
        tableView.rowHeight = 108
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = Functions.defaultFadedColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        // Refresh Controller
        Functions.updateLocationinBack { (success) -> Void in
            
            self.pullRefresh()
        }
        
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: "pullRefresh", forControlEvents: UIControlEvents.ValueChanged)
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        if loadedOnce == false {
            // First Load, don't do anything
            loadedOnce = true
        } else {
            Functions.updateLocation()
            if Functions.refreshTab(0) == true {
                pullRefresh()
            } else {
                tableView.reloadData()
            }
        }
        
    }
    
    func pullRefresh() {
        var defaults = NSUserDefaults.standardUserDefaults()
        if !PermissionRelatedCalls.locationEnabled() {
            Functions.promptLocationTo(self, message: "Aw 💩! Please enable location to see Hitups.")
            self.refreshController.endRefreshing()
        } else {
            println("refresh")
            tableView.userInteractionEnabled = false
            HighLevelCalls.updateNearbyHitups { (success, objects) -> Void in
                self.hitups = objects!
                self.refreshController.endRefreshing()
                self.tableView.reloadData()
                self.tableView.userInteractionEnabled = true
                println("Number of objects", objects!.count)
                
                if objects!.count == 0 {
                    var label = UILabel(frame: CGRectMake(0, 0, self.tableView.frame.width, 80))
                    label.textAlignment = NSTextAlignment.Center
                    label.text = "No Active Hitups Nearby!"
                    label.font = UIFont(name: "Avenir-Medium", size: 15)
                    self.tableView.insertSubview(label, atIndex: 0)
                }
            }
        }
        
        Functions.updateLocation()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    /*
    internal func addTopHitup(hitupDict:NSDictionary) {
        Model.addToLocalNearbyHitups(hitupDict)
        tableView.insertRowsAtIndexPaths([NSIndexPath(forRow: 0, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Top)
    }
    
    internal func removeHitupfrom(index: NSInteger) {
        Model.deleteLocalNearbyHitupAtIndex(index)
        tableView.deleteRowsAtIndexPaths([NSIndexPath(forRow: index, inSection: 0)], withRowAnimation: UITableViewRowAnimation.Bottom)
    }*/

    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return hitups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! HitupCell
        var hitup = hitups[indexPath.row] as! PFObject
        
        cell.HeaderLabel.text = hitup.objectForKey("header") as! String
        cell.locationLabel.text = hitup.objectForKey("location_name") as? String
        cell.nameLabel.text = hitup.objectForKey("user_hostName") as? String
        
        // Set Number Joined
        var joinedArray = hitup.objectForKey("users_joined") as! [AnyObject]
        cell.joinedLabel.text = String(format: "%i joined", joinedArray.count - 1)
        
        // Set Distance Label
        var coords = hitup.objectForKey("coordinates") as! PFGeoPoint
        var dist = coords.distanceInMilesTo(PFGeoPoint(latitude: LocationManager.sharedInstance.lastKnownLatitude, longitude: LocationManager.sharedInstance.lastKnownLongitude))
        cell.distanceLabel.text = String(format: "%.1f miles away", dist)
        
        // Set Image
        if let fb_id = hitup.objectForKey("user_host") as? String {
            Functions.getPictureFromFBId(fb_id, completion: { (image) -> Void in
                cell.profilePic.image = image
            })
        }
        
        // Set Active/nonActive
        var expireDate : NSDate? = hitup.objectForKey("expire_time") as? NSDate
        if (expireDate == nil) {
            cell.setActive(false)
            var formatter = NSDateFormatter()
            formatter.dateFormat = "M/d"
            cell.pastTimeLabel.text = String(format:"Ended  %@", formatter.stringFromDate(hitup.createdAt!))
        } else {
            if ( NSDate().compare(expireDate!) == NSComparisonResult.OrderedAscending) {
                // expireDate hasn't happenned yet
                cell.setActive(true)
                var seconds =  NSDate().timeIntervalSinceDate(expireDate!) * -1
                
                cell.pastTimeLabel.text = String(format: "%.0f min left", seconds / 60)
            } else {
                var formatter = NSDateFormatter()
                cell.setActive(false)
                formatter.dateFormat = "M/d"
                cell.pastTimeLabel.text = String(format:"Ended  %@", formatter.stringFromDate(expireDate!))
            }
        }
        
        //newHitup["expire_time"] = NSDate(timeIntervalSinceNow: 60 * 60 * stepper.value)
        //newHitup["duration"] = stepper.value
        
        
        // Set Cell Type
        var user_hosted = hitup["user_host"] as! String
        var users_joined = hitup["users_joined"] as! [AnyObject]
        var currentUser_fbId = PFUser.currentUser()!.objectForKey("fb_id") as! String
        if(currentUser_fbId == user_hosted){
            cell.setCellType(HitupCell.cellType.Hosted)
        }
        else if( (users_joined as NSArray).containsObject(currentUser_fbId) ){
            cell.setCellType(HitupCell.cellType.Joined)
        }
        else {
            cell.setCellType(HitupCell.cellType.NotResponded)
        }
        
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        println("select")
        hitupToSend = hitups[indexPath.row] as! PFObject
        performSegueWithIdentifier("detail", sender: self)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Showing Detail")
        
        if segue.identifier == "detail" {
            var detailController : HitupDetailViewController = segue.destinationViewController as! HitupDetailViewController
            //detailController.savedHitup = hitups.objectAtIndex(hitupToBeSentIndex) as? Hitup
            
            detailController.thisHitup = hitupToSend
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
    }
    

}
