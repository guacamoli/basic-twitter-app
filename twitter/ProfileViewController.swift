//
//  ProfileViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 10/5/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

protocol ProfileViewControllerDelegate {
    func didTapHamburger(profileViewController: ProfileViewController)
}

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, ViewTweetViewControllerDelegate, CreateTweetViewControllerDelegate {
    var delegate: ProfileViewControllerDelegate? = nil

    @IBOutlet weak var profileTableView: UITableView!
    var tweets: [Tweet] = []
    var user: User!
    var userImageView: UIImageView!
    var userImageViewBorder: UIView!

    var screenname: String!

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTableView.hidden = true
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        var color: UIColor = UIColor(red: CGFloat(91/255.0), green: CGFloat(171/255.0), blue: CGFloat(229/255.0), alpha: CGFloat(1))
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        var headerCell = profileTableView.dequeueReusableCellWithIdentifier("profileHeaderCell") as ProfileHeaderCell
        headerCell.user = user
        userImageView = headerCell.userImageView
        userImageViewBorder = headerCell.userImageViewBorder
        profileTableView.tableHeaderView = headerCell.contentView
        profileTableView.tableHeaderView?.frame.size = CGSize(width: self.view.frame.size.width, height: 257)
        profileTableView.reloadData()
        TwitterClient.sharedInstance.profileTimeLineWithParams(["screen_name": user.screenname!], completion: { (tweets, error) -> () in
            if error == nil {
                // If there was no error, save the tweets, reload table data, and hide the loading spinner
                self.tweets = tweets!
                self.profileTableView.reloadData()
                self.profileTableView.hidden = false
                self.view.layoutIfNeeded()
            }
        })
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = profileTableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.tweetInfo = tweets[indexPath.row] as Tweet
        cell.replyToButton.tag = indexPath.row
        return cell
    }
    
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 210
    }

    func scrollViewDidScroll(scrollView: UIScrollView) {
        // Rotate and scale the profile image as the user scrolls
        if scrollView.contentOffset.y <= -64 {
            var actualOffset = scrollView.contentOffset.y + 64
            var scale = 1 + (-1 * actualOffset/150)
            userImageView.transform = CGAffineTransformMakeScale(scale, scale)
            userImageViewBorder.transform = CGAffineTransformMakeScale(scale, scale)
            userImageView.transform = CGAffineTransformRotate(userImageView.transform, CGFloat(Double(-1.5 * actualOffset) * M_PI / 180))
            userImageViewBorder.transform = CGAffineTransformRotate(userImageViewBorder.transform, CGFloat(Double(-1.5 * actualOffset) * M_PI / 180))
        }
    }
    @IBAction func onHamburger(sender: UIBarButtonItem) {
        self.delegate?.didTapHamburger(self)
    }

    func didComposeNewTweet(createTweetViewController: CreateTweetViewController, tweet: Tweet) {
        tweets.insert(tweet, atIndex: 0)
        profileTableView.reloadData()
    }

    func didAddReplies(viewTweetViewController: ViewTweetViewController, newTweets: [Tweet]) {
        for tweet in newTweets {
            tweets.insert(tweet, atIndex: 0)
        }
        profileTableView.reloadData()
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        var destinationViewController = segue.destinationViewController as UINavigationController
        
        if segue.identifier == "TweetDetailsViewFromProfile" {
            var viewTweetViewController = destinationViewController.viewControllers![0] as ViewTweetViewController
            viewTweetViewController.delegate = self
            viewTweetViewController.tweet = sender.tweetInfo as Tweet
        } else if segue.identifier == "ReplyFromProfile" {
            var createTweetViewController = destinationViewController.viewControllers![0] as CreateTweetViewController
            createTweetViewController.delegate = self
            // The reply button has the tweet index "tagged" on!
            createTweetViewController.replyToTweet = tweets[sender.tag]
        }
    }
}
