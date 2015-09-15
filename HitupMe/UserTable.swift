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
    var users = [AnyObject]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: Selector("pullRefresh"), forControlEvents: UIControlEvents.ValueChanged)
        pullRefresh()
        
    }
    
    func pullRefresh() {
        HighLevelCalls.getTesters { (success, objects) -> Void in
            self.users = objects!
            self.refreshController.endRefreshing()
            self.tableView.reloadData()
        }
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
        var user = users[indexPath.row] as! PFObject
        cell.numberLabel.text = String(format:"%i.", indexPath.row + 1)
        cell.nameLabel.text = (user.objectForKey("first_name") as! String) + " " + (user.objectForKey("last_name") as! String)
        Functions.getPictureFromFBId(user.objectForKey("fb_id") as! String, completion: { (image) -> Void in
            cell.pictureView.image = image
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("open")
        var user = users[indexPath.row] as! PFObject
        var url = NSURL(string: String(format:"https://www.facebook.com/%@?ref=0", user.objectForKey("fb_id") as! String))
        if ( !UIApplication.sharedApplication().openURL(url!)) {
            var desc = url?.debugDescription
            println(desc)
        }
        
        
        
    }


}
