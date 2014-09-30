//
//  TwitterClient.swift
//  twitter
//
//  Created by Sahil Amoli on 9/27/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

let twitterConsumerKey = "15UdqG823bzb5hx8ZZIJcMSiS"
let twitterConsumerSecret = "JLcgyepGjRJA84APOl5bIIvqqewIaIkxlMZThPScaq6DwnauyU"
let twitterBaseURL = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1RequestOperationManager {
    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    class var sharedInstance: TwitterClient {
        struct Static {
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    func homeTimeLineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()) {
        GET("1.1/statuses/home_timeline.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweets = Tweet.tweetsWithArray(response as [NSDictionary])
            completion(tweets: tweets, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting home timeline")
                println(error)
                completion(tweets: nil, error: error)
        })
    }

    func composeTweet(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var tweet = Tweet(tweetData: response as NSDictionary)
            completion(tweet: tweet, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error posting status")
                completion(tweet: nil, error: error)
        })
    }

    func retweetWithCompletion(tweetId: Int, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var retweetId = String(tweetId)
        var params = NSDictionary()
        println("RETWEETING: \(retweetId)")
        POST("1.1/statuses/retweet/" + retweetId + ".json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            var newTweet = Tweet(tweetData: response as NSDictionary)
            println("newTweet: \(newTweet.id!)")
            completion(response: response as? NSDictionary, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error retweeting")
                completion(response: nil, error: error)
        })
    }
    
    func favoriteWithCompletion(tweetId: Int, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var params = ["id": String(tweetId)]
        POST("1.1/favorites/create.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response as? NSDictionary, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error favoriting")
                completion(response: nil, error: error)
        })
    }

    func unfavoriteWithCompletion(tweetId: Int, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var params = ["id": String(tweetId)]
        POST("1.1/favorites/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response as? NSDictionary, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error removing favorite")
                completion(response: nil, error: error)
        })
    }
    func destroyTweetWithCompletion(tweetId: Int, completion: (response: NSDictionary?, error: NSError?) -> ()) {
        var params = ["id": String(tweetId)]
        POST("1.1/statuses/destroy.json", parameters: params, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
            completion(response: response as? NSDictionary, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error removing favorite")
                completion(response: nil, error: error)
        })
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        requestSerializer.removeAccessToken()
        
        fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
        var authURL = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(requestToken.token)")
        
        UIApplication.sharedApplication().openURL(authURL)
        
        }) { (error: NSError!) -> Void in
            println("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }

    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken (queryString: url.query), success: { (accessToken:BDBOAuthToken!) -> Void in

            self.requestSerializer.saveAccessToken(accessToken)
            self.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
                var user = User(dictionary: response as NSDictionary)
                User.currentUser = user
                self.loginCompletion?(user: user, error: nil)
            }, failure: { (operation: AFHTTPRequestOperation!, error: NSError!) -> Void in
                println("Error getting current user")
                self.loginCompletion?(user: nil, error: error)
            })
            }) { (error: NSError!) -> Void in
                println("Failed to get access token")
                self.loginCompletion?(user: nil, error: error)
        }

    }
}
