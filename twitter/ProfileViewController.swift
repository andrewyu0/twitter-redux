//
//  ProfileViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/25/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var bannerImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var handleLabel: UILabel!
    
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var tweetsCount: UILabel!
    @IBOutlet weak var followingCount: UILabel!
    @IBOutlet weak var followersCount: UILabel!
    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
    var tweets: [Tweet]?
    
    var currentUser = User.currentUser!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        if let navigationBar = navigationController?.navigationBar {
            navigationBar.translucent  = false
            navigationBar.tintColor    = UIColor.whiteColor()
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
        }
    
        tableView.dataSource = self
        tableView.delegate   = self

        tweetsCount.text    = String(currentUser.tweetsCount!)
        followingCount.text = String(currentUser.followingCount!)
        followersCount.text = String(currentUser.followersCount!)
        
        nameLabel.text   = currentUser.name
        handleLabel.text = "@\(currentUser.screenname!)"
        let avatarUrl = NSURL(string: currentUser.profileImageUrl!)
        let bannerUrl = NSURL(string: currentUser.profileBannerUrl!)

        profileImageView.setImageWithURL(avatarUrl!)
        profileImageView.layer.cornerRadius = 5
        profileImageView.clipsToBounds = true
        
        bannerImageView.setImageWithURL(bannerUrl!)
        
        fetchHomeTimeline(nil)
    }

    func fetchHomeTimeline(completion:(()->())?) {
        
        TwitterClient.sharedInstance.homeTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            
            print("self.tweets")
            print(self.tweets)
            
            self.tableView.reloadData()
            if completion != nil {
                completion!()
            }
        }
    }
    
    
    // TableView Methods and Delegate
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let tweets = tweets {
            return tweets.count
        }
        return 0
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell
        cell.tweet = tweets?[indexPath.row]
        return cell
    }

    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
