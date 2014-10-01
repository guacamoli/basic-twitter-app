//
//  TweetCell.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {

    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    @IBOutlet weak var retweetButton: UIButton!
    @IBOutlet weak var favoriteButton: UIButton!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var favoriteLabel: UILabel!
    @IBOutlet weak var retweetedByLabel: UILabel!
    @IBOutlet weak var retweetedByImageView: UIImageView!

    @IBOutlet weak var retweetedByTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByLabelHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var retweetedByImageHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var userImageTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userNameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var userScreennameTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var timestampTopConstraint: NSLayoutConstraint!
    
    let favoriteOnImage = UIImage(named: "favorite_on_small") as UIImage
    let favoriteOffImage = UIImage(named: "favorite_off_small") as UIImage
    let retweetOnImage = UIImage(named: "retweet_on_small") as UIImage
    let retweetOffImage = UIImage(named: "retweet_off_small") as UIImage
    
    var tweetInfo: Tweet! {
        willSet(info) {
            if info.retweetedBy == nil {
                setDefaultConstraints()
            } else {
                setRetweetConstraints()
                retweetedByLabel.text = info.retweetedBy!
            }

            tweetTextLabel.text = info.text
            userNameLabel.text = info.name
            screennameLabel.text = "@" + info.screenname!
            timestampLabel.text = info.timeIntervalAsStr
            retweetLabel.text = String(info.retweetCount!)
            favoriteLabel.text = String(info.favoriteCount!)
            if info.isFavorited == true {
                favoriteButton.setImage(favoriteOnImage, forState: UIControlState.Normal)
            } else {
                favoriteButton.setImage(favoriteOffImage, forState: UIControlState.Normal)
            }
            if info.isRetweeted == true {
                retweetButton.setImage(retweetOnImage, forState: UIControlState.Normal)
            } else {
                retweetButton.setImage(retweetOffImage, forState: UIControlState.Normal)
            }
            var profileImageUrl = info.user!.profileImageUrl
            userImageView.alpha = 0.0
            userImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                self.userImageView.image = image
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.userImageView.alpha = 1.0
                    }, completion: { (Bool) -> Void in
                })
                }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            }

        }
    }
    
    @IBAction func onReply(sender: AnyObject) {
//        sender.performSegueWithIdentifier("sahil", sender: self)
    }
    
    func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        var destinationViewController = segue.destinationViewController as UINavigationController
        if segue.identifier == "sahil" {
            var viewTweetViewController = destinationViewController.viewControllers![0] as CreateTweetViewController
        }
    }

    @IBAction func onRetweet(sender: AnyObject) {
        if tweetInfo.isRetweeted == false {
            tweetInfo!.retweet()
            tweetInfo.retweetCount = tweetInfo.retweetCount! + 1
            retweetLabel.text = String(tweetInfo.retweetCount!)
            retweetButton.setImage(retweetOnImage, forState: UIControlState.Normal)
            tweetInfo.isRetweeted = true
        } else {
            tweetInfo!.destroyTweet()
            tweetInfo.retweetCount = tweetInfo.retweetCount! - 1
            retweetLabel.text = String(tweetInfo.retweetCount!)
            retweetButton.setImage(retweetOffImage, forState: UIControlState.Normal)
            tweetInfo.isRetweeted = false
        }
    }
    
    @IBAction func onFavorite(sender: AnyObject) {
        if tweetInfo.isFavorited == false {
            tweetInfo.favorite()
            tweetInfo.favoriteCount = tweetInfo.favoriteCount! + 1
            favoriteLabel.text = String(tweetInfo.favoriteCount!)
            favoriteButton.setImage(favoriteOnImage, forState: UIControlState.Normal)
            tweetInfo.isFavorited = true
        } else {
            tweetInfo.unfavorite()
            tweetInfo.favoriteCount = tweetInfo.favoriteCount! - 1
            favoriteLabel.text = String(tweetInfo.favoriteCount!)
            favoriteButton.setImage(favoriteOffImage, forState: UIControlState.Normal)
            tweetInfo.isFavorited = false
        }
    }
    
    func setDefaultConstraints() {
        retweetedByTopConstraint.constant = 0
        retweetedByImageTopConstraint.constant = 0
        retweetedByLabelHeightConstraint.constant = 0
        retweetedByImageHeightConstraint.constant = 0
        userImageTopConstraint.constant = 10
        userNameTopConstraint.constant = 10
        userScreennameTopConstraint.constant = 11
        timestampTopConstraint.constant = 10
        
        retweetedByLabel.hidden = true
        retweetedByImageView.hidden = true
    }

    func setRetweetConstraints() {
        retweetedByTopConstraint.constant = 5
        retweetedByImageTopConstraint.constant = 5
        retweetedByLabelHeightConstraint.constant = 15
        retweetedByImageHeightConstraint.constant = 16
        userImageTopConstraint.constant = 25
        userNameTopConstraint.constant = 25
        userScreennameTopConstraint.constant = 26
        timestampTopConstraint.constant = 25
        
        retweetedByLabel.hidden = false
        retweetedByImageView.hidden = false
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userImageView.layer.cornerRadius = 5.0
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
