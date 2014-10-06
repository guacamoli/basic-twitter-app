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
            }
            if let newVC = activeViewController {
                self.addChildViewController(newVC)
                newVC.view.autoresizingMask = .FlexibleWidth | .FlexibleHeight
                newVC.view.frame = self.viewContainer.bounds
                self.viewContainer.addSubview(newVC.view)
                newVC.didMoveToParentViewController(self)
            }
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        var storyboard = UIStoryboard(name: "Main", bundle: nil)
        homeViewController = storyboard.instantiateViewControllerWithIdentifier("TwitterFeedViewController") as TwitterFeedViewController
        profileViewController = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController") as UINavigationController
        self.activeViewController = self.homeViewController
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onHamburger(sender: UIBarButtonItem) {
        if sideBarLeadingConstraint.constant != 0 {
            showSidebar()
        } else {
            hideSideBar()
        }
    }
    
    @IBAction func onProfile(sender: UIButton) {
        self.activeViewController = self.profileViewController
        hideSideBar()
    }

    @IBAction func onMentions(sender: UIButton) {
//        homeViewController.isMentions = true
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
