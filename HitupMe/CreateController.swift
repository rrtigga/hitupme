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
    var defaultDetailsText = "What are the Details?"
    var defaultLocationText = "Add a location (optional)"
    @IBOutlet var profilePic: UIImageView!
    @IBOutlet var headerTextView: UITextView!
    @IBOutlet var detailsTextView: UITextView!
    @IBAction func touchDone(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: {})
    }

    
    // ---------- This runs right after Create Hitup Button is touched ---------- //
    override func viewDidLoad() {
        super.viewDidLoad()
        // Set TextViews
        setHeaderDefault()
        setDetailsDefault()
        headerTextView.tag = FieldType.header.rawValue
        detailsTextView.tag = FieldType.details.rawValue
        headerTextView.delegate = self
        detailsTextView.delegate = self
        
        
        // Set First Responder
        headerTextView.becomeFirstResponder()
        headerTextView.selectedRange = NSRange(location: 0,length: 0)
    }

    
    // ---------- These two functions Reset the TextViews to Placeholder Text ---------- //
    func setHeaderDefault() {
        headerTextView.text = defaultHeaderText
        headerTextView.textColor = Functions.defaultFadedColor()
    }
    func setDetailsDefault() {
        detailsTextView.text = defaultDetailsText
        detailsTextView.textColor = Functions.defaultFadedColor()
    }
    
    
    // ---------- These Callbacks run when Actions take place ---------- //
    func textViewDidChangeSelection(textView: UITextView) {
        //println(textView.tag)
        // Set Cursor
        if textView.tag == FieldType.header.rawValue {
            if textView.text == defaultHeaderText {
                headerTextView.selectedRange = NSRange(location: 0,length: 0)
            }
        } else if textView.tag == FieldType.details.rawValue {
            if textView.text == defaultDetailsText {
                detailsTextView.selectedRange = NSRange(location: 0,length: 0)
            }
        } else if textView.tag == FieldType.location.rawValue {
            if textView.text == defaultLocationText {
                //locationTextView.selectedRange = NSRange(location: 0,length: 0)
            }
        }
        // Reset Text if needed
        if headerTextView.text == "" {
            headerTextView.text = defaultHeaderText
        }
        if detailsTextView.text == "" {
            detailsTextView.text = defaultDetailsText
        }
    }
    
    func textViewDidBeginEditing(textView: UITextView) {
        
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
