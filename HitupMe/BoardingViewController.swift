//
//  BoardingViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 9/16/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class BoardingViewController: UIViewController, UIPageViewControllerDataSource {
    
    @IBOutlet var loginButton: UIButton!
    
    // Initialize it right away here
    let controllerNames = ["Onboarding_0", "Onboarding_3", "Onboarding_2", "Onboarding_1"]

    // MARK: - View Lifecycle
    let askedPermissions = ["public_profile", "user_friends"]

    override func viewDidLoad() {
        super.viewDidLoad()
        createPageViewController()
        setupPageControl()
        Functions.initializeUserDefaults()
        Functions.setRefreshAllTabsTrue()
        loginButton.addTarget(nil , action: Selector("touchLogin"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        PermissionRelatedCalls.askLocation()
    }
    
    func touchLogin() {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(askedPermissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                Functions.updateLocation()
                //if user.isNew {
                //    println("User signed up and logged in through Facebook!")
                //} else {
                println("User logged in through Facebook!")
                Functions.updateFacebook({ (success) -> Void in
                    if (success == true) {
                        var defaults = NSUserDefaults.standardUserDefaults()
                        var userInfo_dict = defaults.objectForKey("userInfo_dict") as! NSDictionary
                        
                        user["first_name"] = userInfo_dict.objectForKey("first_name") as! String
                        user["last_name"] = userInfo_dict.objectForKey("last_name") as! String
                        user["fb_id"] = userInfo_dict.objectForKey("id") as! String
                        if (user.isNew) {
                            user["num"] = 0
                        }
                        user.saveInBackground()
                        
                        let installation = PFInstallation.currentInstallation()
                        if let id = PFUser.currentUser()?.objectForKey("fb_id") as? String
                        {
                            installation["fb_id"] = id
                        }
                        installation.saveInBackground()
                        
                        /*BackendAPI.addUser(userInfo_dict.objectForKey("id") as! String,
                        first_Name: userInfo_dict.objectForKey("first_name") as! String,
                        last_Name: userInfo_dict.objectForKey("last_name") as! String,
                        friends: defaults.objectForKey("arrayOfFriend_dicts") as! NSArray,
                        completion: { (success) -> Void in
                        
                        //self.performSegueWithIdentifier("afterLogin", sender: nil)
                        })*/
                        
                        self.performSegueWithIdentifier("afterLogin", sender: nil)
                        
                    } else {
                        println("error retrieving FB infromation")
                    }
                    
                })
                //}
            } else {
                println("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    func updateFacebook() {
        var requestMe = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name", parameters: nil)
        var requestFriends = FBSDKGraphRequest(graphPath: "me?fields=friends{first_name,last_name}", parameters: nil)
        var connection = FBSDKGraphRequestConnection()
        connection.addRequest(requestMe, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                var defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(result, forKey: "userInfo_dict")
            }
        })
        connection.addRequest(requestFriends, completionHandler: { (connection, result, error: NSError!) -> Void in
            
            if error == nil {
                var friends = result["friends"] as! NSDictionary
                var friendData = friends["data"] as! NSArray
                var defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(friendData, forKey: "arrayOfFriend_dicts")
                
            }
        })
        
        connection.start()
    }
    
    private func setupPageControl() {
        let appearance = UIPageControl.appearance()
        appearance.pageIndicatorTintColor = UIColor.grayColor()
        appearance.currentPageIndicatorTintColor = UIColor.blackColor()
        appearance.backgroundColor = UIColor.whiteColor()
    }
    
    
    private func createPageViewController() {
        
        let pageController = UIPageViewController(transitionStyle: UIPageViewControllerTransitionStyle.Scroll, navigationOrientation: UIPageViewControllerNavigationOrientation.Horizontal, options: nil)
        pageController.dataSource = self
        pageController.automaticallyAdjustsScrollViewInsets = false;
        
        if controllerNames.count > 0 {
            let firstController = getViewController(0)!
            let startingViewControllers: NSArray = [firstController]
            pageController.setViewControllers(startingViewControllers as [AnyObject], direction: UIPageViewControllerNavigationDirection.Forward, animated: false, completion: nil)
        }
        
        var pageViewController = pageController
        pageViewController.view.frame = CGRectMake(0, 0, view.frame.size.width, view.frame.size.height - 80)
        addChildViewController(pageViewController)
        self.view.addSubview(pageViewController.view)
        
        
        pageViewController.didMoveToParentViewController(self)
    }
    
    // MARK: - UIPageViewControllerDataSource
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerBeforeViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! OnboardScreen
        
        if itemController.itemIndex > 0 {
            return getViewController(itemController.itemIndex-1)
        }
        
        return nil
    }
    
    func pageViewController(pageViewController: UIPageViewController, viewControllerAfterViewController viewController: UIViewController) -> UIViewController? {
        
        let itemController = viewController as! OnboardScreen
        
        if itemController.itemIndex+1 < controllerNames.count {
            return getViewController(itemController.itemIndex+1)
        }
        
        return nil
    }

    func getViewController(itemIndex: Int) -> UIViewController? {
        
        if itemIndex < controllerNames.count && itemIndex >= 0 {
            var name = controllerNames[itemIndex] as String
            let screen = self.storyboard!.instantiateViewControllerWithIdentifier(name) as? OnboardScreen
            screen?.itemIndex = itemIndex
            return screen
        }
        
        return nil
    }
    
    // MARK: - Page Indicator
    
    func presentationCountForPageViewController(pageViewController: UIPageViewController) -> Int {
        return controllerNames.count
    }
    
    func presentationIndexForPageViewController(pageViewController: UIPageViewController) -> Int {
        return 0
    }
    
}
