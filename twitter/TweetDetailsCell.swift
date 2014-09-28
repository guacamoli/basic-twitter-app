//
//  TweetDetailsCell.swift
//  twitter
//
//  Created by Sahil Amoli on 9/28/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class TweetDetailsCell: UITableViewCell {

    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var tweetTextLabel: UILabel!
    @IBOutlet weak var timestampLabel: UILabel!
    
    var tweet: Tweet! {
        willSet(tweetInfo) {
            userNameLabel.text = tweetInfo.name
            screennameLabel.text = "@" + tweetInfo.screenname!
            tweetTextLabel.text = tweetInfo.text
            var profileImageUrl = tweetInfo.user!.profileImageUrl
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
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
