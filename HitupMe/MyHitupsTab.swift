//
//  MyHitupsTab.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class MyHitupsTab: UITableViewController, FBSDKLoginButtonDelegate {

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
        var defaults = NSUserDefaults.standardUserDefaults()
        var userInfo = defaults.objectForKey("userInfo_dict") as! NSDictionary
        // Set Name
        userNameLabel.text = String(format:"%@ %@", (userInfo.objectForKey("first_name") as? String)! , (userInfo.objectForKey("last_name") as? String)! )
        // Set Friend Num
        var friendArray: NSArray = defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        friendCountLabel.text = String(friendArray.count)
        // Set Picture
        Functions.getPictureFromFBId(userInfo.objectForKey("id") as! String, completion: { (image) -> Void in
             self.profilePic.image = image
        })
        
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
        return 4
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell

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

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    */

}
