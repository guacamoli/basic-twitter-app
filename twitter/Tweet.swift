//
//  Tweet.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import Foundation

class Tweet: NSObject {
    var user: User?
    var name: String?
    var screenname: String?
    var id: String?
    var text: String?
    var retweetCount: String?
    var profile_image_url: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var location: String?

    init(tweetData: NSDictionary) {
        user = User(dictionary: tweetData["user"] as NSDictionary)
        name = user!.name
        screenname = user!.screenname
        
        text = tweetData["text"] as? String
        createdAtString = tweetData["created_at"] as? String
//        profile_image_url = user!.profileImageUrl as? String
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
        
        super.init()

    }

    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(tweetData: dictionary))
        }

        return tweets
    }
}