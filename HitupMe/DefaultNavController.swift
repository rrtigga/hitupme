//
//  DefaultNavController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class DefaultNavController: UINavigationController {

    var isMap = false
    var switchView = UISegmentedControl(items: ["All", "Active Only"] )
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationBar.tintColor = Functions.colorWithHexString("DC808A")
        // Do any additional setup after loading the view.
    }

    func showSwitch(show: Bool) {
        if show == true {
            switchView.hidden = false
        } else {
            switchView.hidden = true
        }
    }
    
    func passSwitch() -> UISegmentedControl {
        return switchView
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func setIsMapTab(isMapTab: Bool) {
        isMap = isMapTab
        addSwitch()
    }
    
    func addSwitch() {
        switchView.selectedSegmentIndex = 0
        switchView.center = CGPointMake(navigationBar.frame.width/2, navigationBar.frame.height/2)
        self.navigationBar.addSubview( switchView )
    }



}
