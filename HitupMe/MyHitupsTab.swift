//
//  MyHitupsTab.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class MyHitupsTab: UITableViewController, FBSDKLoginButtonDelegate {

    var hitups = NSMutableArray()
    var refreshController = UIRefreshControl()
    var refresh = true
    
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var friendCountLabel: UILabel!
    @IBOutlet var hitupCountLabel: UILabel!
    @IBOutlet var userNameLabel: UILabel!
    @IBAction func touchProfileButton(sender: AnyObject) {
       loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    
    let loginView : FBSDKLoginButton = FBSDKLoginButton()
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loginView.delegate = self
        hitups = NSMutableArray(array: HighLevelCalls.getLocalMyHitups())
        
        /*
        // Set Profile Information
        var defaults = NSUserDefaults.standardUserDefaults()
        var userInfo = defaults.objectForKey("userInfo_dict") as! NSDictionary
        userNameLabel.text = String(format:"%@ %@", (userInfo.objectForKey("first_name") as? String)! , (userInfo.objectForKey("last_name") as? String)! )
        var friendArray: NSArray = defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        friendCountLabel.text = String(friendArray.count)
        Functions.getPictureFromFBId(userInfo.objectForKey("id") as! String, completion: { (image) -> Void in
             self.profilePic.image = image
        })
        */

        // Refresh Controller
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: "pullRefresh", forControlEvents: UIControlEvents.ValueChanged)
    }

    func pullRefresh() {
        tableView.userInteractionEnabled = false
        
        // Get Hitups from Server
        hitups = NSMutableArray(array: HighLevelCalls.getLocalMyHitups() )
        tableView.reloadData()
        refreshController.endRefreshing()
        tableView.userInteractionEnabled = true
        //
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Functions.refreshTab(3) == true {
            pullRefresh()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        performSegueWithIdentifier("logout", sender: nil)
        println("User Logged Out of App")
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
        return hitups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! myHitupCell
        
        var hitup = hitups.objectAtIndex(indexPath.row) as! Hitup
        cell.headerLabel.text = hitup.header
        if hitup.hosted == true {
            cell.setCellType(myHitupCell.cellType.Hosted)
        } else {
            cell.setCellType(myHitupCell.cellType.Joined)
        }
        
        // Configure the cell...

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

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }

}
