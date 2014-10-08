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
    @IBOutlet weak var userImageViewBorder: UIView!

    @IBOutlet weak var headerImageTopConstraint: NSLayoutConstraint!

    var user: User! {
        willSet(userInfo) {
            // Initialization code
            userNameLabel.text = userInfo.name
            screennameLabel.text = "@" + userInfo.screenname!
            cityLabel.text = userInfo.location
            followersCountLabel.text = String(userInfo.followersCount!)
            followingCountLabel.text = String(userInfo.followingCount!)
            
            var profileImageUrl = userInfo.profileImageUrl
            var headerImageUrl = userInfo.headerImageUrl
            
            userImageView.alpha = 0.0
            userImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                self.userImageView.image = image
                
                UIView.animateWithDuration(0.5, animations: { () -> Void in
                    self.userImageView.alpha = 1.0
                    }, completion: { (Bool) -> Void in
                })
                }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
            }

            if headerImageUrl != nil {
                headerImageView.alpha = 0.0
                headerImageView.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: headerImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
                    self.headerImageView.image = image
                    
                    UIView.animateWithDuration(0.5, animations: { () -> Void in
                        self.headerImageView.alpha = 1.0
                        }, completion: { (Bool) -> Void in
                    })
                    }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
                }
            } else {
                self.headerImageView.image = UIImage(named: "mobile_retina_banner_default.png")
            }
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
