//
//  ViewTweetViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class ViewTweetViewController: UIViewController {

    @IBOutlet weak var retweetCountLabel: UILabel!
    @IBOutlet weak var favoritesCountLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    
    var tweet: Tweet!
    
    let favoriteOnImage = UIImage(named: "favorite_on") as UIImage
    let favoriteOffImage = UIImage(named: "favorite_off") as UIImage
    let retweetOnImage = UIImage(named: "retweet_on") as UIImage
    let retweetOffImage = UIImage(named: "retweet_off") as UIImage
    var retweetId: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        populateUI()
        println(tweet.id)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onReply(sender: AnyObject) {
    }

    @IBAction func onRetweet(sender: AnyObject) {
        if tweet.isRetweeted == false {
            tweet!.retweet()
            tweet.retweetCount = tweet.retweetCount! + 1
            retweetCountLabel.text = String(tweet.retweetCount!)
            retweetButton.setImage(retweetOnImage, forState: UIControlState.Normal)
            tweet.isRetweeted = true
        } else {
            tweet!.destroyTweet()
            tweet.retweetCount = tweet.retweetCount! - 1
            retweetCountLabel.text = String(tweet.retweetCount!)
            retweetButton.setImage(retweetOffImage, forState: UIControlState.Normal)
            tweet.isRetweeted = false
        }
    }

    @IBAction func onFavorite(sender: AnyObject) {
        if tweet.isFavorited == false {
            tweet.favorite()
            tweet.favoriteCount = tweet.favoriteCount! + 1
            favoritesCountLabel.text = String(tweet.favoriteCount!)
            favoriteButton.setImage(favoriteOnImage, forState: UIControlState.Normal)
            tweet.isFavorited = true
        } else {
            tweet.unfavorite()
            tweet.favoriteCount = tweet.favoriteCount! - 1
            favoritesCountLabel.text = String(tweet.favoriteCount!)
            favoriteButton.setImage(favoriteOffImage, forState: UIControlState.Normal)
            tweet.isFavorited = false
        }
    }

    func populateUI() {
        userNameLabel.text = tweet.name!
        screennameLabel.text = "@" + tweet.screenname!
        tweetTextLabel.text = tweet.text
        retweetCountLabel.text = String(tweet.retweetCount!)
        favoritesCountLabel.text = String(tweet.favoriteCount!)
        
        if tweet.isFavorited == true {
            favoriteButton.setImage(favoriteOnImage, forState: UIControlState.Normal)
        }
        if tweet.isRetweeted == true {
            retweetButton.setImage(retweetOnImage, forState: UIControlState.Normal)
        }
        var profileImageUrl = tweet.user!.profileImageUrl
        userImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.userImageView.image = image
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.userImageView.alpha = 1.0
                }, completion: { (Bool) -> Void in
            })
            }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
        }
    }

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        var destinationViewController = segue.destinationViewController as UINavigationController
        var createTweetViewController = destinationViewController.viewControllers![0] as CreateTweetViewController
        createTweetViewController.replyToTweet = tweet as Tweet
    }

}
