//
//  ProfileMapView.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/20/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import MapKit

class ProfileMapView: UIViewController {

    func initialSetup() {
        navigationItem.title = userName
    }
    
    var userID : String?
    var userName : String?
    
    @IBOutlet var mapView: MKMapView!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        initialSetup()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
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
