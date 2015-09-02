//
//  CreateController.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/21/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class CreateController: UIViewController, UITextViewDelegate {
    
    // ---------- Variables ---------- //
    enum FieldType: Int {
        case header
        case details
        case location
    }
    var defaultHeaderText = "What are you doing"
    var defaultDetailsText = "Details (optional)"
    var defaultLocationText = "Location name (optional)"
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var headerTextView: UITextView!
    @IBOutlet var detailsTextView: UITextView!
    @IBOutlet var locationTextField: UITextField!
    @IBOutlet var cityLabel: UILabel!
    @IBAction func touchDone(sender: AnyObject) {
        if headerTextView.textColor != UIColor.lightGrayColor() {
            view.endEditing(true)
            let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
            var window: UIWindowLevel
            let windowTest = appDelegate.window
            var tabBarController: UITabBarController = windowTest!.rootViewController as! UITabBarController
            tabBarController.selectedIndex = 0
            var num = 0
            var firstNav = tabBarController.viewControllers![0] as! UINavigationController
            firstNav.popToRootViewControllerAnimated(true)
            var hitupFeed = firstNav.viewControllers![0] as! HitupFeed
            
            var details = " "
            if (detailsTextView.textColor != UIColor.lightGrayColor()) {details = detailsTextView.text}
            
            var hitup = NSDictionary(objects: [headerTextView.text, locationTextField.text, "0 joined", "<0.1 miles away", "<1m", details, true, false ], forKeys: ["header", "locationName", "numberJoined", "distance", "recency", "details", "hosted", "joined" ])
            hitupFeed.addTopHitup(hitup)
            
            var locationText = " "
            if locationTextField.hasText() { locationText = locationTextField.text}
            
            var defaults = NSUserDefaults.standardUserDefaults()
            var userDict = defaults.objectForKey("userInfo_dict") as! NSDictionary
            var userId = userDict.objectForKey("id") as! String
            var firstName = userDict.objectForKey("first_name") as! String
            
            
            BackendAPI.addHitup(headerTextView.text, description: details, locationName: locationText, coordinates: "placeholder", timeCreated: "temp", userId: userId, firstName: firstName, completion: { (success) -> Void in
                if success == true {
                    println("Successful Post")
                }
            })
            
            dismissViewControllerAnimated(true, completion: {})
        }
    }

    @IBAction func touchCancel(sender: AnyObject) {
        view.endEditing(true)
        dismissViewControllerAnimated(true, completion: {})
    }

    
    // ---------- This runs right after Create Hitup Button is touched ---------- //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set TextViews
        setHeaderDefault()
        setDetailsDefault()
        setLocationDefault()
        headerTextView.tag = FieldType.header.rawValue
        detailsTextView.tag = FieldType.details.rawValue
        headerTextView.delegate = self
        detailsTextView.delegate = self
        
        // Set First Responder
        headerTextView.becomeFirstResponder()
        headerTextView.selectedRange = NSRange(location: 0,length: 0)
        
        Functions.updateLocation()
        var defaults = NSUserDefaults.standardUserDefaults()
        cityLabel.text = String(format: "%@, %@", defaults.objectForKey("city") as! String, defaults.objectForKey("state") as! String )
    }

    
    // ---------- These two functions Reset the TextViews to Placeholder Text ---------- //
    func setHeaderDefault() {
        headerTextView.text = defaultHeaderText
        headerTextView.textColor = UIColor.lightGrayColor()
    }
    func setDetailsDefault() {
        detailsTextView.text = defaultDetailsText
        detailsTextView.textColor = UIColor.lightGrayColor()
    }
    func setLocationDefault() {
        
        let str = NSAttributedString(string: defaultLocationText, attributes: [NSForegroundColorAttributeName:Functions.defaultLocationColor()])
        locationTextField.attributedPlaceholder = str
        locationTextField.borderStyle = UITextBorderStyle.None
        let gesture = UIGestureRecognizer(target: self, action: Selector("touchLocation"))
    }
    
    func touchLocation() {
        println("sdfds")
        locationTextField.becomeFirstResponder()
    }
    
    
    // ---------- These Callbacks run when Actions take place ---------- //
    func textView(textView: UITextView, shouldChangeTextInRange range: NSRange, replacementText text: String) -> Bool {
        
        // Combine the textView text and the replacement text to
        // create the updated text string
        let currentText:NSString = textView.text
        let updatedText = currentText.stringByReplacingCharactersInRange(range, withString:text)
        
        // If updated text view will be empty, add the placeholder
        // and set the cursor to the beginning of the text view
        if updatedText.isEmpty {
            
            //textView.text = "Placeholder"
            if textView.tag == FieldType.header.rawValue {
                textView.text = defaultHeaderText
                // headerTextView.selectedRange = NSRange(location: 0,length: 0)
                    
            }
            else if textView.tag == FieldType.details.rawValue {
                textView.text=defaultDetailsText
                // detailsTextView.selectedRange = NSRange(location: 0,length: 0)
            }
            
            else if textView.tag == FieldType.location.rawValue {
                textView.text=defaultLocationText
            }

            textView.textColor = UIColor.lightGrayColor()
            
            textView.selectedTextRange = textView.textRangeFromPosition(textView.beginningOfDocument, toPosition: textView.beginningOfDocument)
            
            return false
        }
            
            // Else if the text view's placeholder is showing and the
            // length of the replacement string is greater than 0, clear
            // the text view and set its color to black to prepare for
            // the user's entry
        else if textView.textColor == UIColor.lightGrayColor() && !text.isEmpty {
            textView.text = nil
            textView.textColor = UIColor.blackColor()
        }
        
        return true
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        if (textView.textColor != nil) {
            if textView.tag == FieldType.header.rawValue {
                if textView.textColor == UIColor.lightGrayColor() {
                    headerTextView.selectedRange = NSRange(location: 0,length: 0)
                }
            } else if textView.tag == FieldType.details.rawValue {
                if textView.textColor == UIColor.lightGrayColor() {
                    detailsTextView.selectedRange = NSRange(location: 0,length: 0)
                }
            }
        }
    }
    
    func textViewDidChange(textView: UITextView) {
        if (textView.textColor != nil) {
            if textView.tag == FieldType.header.rawValue {
                if textView.textColor == UIColor.lightGrayColor() {
                    headerTextView.selectedRange = NSRange(location: 0,length: 0)
                }
            } else if textView.tag == FieldType.details.rawValue {
                if textView.textColor == UIColor.lightGrayColor() {
                    detailsTextView.selectedRange = NSRange(location: 0,length: 0)
                }
            }
        }
    }
    
    /*func textViewDidChangeSelection(textView: UITextView) {
        //println(textView.tag)
        // Set Cursor
        if (textView.textColor != nil) {
            if textView.tag == FieldType.header.rawValue {
                if textView.textColor == UIColor.lightGrayColor() {
                    headerTextView.selectedRange = NSRange(location: 0,length: 0)
                }
            } else if textView.tag == FieldType.details.rawValue {
                if textView.textColor == UIColor.lightGrayColor() {
                    detailsTextView.selectedRange = NSRange(location: 0,length: 0)
                }
            }
        }
    }*/
    
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
