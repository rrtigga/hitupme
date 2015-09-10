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
        Functions.updateLocation()
        
        // Refresh Controller
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: "pullRefresh", forControlEvents: UIControlEvents.ValueChanged)
        
        println( FBSDKAccessToken.currentAccessToken() )
        
        //Hitup.resetCoreData()
    
    }
    
    func pullRefresh() {
        tableView.userInteractionEnabled = false
        
        HighLevelCalls.updateNearbyHitups { (success, objects) -> Void in
                self.hitups = objects!
                self.tableView.reloadData()
                self.refreshController.endRefreshing()
                self.tableView.userInteractionEnabled = true
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Functions.refreshTab(0) == true {
            pullRefresh()
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
        cell.joinedLabel.text = "2 Joined"
        
        cell.distanceLabel.text = "<1 mile away"
        cell.pastTimeLabel.text = "1hr"
        
        if let fb_id = hitup.objectForKey("user_host") as? String {
            Functions.getPictureFromFBId(fb_id, completion: { (image) -> Void in
                cell.profilePic.image = image
            })
        }
        
        /*
        if (hitup.joined == true) {
            cell.setCellType(HitupCell.cellType.Joined)
        } else if (hitup.hosted == true) {
            cell.setCellType(HitupCell.cellType.Hosted)
        } else {
            cell.setCellType(HitupCell.cellType.NotResponded)
        }*/
        
        /*
        var hitupDict : NSDictionary =  Model.getLocalNearbyHitupsAtIndex(indexPath.row )
        cell.HeaderLabel.text = hitupDict["header"] as? String
        cell.locationLabel.text = hitupDict["locationName"] as? String
        cell.joinedLabel.text = hitupDict["numberJoined"] as? String
        cell.distanceLabel.text = hitupDict["distance"] as? String
        cell.pastTimeLabel.text = hitupDict["recency"] as? String
        if (hitupDict["joined"] as? Bool == true) {
            cell.setCellType(HitupCell.cellType.Joined)
        } else if (hitupDict["hosted"] as? Bool == true) {
            cell.setCellType(HitupCell.cellType.Hosted)
        } else {
            cell.setCellType(HitupCell.cellType.NotResponded)
        }
        */
        
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
