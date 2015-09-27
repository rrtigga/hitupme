//
//  CreateGroupsVC.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class CreateGroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var users = NSArray()

    func initialSetup() {
        var defaults = NSUserDefaults.standardUserDefaults()
        users = defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        nameTextField.returnKeyType = UIReturnKeyType.Done
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
        nameTextField.delegate = self
    }

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    @IBAction func TouchDone(sender: AnyObject) {
        
        var users_joined = NSMutableArray()
        var users_joinedNames = NSMutableArray()
        var user_host = PFUser.currentUser()?.objectForKey("fb_id") as! String
        var user_hostName = (PFUser.currentUser()?.objectForKey("first_name") as! String) + (PFUser.currentUser()!.objectForKey("last_name") as! String)
        var group_name = nameTextField.text
        
        Functions.setRefreshTabTrue(2)
        
        // Get Array of selected rows
        var selectedRows = tableView.indexPathsForSelectedRows()
        if(selectedRows == nil || nameTextField.hasText() == false  || nameTextField.text == " "){
            println("selectedRows or nameTextField was null")
        }
        else {
            for (var i = 0; i < selectedRows!.count; i++) {
                var rowPath = selectedRows![i] as! NSIndexPath
                // Get dictionary of the ith selected User
                var user = users.objectAtIndex(rowPath.row) as! NSDictionary
                users_joined.addObject(user.objectForKey("id") as! String)
                users_joinedNames.addObject((user.objectForKey("first_name") as! String) + " " + (user.objectForKey("last_name") as! String))
            }
            users_joined.addObject(user_host)
            users_joinedNames.addObject(user_hostName)
            
            
            // Make PFObject
            var newGroup = PFObject(className:"Groups")
            newGroup["users_joined"] = users_joined
            newGroup["users_joinedNames"] = users_joinedNames
            newGroup["user_host"] = user_host
            newGroup["user_hostName"] = user_hostName
            newGroup["group_name"] = group_name
            newGroup["group_id"] = String(format: "%d-%@-%@", NSDate().timeIntervalSince1970, group_name, user_host)

            newGroup.saveInBackgroundWithBlock {
                (success: Bool, error: NSError?) -> Void in
                if (success) {
                    PFUser.currentUser()?.fetchInBackground()
                    println("Group was stored")
                } else {
                    println("Error adding Group")
                }
            }
            navigationController?.popToRootViewControllerAnimated(true)
        }

    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        nameTextField.resignFirstResponder()
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell
    {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UserCellGroup
        var user = users[indexPath.row] as! NSDictionary
        //cell.numberLabel.text = String(format:"%i.", users.count - indexPath.row)
        cell.userName.text = (user.objectForKey("first_name") as! String) + " " + (user.objectForKey("last_name") as! String)
        Functions.getPictureFromFBId(user.objectForKey("id") as! String, completion: { (image) -> Void in
            cell.profilePic.image = image
        })
        
        cell.selectionStyle = UITableViewCellSelectionStyle.None
        
        return cell
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
