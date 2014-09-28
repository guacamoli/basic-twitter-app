//
//  TwitterFeedViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit


class TwitterFeedViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var twitterFeedTableView: UITableView!
    var tweets: [Tweet] = []
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        TwitterClient.sharedInstance.homeTimeLineWithParams(nil, completion: { (tweets, error) -> () in
            if error == nil {
                self.tweets = tweets!
                self.twitterFeedTableView.reloadData()
            }
        })
        twitterFeedTableView.delegate = self
        twitterFeedTableView.dataSource = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = twitterFeedTableView.dequeueReusableCellWithIdentifier("TweetCell") as TweetCell
        cell.tweetInfo = tweets[indexPath.row] as Tweet
        return cell
    }

    func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return tweets.count
    }

    @IBAction func onLogout(sender: AnyObject) {
        User.currentUser?.logout()
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue!, sender: AnyObject!) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
