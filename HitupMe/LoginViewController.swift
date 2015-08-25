//
//  LoginViewController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/24/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController, FBSDKLoginButtonDelegate {
    
    @IBOutlet var loginButton: FBSDKLoginButton!
    let askedPermissions = ["public_profile", "user_friends"]
    
    override func viewDidLoad() {
        super.viewDidLoad()

        loginButton.delegate = self
        loginButton.readPermissions = askedPermissions
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        // User is already logged in
        if (FBSDKAccessToken.currentAccessToken() != nil){
            println("Already Logged in")
            performSegueWithIdentifier("afterLoginNoAnimate", sender: nil)
        }
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
                performSegueWithIdentifier("afterLogin", sender: nil)
            } else {
                println("Missing Permissions?")
            }
        }
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
