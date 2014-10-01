//
//  TwitterFeedViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit


class TwitterFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, CreateTweetViewControllerDelegate, ViewTweetViewControllerDelegate {

    @IBOutlet weak var twitterFeedTableView: UITableView!
    
    let pullToRefresh = "Pull down to refresh"
    var refreshControl: UIRefreshControl!
    var tweets: [Tweet] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Hide table view with no content
        twitterFeedTableView.hidden = true
        // Show loading spinner
        MBProgressHUD.showHUDAddedTo(self.twitterFeedTableView, animated: true)

        // Make request to get home timeline
        requestHomeTimeline()

        // Set up table view delegates
        twitterFeedTableView.delegate = self
        twitterFeedTableView.dataSource = self
        twitterFeedTableView.rowHeight = UITableViewAutomaticDimension
        
        // Set navigation bar color
        var color: UIColor = UIColor(red: CGFloat(91/255.0), green: CGFloat(171/255.0), blue: CGFloat(229/255.0), alpha: CGFloat(1))
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
        
        // Create UI Refresh Control
        addRefreshControl()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    override func viewWillAppear(animated: Bool) {
        // Show loading spinner
        twitterFeedTableView.reloadData()
    }
    
    override func viewWillDisappear(animated: Bool) {
        twitterFeedTableView.reloadData()
    }

    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = twitterFeedTableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.tweetInfo = tweets[indexPath.row] as Tweet
        cell.contentView.layoutSubviews()
        return cell
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        twitterFeedTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    
    func didComposeNewTweet(createTweetViewController: CreateTweetViewController, tweet: Tweet) {
        tweets.insert(tweet, atIndex: 0)
        twitterFeedTableView.reloadData()
    }
    
    func didAddReplies(viewTweetViewController: ViewTweetViewController, newTweets: [Tweet]) {
        for tweet in newTweets {
            tweets.insert(tweet, atIndex: 0)
        }
        twitterFeedTableView.reloadData()
    }
    
    func addRefreshControl() {
        refreshControl = UIRefreshControl()
        // Create color attribute
        var colorAttribute =  [NSForegroundColorAttributeName: UIColor.blackColor()]
        // Set attributed text
        refreshControl.attributedTitle = NSAttributedString(string: pullToRefresh, attributes: colorAttribute)
        // Add target for refresh
        refreshControl.addTarget(self, action: "refresh:", forControlEvents: UIControlEvents.ValueChanged)
        
        // Add the refresh control to the table view
        twitterFeedTableView.insertSubview(self.refreshControl, belowSubview: twitterFeedTableView)
    }
    
    func refresh(sender: AnyObject) {
        requestHomeTimeline()
    }

    func requestHomeTimeline() {
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            if error == nil {
                // If there was no error, save the tweets, reload table data, and hide the loading spinner
                self.tweets = tweets!
                self.twitterFeedTableView.reloadData()
                // Hide loading spinner
                MBProgressHUD.hideHUDForView(self.twitterFeedTableView, animated: true)
                self.twitterFeedTableView.hidden = false
            }
            
            self.refreshControl.endRefreshing()
        })
    }

    // MARK: - Navigation

    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        var destinationViewController = segue.destinationViewController as UINavigationController

        if segue.identifier == "TweetDetailsView" {
            var viewTweetViewController = destinationViewController.viewControllers![0] as ViewTweetViewController
            viewTweetViewController.delegate = self
            viewTweetViewController.tweet = sender.tweetInfo as Tweet
        } else if segue.identifier == "ComposeTweetView" {
            var createTweetViewController = destinationViewController.viewControllers![0] as CreateTweetViewController
            createTweetViewController.delegate = self
        }
    }

}
