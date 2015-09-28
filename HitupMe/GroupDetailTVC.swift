//
//  GroupDetailTVC.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/25/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class GroupDetailTVC: UITableViewController {

    var group = PFObject(className: "Groups")
    var owner = false
    @IBOutlet var leaveButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        var user = PFUser.currentUser()
        var host = group.objectForKey("user_host") as! String
        var userId = user?.objectForKey("fb_id") as! String
        setIsOwner(host == userId)
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
    }

    func setIsOwner(isOwner: Bool) {
        owner = isOwner
        if isOwner == true {
            leaveButton.setTitle("Delete Group", forState: UIControlState.Normal)
            leaveButton.setTitleColor(UIColor.redColor(), forState: UIControlState.Normal)
        } else {
            leaveButton.setTitle("Leave Group", forState: UIControlState.Normal)
            leaveButton.setTitleColor(UIColor.blueColor(), forState: UIControlState.Normal)
        }
    }
    
    @IBAction func touchLeave(sender: AnyObject) {
        if owner == true {
            promptDeleteAlert()
        } else {
            promptLeaveAlert()
        }
        
    }
    
    func promptDeleteAlert() {
        var alert = UIAlertController(title: "Delete Group?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            println("Yes")
            
            var user = PFUser.currentUser()
            var fullName = (user?.objectForKey("first_name") as! String) + (user?.objectForKey("last_name") as! String)
            
            self.group.deleteInBackground()
            
            
            Functions.setRefreshTabTrue(2)
            self.navigationController?.popViewControllerAnimated(true)
            
            
            // Create our query to notify all users joined
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("fb_id", containedIn: self.group.objectForKey("users_joined") as! [AnyObject] )
            pushQuery!.whereKey("fb_id", notEqualTo: user?.objectForKey("fb_id") as! String)
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            //header text
            var groupName =  self.group.objectForKey("group_name") as! String
            push.setMessage(groupName + "has been deleted" )
            //push.sendPushInBackground()
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: { action in
            println("No")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }

    
    func promptLeaveAlert() {
        var alert = UIAlertController(title: "Leave Group?", message: "", preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "Yes", style: UIAlertActionStyle.Default, handler: { action in
            println("Yes")
            Functions.setRefreshTabTrue(2)
            //self.navigationController?.popViewControllerAnimated(true)
            var user = PFUser.currentUser()
            var fullName = (user?.objectForKey("first_name") as! String) + (user?.objectForKey("last_name") as! String)
            
            self.group.removeObjectsInArray([user!.objectForKey("fb_id") as! String], forKey: "users_joined")
            self.group.removeObjectsInArray([fullName], forKey: "users_joined")
            self.group.saveInBackground()
            
            user?.removeObjectsInArray([self.group.objectForKey("group_id") as! String], forKey: "groups_joined")
            user?.saveInBackground()
            self.navigationController?.popViewControllerAnimated(true)
            
            /*
            // Create our query to notify all users joined
            let pushQuery = PFInstallation.query()
            pushQuery!.whereKey("fb_id", containedIn: self.group.objectForKey("users_joined") as! [AnyObject] )
            pushQuery!.whereKey("fb_id", notEqualTo: user?.objectForKey("fb_id") as! String)
            // Send push notification to query
            let push = PFPush()
            push.setQuery(pushQuery) // Set our Installation query
            //header text
            var groupName =  self.group.objectForKey("group_name") as! String
            push.setMessage(fullName + " has left " + groupName)
            //push.sendPushInBackground()*/
            
        }))
        alert.addAction(UIAlertAction(title: "No", style: UIAlertActionStyle.Destructive, handler: { action in
            println("No")
        }))
        
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        var joined = group.objectForKey("users_joined") as! [AnyObject]
        return joined.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! userTableCell
        var joined = group.objectForKey("users_joined") as! [AnyObject]
        var joinedNames = group.objectForKey("users_joinedNames") as! [AnyObject]
        cell.numberLabel.text = String(format:"%i.", indexPath.row + 1)
        cell.nameLabel.text = joinedNames[indexPath.row] as? String
        Functions.getPictureFromFBId(joined[indexPath.row] as! String, completion: { (image) -> Void in
            cell.pictureView.image = image
            
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }

    /*
    // Override to support conditional editing of the table view.
    override func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            // Delete the row from the data source
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(tableView: UITableView, moveRowAtIndexPath fromIndexPath: NSIndexPath, toIndexPath: NSIndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(tableView: UITableView, canMoveRowAtIndexPath indexPath: NSIndexPath) -> Bool {
        // Return NO if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
