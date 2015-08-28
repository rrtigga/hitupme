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
        
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/connect")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                println(error)
            } else {
                if let httpResponse = response as? NSHTTPURLResponse {
                    println(httpResponse)
                    if let sid = httpResponse.allHeaderFields["sid"] as? String {
                        var defaults = NSUserDefaults.standardUserDefaults()
                        defaults.setObject(sid, forKey: "sid")
                        completion(success: true)
                    }
                }
            }
        })
        
        dataTask.resume()
        
    }
    
    class func postUser(userId:String, first_Name:String, last_Name:String, friends:NSArray, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        var defaults = NSUserDefaults.standardUserDefaults()
        var sid = defaults.objectForKey("sid") as! String
        
        let headers = [
            "content-type": "application/json",
            "sid": sid
        ]
        let parameters = [
            "userId": userId,
            "picUrl": "",
            "firstName": first_Name,
            "lastName": last_Name,
            "friends": friends
        ]
        
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/user/addUser")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                println(error)
                completion(success: false)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                println(httpResponse)
                completion(success: true)
            }
        })
        
        dataTask.resume()
    }
    
    class func getUser(userId:String, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        var defaults = NSUserDefaults.standardUserDefaults()
        var sid = defaults.objectForKey("sid") as! String
        let headers = [
            "content-type": "application/json",
            "sid": sid
        ]
        let parameters = [
            "userId": userId,
        ]
        
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/user/getUser")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "GET"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                println(error)
                completion(success: false)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                println(httpResponse)
                completion(success: true)
            }
        })
        
        dataTask.resume()
    }
    
    class func addHitup(header:String, description:String, locationName:String, coordinates:String, timeCreated:String, userId:String, firstName:String, completion: ((success: Bool?) -> Void)) {
        // Uses Saved SID
        var defaults = NSUserDefaults.standardUserDefaults()
        var sid = defaults.objectForKey("sid") as! String
        let headers = [
            "content-type": "application/json",
            "sid": sid
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
        
        let postData = NSJSONSerialization.dataWithJSONObject(parameters, options: nil, error: nil)
        
        var request = NSMutableURLRequest(URL: NSURL(string: "http://52.26.33.46/api/hitup/addHitup")!,
            cachePolicy: .UseProtocolCachePolicy,
            timeoutInterval: 10.0)
        request.HTTPMethod = "POST"
        request.allHTTPHeaderFields = headers
        request.HTTPBody = postData
        
        let session = NSURLSession.sharedSession()
        let dataTask = session.dataTaskWithRequest(request, completionHandler: { (data, response, error) -> Void in
            if (error != nil) {
                println(error)
                completion(success: false)
            } else {
                let httpResponse = response as? NSHTTPURLResponse
                println(httpResponse)
                completion(success: true)
            }
        })
        
        dataTask.resume()
    }
    
}
