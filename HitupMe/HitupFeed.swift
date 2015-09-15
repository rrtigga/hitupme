//
//  HitupFeed.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class HitupFeed: UITableViewController {
    
    var refreshController = UIRefreshControl()
    var hitups = [AnyObject]()
    
    var hitupToSend = PFObject(className: "Hitups")
    
    func configureTableView() {
        tableView.rowHeight = 108
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = Functions.defaultFadedColor()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        
        // Refresh Controller
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: "pullRefresh", forControlEvents: UIControlEvents.ValueChanged)
    
    }
    
    func pullRefresh() {
        var defaults = NSUserDefaults.standardUserDefaults()
        if defaults.boolForKey("locationEnabled") == false {
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
            }
        }
        
        Functions.updateLocation()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        Functions.updateLocation()
        if Functions.refreshTab(0) == true {
            pullRefresh()
        } else {
            tableView.reloadData()
        }
        
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
        cell.joinedLabel.text = String(format: "%i", joinedArray.count - 1)
        
        // Set Distance Label
        var coords = hitup.objectForKey("coordinates") as! PFGeoPoint
        var dist = coords.distanceInMilesTo(PFGeoPoint(latitude: LocationManager.sharedInstance.lastKnownLatitude, longitude: LocationManager.sharedInstance.lastKnownLongitude))
        cell.distanceLabel.text = String(format: "%.1f miles", dist)
        
        // Set Time Label
        var created = hitup.createdAt
        var seconds =  NSDate().timeIntervalSinceDate(created!)
        cell.pastTimeLabel.text = String(format: "%.1fhr", seconds/3600)
        
        // Set Image
        if let fb_id = hitup.objectForKey("user_host") as? String {
            Functions.getPictureFromFBId(fb_id, completion: { (image) -> Void in
                cell.profilePic.image = image
            })
        }
        
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
