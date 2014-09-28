//
//  ViewTweetViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 9/25/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class ViewTweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var tweetDetailsTableView: UITableView!
    var tweet: Tweet!

    override func viewDidLoad() {
        super.viewDidLoad()
        tweetDetailsTableView.delegate = self
        tweetDetailsTableView.dataSource = self
        // Do any additional setup after loading the view.
        tweetDetailsTableView.reloadData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell: TweetDetailsCell!
        if indexPath.row == 0 {
            cell = tweetDetailsTableView.dequeueReusableCellWithIdentifier("TweetDetailsCell") as TweetDetailsCell!
            println(self.tweet)
            cell.tweet = self.tweet
        }
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        println("Shil")

        return 1
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
