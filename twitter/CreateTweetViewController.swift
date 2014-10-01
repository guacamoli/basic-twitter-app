//
//  CreateTweetViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

protocol CreateTweetViewControllerDelegate {
    func didComposeNewTweet(createTweetViewController: CreateTweetViewController, tweet: Tweet)
}

class CreateTweetViewController: UIViewController, UITextViewDelegate {
    var delegate: CreateTweetViewControllerDelegate? = nil
    @IBOutlet weak var tweetButton: UIBarButtonItem!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    
    @IBOutlet weak var tweetTextView: UITextView!
    var replyToTweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetTextView.delegate = self

        userNameLabel.text = User.currentUser!.name
        screennameLabel.text = "@" + User.currentUser!.screenname!
        userImageView.layer.cornerRadius = 5.0
        var profileImageUrl = User.currentUser!.profileImageUrl
        userImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.userImageView.image = image
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.userImageView.alpha = 1.0
                }, completion: { (Bool) -> Void in
            })
            }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
        }

        // Unless this is a reply, disable the tweet button by default
        if replyToTweet != nil {
            // Prefill the reply to screename
            tweetTextView.text = "@" + replyToTweet.screenname! + " "
        } else {
            tweetButton.enabled = false
        }

        navigationController?.navigationBar.tintColor = UIColor(red: CGFloat(0), green: CGFloat(132/255.0), blue: CGFloat(180/255.0), alpha: CGFloat(1))

        updateTweetCount()
        // Auto-focus the view so the keyboard comes up!
        tweetTextView.becomeFirstResponder()
    }

    func textViewDidChange(textView: UITextView) {
        updateTweetCount()
        if isValidTweet(textView.text) {
            tweetButton.enabled = true
        } else {
            tweetButton.enabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPostTweet(sender: AnyObject) {
        var tweetText = tweetTextView.text
        var params = ["status": tweetText]

        if replyToTweet != nil {
            params["in_reply_to_status_id"] = String(replyToTweet.id!)
        }
        if isValidTweet(tweetText) {
            TwitterClient.sharedInstance.composeTweet(params, completion: { (tweet, error) -> () in
                if error == nil {
                    self.delegate?.didComposeNewTweet(self, tweet: tweet!)
                    self.dismissViewControllerAnimated(true, completion: { () -> Void in })
                } else {
                    println(error)
                }
            })
        }
    }

    @IBAction func onCancelButton(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: { () -> Void in })
    }

    func isValidTweet(tweetText: String) -> Bool {
        var charCount = countElements(tweetText)
        if charCount > 0 && charCount <= 140 {
            return true
        }
        return false
    }

    func updateTweetCount() {
        var tweetCount = 140 - countElements(tweetTextView.text)
        if tweetCount < 0 {
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 212/255.0, green: 13/255.0, blue: 18/255.0, alpha: 0.5)]
        } else if tweetCount < 20 {
          navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 92/255.0, green: 0, blue: 2/255.0, alpha: 0.5)]
        } else {
            navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor(red: 136/255.0, green: 153/255.0, blue: 166/255.0, alpha: 0.5)]
        }

        navigationItem.title = String(tweetCount) + " characters left"
    }
}
