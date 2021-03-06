//
//  MyHitupsTab.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class MyHitupsTab: UITableViewController, FBSDKLoginButtonDelegate {

    var hitups = [AnyObject]()
    var refreshController = UIRefreshControl()
    var refresh = true
    
    var hitupToSend = PFObject(className: "Hitups")
    
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
        var user = PFUser.currentUser()
        var first = user?.objectForKey("first_name") as? String
        var last = user?.objectForKey("last_name") as? String
        
        // Set Profile Information
        var defaults = NSUserDefaults.standardUserDefaults()
        var userInfo = defaults.objectForKey("userInfo_dict") as! NSDictionary
        userNameLabel.text = String(format:"%@ %@", first!, last! )
        var friendArray: NSArray = defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        friendCountLabel.text = String(friendArray.count)
        hitupCountLabel.text = String(format:"%i", user?.objectForKey("num") as! Int )
        Functions.getPictureFromFBId(userInfo.objectForKey("id") as! String, completion: { (image) -> Void in
             self.profilePic.image = image
        })
        

        // Refresh Controller
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: "pullRefresh", forControlEvents: UIControlEvents.ValueChanged)
    }

    func pullRefresh() {
        tableView.userInteractionEnabled = false
        HighLevelCalls.getMyHitups { (success, objects) -> Void in
            self.hitups = objects!
            self.tableView.reloadData()
            self.refreshController.endRefreshing()
            self.tableView.userInteractionEnabled = true
        }
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if Functions.refreshTab(3) == true {
            pullRefresh()
        } else {
            tableView.reloadData()
        }
        
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }

    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOutInBackground()
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
        var hitup = hitups[indexPath.row] as! PFObject
        
        cell.headerLabel.text = hitup.objectForKey("header") as? String
       
        // Set Cell Type
        var user_hosted = hitup["user_host"] as! String
        var currentUser_fbId = PFUser.currentUser()!.objectForKey("fb_id") as! String
        if(currentUser_fbId == user_hosted){
            cell.setCellType(myHitupCell.cellType.Hosted)
        }
        else{
            cell.setCellType(myHitupCell.cellType.Joined)
        }
        
        // Set Time Label
        var created = hitup.createdAt
        var seconds =  NSDate().timeIntervalSinceDate(created!)
        cell.timeLabel.text = String(format: "%.1fhr", seconds/3600)
        
        // Set Host Image
        Functions.getPictureFromFBId(hitup.objectForKey("user_host") as! String) { (image) -> Void in
            cell.profilePic.image = image
        }
        
        // Set Number Joined
        var number_joined = hitup.objectForKey("users_joined") as! [AnyObject]
        var joined_size = number_joined.count
        var num = joined_size - 1
        cell.joinLabel.text = String(format: "+ %i", num )
        

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

    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
        // Create a variable that you want to send based on the destination view controller
        // You can get a reference to the data by using indexPath shown below
        println("select")
        hitupToSend = hitups[indexPath.row] as! PFObject
        performSegueWithIdentifier("detailOfMy", sender: self)
    }
    
    
    // MARK: - Navigation
    
    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Showing Detail")
        if segue.identifier == "detailOfMy" {
            var detailController : HitupDetailViewController = segue.destinationViewController as! HitupDetailViewController
            //detailController.savedHitup = hitups.objectAtIndex(hitupToBeSentIndex) as? Hitup
            
            detailController.thisHitup = hitupToSend
        }
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        
        
    }
}
