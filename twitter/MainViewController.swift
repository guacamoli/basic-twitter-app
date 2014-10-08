//
//  MainViewController.swift
//  twitter
//
//  Created by Sahil Amoli on 10/4/14.
//  Copyright (c) 2014 Sahil Amoli. All rights reserved.
//

import UIKit

class MainViewController: UIViewController, TwitterFeedViewControllerDelegate, ProfileViewControllerDelegate {
    
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
    var homeNavigationViewController: UIViewController!
    var profileViewNavigationController: UIViewController!
    var mentionsNavigationViewController: UIViewController!

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
        
        // Create all view controllers
        homeNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("TwitterFeedNavigationViewController") as UIViewController
        profileViewNavigationController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UIViewController
        mentionsNavigationViewController = storyboard.instantiateViewControllerWithIdentifier("TwitterFeedNavigationViewController") as UIViewController

        var homeViewController = homeNavigationViewController.childViewControllers[0] as TwitterFeedViewController
        homeViewController.delegate = self

        var profileViewController = profileViewNavigationController.childViewControllers[0] as ProfileViewController
        profileViewController.delegate = self

        // Let the home view controller know that we want to see the mentions view
        var mentionsViewController = mentionsNavigationViewController.childViewControllers[0] as TwitterFeedViewController
        mentionsViewController.isMentionsView = true
        mentionsViewController.delegate = self
        
        // Set default home view controller
        self.activeViewController = self.homeNavigationViewController
        
        var profileImageUrl = User.currentUser?.profileImageUrl!
        sidebarProfileImage.setImageWithURLRequest(NSURLRequest(URL: NSURL(string: profileImageUrl!)), placeholderImage: nil, success: { (request: NSURLRequest!, response: NSHTTPURLResponse!, image: UIImage!) -> Void in
            self.sidebarProfileImage.image = image
            }) { (request: NSURLRequest!, response: NSHTTPURLResponse!, error: NSError!) -> Void in
        }
        
        sidebarUserName.text = User.currentUser?.name!
        sidebarUserSceennameLabel.text = "@" + User.currentUser!.screenname!
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func didRequestUserProfileView(twitterFeedViewController: TwitterFeedViewController, user: User) {
        var profileViewController = profileViewNavigationController.childViewControllers[0] as ProfileViewController
        profileViewController.user = user
        self.activeViewController = self.profileViewNavigationController
    }

    @IBAction func onSidebarButtonClicked(sender: UIButton) {
        if sender == sidebarProfileButton {
            var profileViewController = profileViewNavigationController.childViewControllers[0] as ProfileViewController
            var user = User.currentUser!
            if self.activeViewController != self.profileViewNavigationController || profileViewController.user != user {
                profileViewController.user = user
                self.activeViewController = self.profileViewNavigationController
            }
        } else if sender == sidebarHomeButton {
            if self.activeViewController != self.homeNavigationViewController {
                self.activeViewController = self.homeNavigationViewController
            }
        } else if sender == sidebarMentionsButton {
            if self.activeViewController != self.mentionsNavigationViewController {
                self.activeViewController = self.mentionsNavigationViewController
            }
        }

        hideSideBar()
    }

    func didTapHamburger(profileViewController: ProfileViewController) {
        println("wa")
        if self.sideBarLeadingConstraint.constant == 0 {
            hideSideBar()
        } else {
            showSidebar()
        }
    }

    @IBAction func onPanGesture(panGestureRecognizer: UIPanGestureRecognizer) {
        var velocity = panGestureRecognizer.velocityInView(self.sideBarView)
        var translation = panGestureRecognizer.translationInView(self.sideBarView)
        var currentCenterX = panGestureRecognizer.view!.center.x
        let endPositionX = currentCenterX + translation.x

        panGestureRecognizer.view!.center = CGPoint(
            x: endPositionX,
            y: panGestureRecognizer.view!.center.y
        )
        panGestureRecognizer.setTranslation(CGPointZero, inView: self.view)
        
        if panGestureRecognizer.state == UIGestureRecognizerState.Ended {
            if velocity.x > 0 {
                // going right
                showSidebar()
            } else {
                // going left
                hideSideBar()
            }
        }
    }

    func hideSideBar() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.sideBarLeadingConstraint.constant = -200
            self.viewContainerTrailingConstraint.constant = 0
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.layoutIfNeeded()
        })
    }
    
    func showSidebar() {
        UIView.animateWithDuration(0.35, animations: { () -> Void in
            self.sideBarLeadingConstraint.constant = 0
            self.viewContainerTrailingConstraint.constant = -200
            self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
            self.view.layoutIfNeeded()
        })
    }
}
