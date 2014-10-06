//
//  ProfileHeaderCell.swift
//  twitter
//
//  Created by Sahil Amoli on 10/5/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class ProfileHeaderCell: UITableViewCell {
    @IBOutlet weak var headerImageView: UIImageView!
    @IBOutlet weak var userImageView: UIImageView!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var screennameLabel: UILabel!
    @IBOutlet weak var cityLabel: UILabel!
    @IBOutlet weak var followingCountLabel: UILabel!
    @IBOutlet weak var followersCountLabel: UILabel!

    var user = User.currentUser!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        userNameLabel.text = user.name
        screennameLabel.text = user.screenname
        cityLabel.text = user.location
        followersCountLabel.text = String(user.followersCount!)
        followingCountLabel.text = String(user.followingCount!)

        var profileImageUrl = user.profileImageUrl
        var headerImageUrl = user.headerImageUrl

        userImageView.alpha = 0.0
        userImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.userImageView.image = image
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.userImageView.alpha = 1.0
                }, completion: { (Bool) -> Void in
            })
            }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
        }
        headerImageView.alpha = 0.0
        headerImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: headerImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.headerImageView.image = image
            
            UIView.animateWithDuration(0.5, animations: { () -> Void in
                self.headerImageView.alpha = 1.0
                }, completion: { (Bool) -> Void in
            })
            }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
        }
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
