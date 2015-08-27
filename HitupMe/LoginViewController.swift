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
                
                // Test SID Retrieval
                var request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/connect")!)
                var session = NSURLSession.sharedSession()
                var params = ["apiKey":"U5KMDLQ9KHN4G8MO54EH9DKG896NUETMH4DYT98W3N0HAMSO4E"] as Dictionary<String, String>
                var postString = "apiKey=U5KMDLQ9KHN4G8MO54EH9DKG896NUETMH4DYT98W3N0HAMSO4E"
                var err: NSError?
                request.HTTPBody = postString.dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: true)
                request.addValue("application/json", forHTTPHeaderField: "Content-Type")
                request.addValue("application/json", forHTTPHeaderField: "Accept")

                var task = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                        println("Response: \(response)")
                        var strData = NSString(data: data, encoding: NSUTF8StringEncoding)
                        println("Body: \(strData)")
                        var err: NSError?
                        var json = NSJSONSerialization.JSONObjectWithData(data, options: .MutableLeaves, error: &err) as? NSDictionary
                        
                        // Did the JSONObjectWithData constructor return an error? If so, log the error to the console
                        if(err != nil) {
                            println(err!.localizedDescription)
                            let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                            println("Error could not parse JSON: '\(jsonStr)'")
                        }
                        else {
                            // The JSONObjectWithData constructor didn't return an error. But, we should still
                            // check and make sure that json has a value using optional binding.
                            if let parseJSON = json {
                                // Okay, the parsedJSON is here, let's get the value for 'success' out of it
                                var success = parseJSON["success"] as? Int
                                println("Succes: \(success)")
                            }
                            else {
                                // Woa, okay the json object was nil, something went worng. Maybe the server isn't running?
                                let jsonStr = NSString(data: data, encoding: NSUTF8StringEncoding)
                                println("Error could not parse JSON: \(jsonStr)")
                            }
                        }
                    })
                request.HTTPMethod = "POST"
                
                updateFacebook()
                task.resume()
                
                /*
                var request2 = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/user/addUser")!)
                var session2 = NSURLSession.sharedSession()
                var params2 = ["userId":"111", "picUrl":"1111", "firstName":"FirstTest", "lastName":"lastTest", "friends[]":["1","2"] ] as Dictionary<String, String>
                var task2 = session.dataTaskWithRequest(request, completionHandler: {data, response, error -> Void in
                    println("Response: \(response)")
                })
                request2.HTTPMethod = "POST"
                */
            
            
            
                performSegueWithIdentifier("afterLogin", sender: nil)
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
                println(result)
            }
        })
        connection.addRequest(requestFriends, completionHandler: { (connection, result, error) -> Void in
            
            if error == nil {
                 var friendObjects = result["data"] as! [NSDictionary]
                 //for friend in friendObjects
                    
                //}
                
                println(result)
                var dic = NSDictionary(objects: [""], forKeys: ["first_name", "last_name", "person_id"])
                
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
