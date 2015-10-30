//
//  GroupsTVC.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import Parse

class GroupsTVC: UITableViewController, FBSDKLoginButtonDelegate {

    
    func initialSetup() {
        configureTableView()
        refreshTable()
        tableView.addSubview(refreshController)
        refreshController.addTarget(self, action: "refreshTable", forControlEvents: UIControlEvents.ValueChanged)
    }
    
    var loadedOnce = false
    var groups = [AnyObject]()
    var refreshController = UIRefreshControl()
    let loginView : FBSDKLoginButton = FBSDKLoginButton()// Note for some reason this button must be allocated here.
    
    func configureTableView() {
        tableView.rowHeight = 90
        tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        tableView.backgroundColor = Functions.defaultFadedColor()
    }
    
    @IBAction func touchLogout(sender: AnyObject) {
        loginView.delegate = self
        loginView.sendActionsForControlEvents(UIControlEvents.TouchUpInside)
    }
    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
    }
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        PFUser.logOutInBackground()
        performSegueWithIdentifier("logout", sender: nil)
        print("User Logged Out of App")
    }
    // ----- End ----- //
    
    func refreshTable() {
        HighLevelCalls.getGroups { (success, objects) -> Void in
            if success == true {
                self.groups = objects!
                self.tableView.reloadData()
            } else {
                print("GTVC: Error refreshTable")
            }
            self.refreshController.endRefreshing()
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        if loadedOnce == false {
            // First Load, don't do anything
            loadedOnce = true
        } else {
            Functions.updateLocation()
            if Functions.refreshTab(2) == true {
                refreshTable()
            } else {
                tableView.reloadData()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialSetup()
        
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
        return groups.count
    }

    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! GroupCell
        let group = groups[indexPath.row] as! PFObject
        cell.groupName.text = group.objectForKey("group_name") as? String

        let joinedArray: [AnyObject]? = group.objectForKey("users_joined") as? [AnyObject]
        if (joinedArray != nil) {
            cell.numberLabel.text = String(format: "%i members", joinedArray!.count )
        } else {
            print("GTVC: joinedArray == nil?")
        }
        cell.moreButton.tag = indexPath.row
        cell.moreButton.addTarget(self, action: Selector("touchMore:"), forControlEvents: UIControlEvents.TouchUpInside)
        
        cell.backgroundColor = Functions.defaultFadedColor()
        return cell
    }
    
    func touchMore(sender: UIButton) {
        groupToSend = groups[sender.tag] as! PFObject
        performSegueWithIdentifier("GroupDetail", sender: self)
    }

    var groupToSend = PFObject(className: "Groups")
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let GMap = storyboard?.instantiateViewControllerWithIdentifier("GMap") as! GroupMapVC
        let group = groups[indexPath.row] as! PFObject
        GMap.chosenSquadID = group.objectForKey("group_id") as! String
        GMap.chosenSquadName = group.objectForKey("group_name") as! String
        navigationController?.showViewController(GMap, sender: self)
        
    }

    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "GroupDetail" {
            let detailController = segue.destinationViewController as! GroupDetailTVC
            detailController.group = groupToSend
        }
        // Get t
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
    }
    

}
