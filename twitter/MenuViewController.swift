//
//  MenuViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/25/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class MenuViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var userDescription: UILabel!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var userHandle: UILabel!
    
    private var blueNavigationController     : UIViewController!
    private var redNavigationController      : UIViewController!
    private var timelineNavigationController : UIViewController!
    private var profileNavigationController  : UIViewController!
    private var mentionsNavigationController : UIViewController!
    
    var viewControllers: [UIViewController] = []
    
    var hamburgerViewController: HamburgerViewController!
    
    override func viewDidLoad() {

        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate   = self
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        
        // Profile Summary View
        if let user = User.currentUser {
            let avatarUrl = NSURL(string: user.profileImageUrl!)
            profileImageView.setImageWithURL(avatarUrl!)
            profileImageView.layer.cornerRadius = 5
            profileImageView.clipsToBounds = true
            
            userDescription.text = User.currentUser!.userDescription
        }
        
        // Instantiate the view controllers to other views
        blueNavigationController     = storyboard.instantiateViewControllerWithIdentifier("BlueNavigationController")
        timelineNavigationController = storyboard.instantiateViewControllerWithIdentifier("TimelineNavigationController")
        profileNavigationController  = storyboard.instantiateViewControllerWithIdentifier("ProfileNavigationController")
        mentionsNavigationController = storyboard.instantiateViewControllerWithIdentifier("MentionsNavigationController")
        // Add to array of nav controllers

        viewControllers.append(timelineNavigationController)
        viewControllers.append(profileNavigationController)
        viewControllers.append(mentionsNavigationController)
        
        // Set the initial view controller
        hamburgerViewController.contentViewController = blueNavigationController

        
        let tapAvatarRecognizer = UITapGestureRecognizer(target: self, action: "onAvatarTap:")
        profileImageView.userInteractionEnabled = true
        profileImageView.addGestureRecognizer(tapAvatarRecognizer)
        
        
    }
    
    func onAvatarTap(tapGestureRecognizer: UITapGestureRecognizer) {
        print("avatar image tapped(MenuViewController)")
        hamburgerViewController.contentViewController = profileNavigationController
    }
    
    // Table methods and delegates
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return 3
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MenuCell", forIndexPath: indexPath) as! MenuCell
        let titles = ["Timeline", "Profile", "Mentions"]
        cell.menuTitleLabel.text = titles[indexPath.row]
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        hamburgerViewController.contentViewController = viewControllers[indexPath.row]
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
