//
//  CreateGroupsVC.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class CreateGroupsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var users = NSArray()

    func initialSetup() {
        var defaults = NSUserDefaults.standardUserDefaults()
        users = defaults.objectForKey("arrayOfFriend_dicts") as! NSArray
        nameTextField.returnKeyType = UIReturnKeyType.Done
        tableView.allowsMultipleSelection = true
        tableView.delegate = self
        tableView.dataSource = self
    }

    @IBOutlet var nameTextField: UITextField!
    @IBOutlet var tableView: UITableView!
    
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
