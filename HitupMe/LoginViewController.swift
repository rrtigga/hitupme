//
//  LoginViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/24/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit
import ParseFacebookUtilsV4

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var loginButton: UIButton!
    let askedPermissions = ["public_profile", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        Functions.initializeUserDefaults()
        Functions.setRefreshAllTabsTrue()
        PermissionRelatedCalls.requestNotifications()
        loginButton.addTarget(nil , action: Selector("touchLogin"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func touchLogin() {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(askedPermissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
                //if user.isNew {
                //    println("User signed up and logged in through Facebook!")
                //} else {
                    print("User logged in through Facebook!")
                    Functions.updateFacebook({ (success) -> Void in
                        if (success == true) {
                            let defaults = NSUserDefaults.standardUserDefaults()
                            let userInfo_dict = defaults.objectForKey("userInfo_dict") as! NSDictionary
                            
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
                            print("error retrieving FB infromation")
                        }
                        
                    })
                //}
            } else {
                print("Uh oh. The user cancelled the Facebook login.")
            }
        }
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        Functions.updateLocation()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Facebook Delegate Methods

    func loginButton(loginButton: FBSDKLoginButton!, didCompleteWithResult result: FBSDKLoginManagerLoginResult!, error: NSError!) {
        
        if ((error) != nil)
        {
            // Process error
            print("error %@", error.description)
        }
        else if result.isCancelled {
            // Handle cancellations
            print("FB Login was Canceled")
        }
        else {
            // Check if specific permissions missing
            if result.grantedPermissions == NSSet( array: askedPermissions )
            {
                print("Login Success")
            
                Functions.updateFacebook({ (success) -> Void in
                    BackendAPI.connect({ (success) -> Void in
                        let defaults = NSUserDefaults.standardUserDefaults()
                        let userInfo_dict = defaults.objectForKey("userInfo_dict") as! NSDictionary

                        
                        BackendAPI.addUser(userInfo_dict.objectForKey("id") as! String,
                            first_Name: userInfo_dict.objectForKey("first_name") as! String,
                            last_Name: userInfo_dict.objectForKey("last_name") as! String,
                            friends: defaults.objectForKey("arrayOfFriend_dicts") as! NSArray,
                            completion: { (success) -> Void in
                                
                                //self.performSegueWithIdentifier("afterLogin", sender: nil)
                        })
                        
                    })
                    self.performSegueWithIdentifier("afterLogin", sender: nil)
                })
            } else {
                print("Missing Permissions?")
            }
        }
    }

    func updateFacebook() {
        let requestMe = FBSDKGraphRequest(graphPath: "me?fields=id,first_name,last_name", parameters: nil)
        let requestFriends = FBSDKGraphRequest(graphPath: "me?fields=friends{first_name,last_name}", parameters: nil)
        let connection = FBSDKGraphRequestConnection()
        connection.addRequest(requestMe, completionHandler: { (connection, result, error) -> Void in
            if error == nil {
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(result, forKey: "userInfo_dict")
            }
        })
        connection.addRequest(requestFriends, completionHandler: { (connection, result, error: NSError!) -> Void in
            
            if error == nil {
                let friends = result["friends"] as! NSDictionary
                let friendData = friends["data"] as! NSArray
                let defaults = NSUserDefaults.standardUserDefaults()
                defaults.setObject(friendData, forKey: "arrayOfFriend_dicts")
                
            }
        })
        
        connection.start()
    }
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        print("User Logged Out")
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
