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
    var id: Int?
    var text: String?
    var retweetCount: Int?
    var favoriteCount: Int?
    var isRetweeted: Bool?
    var isFavorited: Bool?
    var createdAtString: String?
    var createdAt: NSDate?
    var location: String?
    var timeIntervalAsStr: String {
        get {
            let now = NSDate()
            let t = now.timeIntervalSinceDate(self.createdAt!)
            let d: Int = Int(t)/86400
            
            if d > 0 {
                return "\(d)d"
            } else {
                let h: Int = Int(t)/3600
                if h>0 {
                    return "\(h)h"
                } else {
                    let m: Int = Int(t)/60
                    return "\(m)m"
                }
            }
        }
    }

    init(tweetData: NSDictionary) {
        user = User(dictionary: tweetData["user"] as NSDictionary)
        name = user!.name
        screenname = user!.screenname
        isFavorited = tweetData["favorited"] as? Bool
        text = tweetData["text"] as? String
        id = tweetData["id"] as? Int
        isRetweeted = tweetData["retweeted"] as? Bool
        if isRetweeted == true {
            println(tweetData)
        }
        println(tweetData["retweeted"])
        retweetCount = tweetData["retweet_count"] as? Int
        createdAtString = tweetData["created_at"] as? String
        favoriteCount = tweetData["favorite_count"] as? Int
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
    
    
    func retweet() {
        TwitterClient.sharedInstance.retweetWithCompletion(id!, completion: { (response, error) -> () in
        })
    }

    func destroyTweet() {
        TwitterClient.sharedInstance.destroyTweetWithCompletion(id!, completion: { (response, error) -> () in
        })
    }

    func favorite() {
        TwitterClient.sharedInstance.favoriteWithCompletion(id!, completion: { (response, error) -> () in
            println("favorited")
        })
    }
    
    func unfavorite() {
        TwitterClient.sharedInstance.unfavoriteWithCompletion(id!, completion: { (response, error) -> () in
            println("unfavorited")
        })
    }
}