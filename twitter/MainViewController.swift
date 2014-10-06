//
//  MainViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 10/4/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class MainViewController: UIViewController {
    
    @IBOutlet weak var viewContainer: UIView!
    @IBOutlet weak var sideBarView: UIView!
    @IBOutlet weak var sidebarProfileImage: UIImageView!
    @IBOutlet weak var sidebarUserName: UILabel!
    @IBOutlet weak var sidebarUserSceennameLabel: UILabel!
    @IBOutlet weak var sidebarHomeButton: UIButton!
    @IBOutlet weak var sidebarMentionsButton: UIButton!
    @IBOutlet weak var sidebarProfileButton: UIButton!

    @IBOutlet weak var sideBarLeadingConstraint: NSLayoutConstraint!
    @IBOutlet weak var viewContainerTrailingConstraint: NSLayoutConstraint!
    var homeViewController: UIViewController!
    var profileViewController: UIViewController!

    var activeViewController: UIViewController? {
        didSet(oldViewControllerOrNil) {
            if let oldVC = oldViewControllerOrNil {
                oldVC.willMoveToParentViewController(nil)
                oldVC.view.removeFromSuperview()
                oldVC.removeFromParentViewController()
                self.view.layoutIfNeeded()
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.viewContainer.bounds
                self.viewContainer.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
                self.view.layoutIfNeeded()
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeViewController = storyboard.instantiateViewControllerWithIdentifier("TwitterFeedNavigationViewController") as UIViewController
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UINavigationController
        self.activeViewController = self.homeViewController
        
        var profileImageUrl = User.currentUser?.profileImageUrl!
        sidebarProfileImage.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.sidebarProfileImage.image = image
            }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
        }
        
        sidebarUserName.text = User.currentUser?.name!
        sidebarUserSceennameLabel.text = User.currentUser?.screenname!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onSidebarButtonClicked(sender: UIButton) {
        if sender == sidebarProfileButton {
            if self.activeViewController != self.profileViewController {
                self.activeViewController = self.profileViewController
            }
        } else if sender == sidebarHomeButton {
            if self.activeViewController != self.homeViewController {
                self.activeViewController = self.homeViewController
            }
        }

        hideSideBar()
    }
    
    @IBAction func onSwipe(sender: UISwipeGestureRecognizer) {
        if sideBarLeadingConstraint.constant != 0 {
            showSidebar()
        } else {
            hideSideBar()
        }
    }

    func hideSideBar() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.sideBarLeadingConstraint.constant = -200
            self.viewContainerTrailingConstraint.constant += 200
            self.view.layoutIfNeeded()
        })
    }
    
    func showSidebar() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.sideBarLeadingConstraint.constant = 0
            self.viewContainerTrailingConstraint.constant -= 200
            self.view.layoutIfNeeded()
        })
    }
}
