//
//  TabBarController.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/17/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class TabBarController: UITabBarController {
    
    
    // ----- Setup Functions ----- //
    
    func initialSetup() {
        addIntro()
        setupCreateButton()
    }
    
    func addIntro() {
        
        var defaults = NSUserDefaults.standardUserDefaults()
        var installed: Bool? = defaults.boolForKey("installed_once")
        if (installed == nil || installed == false) {
            var evc = ExplainationViewController(nibName: "ExplainationViewController", bundle: nil)
            //var evc = ExplainationViewController()
            evc.view.frame = view.frame
            introView = evc.view
            evc.doneButton.addTarget(self, action: Selector("removeIntro"), forControlEvents: UIControlEvents.TouchUpInside)
            view.addSubview(evc.view)
            
            defaults.setBool(true, forKey: "installed_once")
        }
        
        
    }
    
    var introView: UIView?
    
    func removeIntro() {
        introView!.removeFromSuperview()
        introView = nil
    }
    
    
    

    
    func setupTabBar() {
        self.tabBar.tintColor = Functions.themeColor()
    }
    
    func setupCreateButton() {
        // Set up CreateButton
        var button = UIButton(frame: CGRectMake(0, 0, self.tabBar.frame.size.width/3, self.tabBar.frame.size.height-1))
        button.center = CGPointMake(self.tabBar.frame.size.width/2, button.center.y)
        button.backgroundColor = UIColor.clearColor()
        var buttonImage = UIImageView(frame: CGRectMake(0, 3, 30, 30))
        buttonImage.center = CGPointMake(button.frame.size.width/2, buttonImage.center.y)
        buttonImage.image = UIImage(named: "BB_Create")
        button.addSubview(buttonImage)
        self.tabBar.addSubview(button)
        button.addTarget(self, action: Selector("touchCreate"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    // ----- Button Functions ----- //
    
    func touchCreate() {
        var createView = self.storyboard!.instantiateViewControllerWithIdentifier("CreateNav") as! UINavigationController
        presentViewController(createView, animated: true, completion: nil)
    }
    
    /*
    override func viewWillLayoutSubviews() {
        var rect = tabBar.frame
        rect.size.height = 40
        self.tabBar.frame = rect
    }*/
    
    override func viewDidLoad() {
        super.viewDidLoad()
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
