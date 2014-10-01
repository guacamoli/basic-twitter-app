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
    var retweetedBy: String?
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
        var tweetOwner = User(dictionary: tweetData["user"] as NSDictionary)
        var tweetInfo = tweetData
        var retweetedStatus: NSDictionary! = tweetData["retweeted_status"] as? NSDictionary


        // If this is a retweet, use the original tweets data
        if retweetedStatus != nil {
            retweetedBy = tweetOwner.screenname
            tweetInfo = retweetedStatus
        }

        user = User(dictionary: tweetInfo["user"] as NSDictionary)
        name = user!.name
        screenname = user!.screenname
        isFavorited = tweetInfo["favorited"] as? Bool
        text = tweetInfo["text"] as? String
        id = tweetInfo["id"] as? Int
        isRetweeted = tweetInfo["retweeted"] as? Bool
        retweetCount = tweetInfo["retweet_count"] as? Int
        createdAtString = tweetInfo["created_at"] as? String
        favoriteCount = tweetInfo["favorite_count"] as? Int
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