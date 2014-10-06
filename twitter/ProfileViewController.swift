//
//  ProfileViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 10/5/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    @IBOutlet weak var profileTableView: UITableView!
    var tweets: [Tweet] = []
    var user: User!
    var screenname: String! {
        willSet(newScreenname) {
            TwitterClient.sharedInstance.profileTimeLineWithParams(["screen_name": newScreenname], completion: { (tweets, error) -> () in
                if error == nil {
                    // If there was no error, save the tweets, reload table data, and hide the loading spinner
                    self.tweets = tweets!
                    self.profileTableView.reloadData()
                    self.profileTableView.hidden = false
                    self.view.layoutIfNeeded()
                }
            })
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.profileTableView.hidden = true
        self.profileTableView.delegate = self
        self.profileTableView.dataSource = self
        self.profileTableView.rowHeight = UITableViewAutomaticDimension
        var headerCell = profileTableView.dequeueReusableCellWithIdentifier("profileHeaderCell") as ProfileHeaderCell
        profileTableView.tableHeaderView = headerCell.contentView
        
        profileTableView.tableHeaderView?.frame.size = CGSize(width: self.view.frame.size.width, height: 257)
        var color: UIColor = UIColor(red: CGFloat(91/255.0), green: CGFloat(171/255.0), blue: CGFloat(229/255.0), alpha: CGFloat(1))
        navigationController?.navigationBar.barTintColor = color
        navigationController?.navigationBar.tintColor = UIColor.whiteColor()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(animated: Bool) {
        profileTableView.reloadData()
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

    func tableView(tableView: UITableView, estimatedHeightForHeaderInSection section: Int) -> CGFloat {
        if section == 0 {
            return 200
        }
        return 0
    }
    func tableView(tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 0
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
