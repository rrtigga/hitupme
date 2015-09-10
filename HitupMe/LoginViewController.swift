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
        loginButton.addTarget(nil , action: Selector("touchLogin"), forControlEvents: UIControlEvents.TouchUpInside)
    }
    
    func touchLogin() {
        PFFacebookUtils.logInInBackgroundWithReadPermissions(askedPermissions) {
            (user: PFUser?, error: NSError?) -> Void in
            if let user = user {
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
                            
                            user.saveInBackground()
                            
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
            println("error %@", error.description)
        }
        else if result.isCancelled {
            // Handle cancellations
            println("FB Login was Canceled")
        }
        else {
            // Check if specific permissions missing
            if result.grantedPermissions == NSSet( array: askedPermissions )
            {
                println("Login Success")
            
                Functions.updateFacebook({ (success) -> Void in
                    BackendAPI.connect({ (success) -> Void in
                        var defaults = NSUserDefaults.standardUserDefaults()
                        var userInfo_dict = defaults.objectForKey("userInfo_dict") as! NSDictionary

                        
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
                println("Missing Permissions?")
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
    
    
    func loginButtonDidLogOut(loginButton: FBSDKLoginButton!) {
        println("User Logged Out")
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
