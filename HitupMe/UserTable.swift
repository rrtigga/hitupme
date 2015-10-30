//
//  UserTable.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/12/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class UserTable: UITableViewController {

    var refreshController = UIRefreshControl()
    var users = NSArray()
    
    
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: Selector("pullRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        pullRefresh()
        
    }
    
    func pullRefresh() {
        let defaults = NSUserDefaults.standardUserDefaults()
        defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        self.users = defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        self.refreshController.endRefreshing()
        self.tableView.reloadData()
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return users.count
    }
    
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! userTableCell
        let user = users[indexPath.row] as! NSDictionary
        //cell.numberLabel.text = String(format:"%i.", users.count - indexPath.row)
        cell.numberLabel.text = String(format:"%i.", indexPath.row + 1)
        cell.nameLabel.text = (user.objectForKey("first_name") as! String) + " " + (user.objectForKey("last_name") as! String)
        Functions.getPictureFromFBId(user.objectForKey("id") as! String, completion: { (image) -> Void in
            cell.pictureView.image = image
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
            
        let user = users[indexPath.row] as! NSDictionary
        
        let pmv = storyboard!.instantiateViewControllerWithIdentifier("ProfileMapView") as! ProfileMapView
        pmv.userName = (user.objectForKey("first_name") as! String) + " " + (user.objectForKey("last_name") as! String)
        pmv.userID = user.objectForKey("id") as? String
        navigationController!.showViewController(pmv, sender: self)
        
        /* Open Faceook Profile
        println("open")
        var user = users[indexPath.row] as! PFObject
        var url = NSURL(string: String(format:"https://www.facebook.com/%@?ref=0", user.objectForKey("fb_id") as! String))
        if ( !UIApplication.sharedApplication().openURL(url!)) {
            var desc = url?.debugDescription
            println(desc)
        }
        */
        
        
        
    }

}
