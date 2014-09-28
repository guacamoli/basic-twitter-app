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
                completion(tweets: nil, error: error)
        })
    }

    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()) {
        loginCompletion = completion
        
        // Fetch request token & redirect to authorization page
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath("oauth/request_token", method: "GET", callbackURL: NSURL(string:"cptwitterdemo://oauth"), scope: nil, success: { (requestToken: BDBOAuthToken!) -> Void in
        var auth = NSURL(string: "https://api.twitter.com/oauth/authenticate?oauth_token=\(requestToken.token)")
        
        UIApplication.sharedApplication().openURL(auth)
        println("Got request token")
        
        }) { (error: NSError!) -> Void in
            println("Failed to get request token")
            self.loginCompletion?(user: nil, error: error)
        }
    }
    
    func openURL(url: NSURL) {
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuthToken (queryString: url.query), success: { (accessToken:BDBOAuthToken!) -> Void in

            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            TwitterClient.sharedInstance.GET("1.1/account/verify_credentials.json", parameters: nil, success: { (operation: AFHTTPRequestOperation!, response: AnyObject!) -> Void in
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
