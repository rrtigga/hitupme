//
//  PickGroupTVC.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/25/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class PickGroupTVC: UITableViewController {
    
    var group_list = [AnyObject]()
    
    @IBAction func touchNone(sender: AnyObject) {
        var createVC = navigationController?.viewControllers.first as! CreateController
        createVC.chosenSquadName = ""
        createVC.chosenSquadID = ""
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        HighLevelCalls.getGroups { (success, objects) -> Void in
            self.group_list = objects!
            self.tableView.reloadData()
        }
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem()
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
        return group_list.count
    }

    // For each Row, Return a cell. Here you can do customization / fill in information
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> PickGroupCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! PickGroupCell
        var group = group_list[indexPath.row] as! PFObject
        var gName = group.objectForKey("group_name") as? String
        var memList = group.objectForKey("users_joined") as? [AnyObject]
        if (gName != nil && memList != nil) {
            cell.GroupName.text = group.objectForKey("group_name") as? String
            cell.GroupImage.sizeToFit()
            cell.Num_Members.text = String(format:"%i members", memList!.count)
        } else {
            println("PCGTVC: nil group name || users_joiend?")
        }
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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        var createVC = navigationController?.viewControllers.first as! CreateController
        var group = group_list[indexPath.row] as! PFObject
        var groupName = group.objectForKey("group_name") as? String
        var groupID = group.objectForKey("group_id") as? String
        if (groupID != nil && groupName != nil) {
            createVC.chosenSquadName = groupName!
            createVC.chosenSquadID = groupID!
        } else {
            println("PGTVC: group name or group nil?")
        }
        navigationController!.popToRootViewControllerAnimated(true)
    }
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("dd")
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }


}
