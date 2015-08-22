//
//  HitupDetailViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/22/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class HitupDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    @IBOutlet var tableView: UITableView!

    func configureTableView() {
        tableView.rowHeight = 34
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Potentially incomplete method implementation.
        // Return the number of sections.
        return 1
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete method implementation.
        // Return the number of rows in the section.
        return 12
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("reuseIdentifier", forIndexPath: indexPath) as! UITableViewCell
        // Configure the cell...
        
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
