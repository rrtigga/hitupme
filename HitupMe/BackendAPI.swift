//
//  BackendAPI.swift
//  HitupMe
//
//  Created by Arthur Shir on 8/27/15.
//  Copyright (c) 2015 HitupDev. All rights reserved.
//

import UIKit

class BackendAPI: NSObject {
    class func connect( completion: ((success: Bool?) -> Void)) {
        
        let headers = ["content-type": "application/json"]
        let parameters = ["apiKey": "U5KMDLQ9KHN4G8MO54EH9DKG896NUETMH4DYT98W3N0HAMSO4E"]
        
        let postData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/connect")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    print(httpResponse)
                    if let sid = httpResponse.allHeaderFields["sid"] as? String {
                        let defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(sid, forKey: "sid")
                        completion(success: true)
                    }
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    class func addUser(userId:String, first_Name:String, last_Name:String, friends:NSArray, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        let defaults = NSUserDefaults.standardUserDefaults()
        let sid = defaults.objectForKey("sid") as! String
        
        let headers = [
            "content-type": "application/json",
            "sid": sid
        ]
        let parameters = [
            /*
            "userId": userId,
            "picUrl": " ",
            "firstName": first_Name,
            "lastName": last_Name,
            "friends": friends
            */
            "userId": "111",
            "picUrl": "10101",
            "firstName": "Arthurtest",
            "lastName": "Shirtest",
            "friends": ["123", "153"]
        ]
        
        let postData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/user/addUser")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion(success: false)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                completion(success: true)
            }
        })
        
        dataTask.resume()
    }
    
    class func getUser(userId:String, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        let defaults = NSUserDefaults.standardUserDefaults()
        let sid = defaults.objectForKey("sid") as! String
        let headers = [
            "content-type": "application/json",
            "sid": sid
        ]
        let parameters = [
            "userId": userId,
        ]
        
        let postData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/user/getUser")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion(success: false)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                completion(success: true)
            }
        })
        
        dataTask.resume()
    }
    
    class func addHitup(header:String, description:String, locationName:String, coordinates:String, timeCreated:String, userId:String, firstName:String, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        var sid : String?
        let defaults = NSUserDefaults.standardUserDefaults()
        if let tempSid = defaults.objectForKey("sid") as? String {
            sid = tempSid
        } else {
            sid = " No SID????"
        }
        
        let headers = [
            "content-type": "application/json",
            "sid": " "
        ]
        
        let parameters = [
            "name": header,
            "description": description,
            "location": locationName,
            "coords": coordinates,
            "timeCreated": timeCreated,
            "user": [
                "userId": userId,
                "firstName": firstName
            ]
        ]
        
        let postData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/hitup/addHitup")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
                completion(success: false)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
                completion(success: true)
            }
        })
        
        dataTask.resume()
    }
    
    class func removeHitup(hitupId:String, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        let defaults = NSUserDefaults.standardUserDefaults()
        let sid = defaults.objectForKey("sid") as! String
        let headers = [
            "content-type": "application/json",
            "sid": sid
        ]
        let parameters = ["hitupId": hitupId]
        
        let postData = try? NSJSONSerialization.dataWithJSONObject(parameters, options: [])
        
        let request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/hitup/removeHitup")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                print(error)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                print(httpResponse)
            }
        })
        
        dataTask.resume()
    }
    
}
