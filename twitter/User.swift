//
//  User.swift
//  twitter
//
//  Created by Sahil Amoli on 9/27/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import Foundation

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"
let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    var name: String?
    var screenname: String?
    var profileImageUrl: String?
    var tagLine: String?
    var allData: NSDictionary
    
    init(dictionary: NSDictionary) {
        self.allData = dictionary
        name = dictionary["name"] as? String
        screenname = dictionary["screen_name"] as? String
        profileImageUrl = dictionary["profile_image_url"] as? String
        tagLine = dictionary["description"] as? String
    }
    
    func logout() {
        User.currentUser = nil
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
    }

    class var currentUser: User? {
        get {
            if _currentUser == nil {
                var data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                if data != nil {
                var dictionary = NSJSONSerialization.JSONObjectWithData(data!, options: nil, error: nil) as NSDictionary
                _currentUser = User(dictionary: dictionary)
                }
            }
            return _currentUser
        }

        set(user) {
            _currentUser = user

            if _currentUser != nil {
                var data = NSJSONSerialization.dataWithJSONObject(user!.allData, options: nil, error: nil)
                // Store
                NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                // Save
                NSUserDefaults.standardUserDefaults().synchronize()
            } else {
                // Logout?
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
                // Save
                NSUserDefaults.standardUserDefaults().synchronize()
            }
        }
    }
}