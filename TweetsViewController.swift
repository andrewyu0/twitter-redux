//
//  TweetsViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/20/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

@objc protocol TweetsViewControllerDelegate {
    optional func tweetsViewControllerDelegate(tweetsViewController: TweetsViewController, didUpdateProfileUser user: User)
}

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate, TweetCellDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!

    var tweets: [Tweet]?
    var refreshControlTableView: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!

    @IBAction func signOut(sender: AnyObject) {
        print("signout invoked")
        User.currentUser?.logout()
        dismissViewControllerAnimated(true, completion: nil)        

    }
    
    var delegate: TweetsViewControllerDelegate?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set navbar styling
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.translucent  = false
            navigationBar.tintColor    = UIColor.whiteColor()
            navigationBar.titleTextAttributes = [
                NSForegroundColorAttributeName : UIColor.whiteColor()
            ]
        }
        
        tableView.dataSource = self
        tableView.delegate = self
        

        // Pull down to refresh
        refreshControlTableView = UIRefreshControl()
        refreshControlTableView.addTarget(self, action: "onRefresh", forControlEvents: UIControlEvents.ValueChanged)
        tableView.insertSubview(refreshControlTableView, atIndex: 0)
        
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
    
    func onRefresh() {
        fetchHomeTimeline() {
            self.refreshControlTableView.endRefreshing()
        }
    }
    
    // Table View Delegate and Data Source Methods

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
    }
    
    
    func tweetCellDelegate(tweetCell: TweetCell, didTapAvatar tweet: Tweet) {
        print("didTapAvatar invoked (TweetsViewController)")
        let user = tweet.user
        print("This is the user for the tweet:")
        print(user)
        delegate?.tweetsViewControllerDelegate?(self, didUpdateProfileUser: user!)
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if sender is TweetCell {
            let vc = segue.destinationViewController
            let cell = sender as! TweetCell
            let tweetViewController = vc as! TweetViewController
            tweetViewController.tweet =  cell.tweet
        }
        

    }

}
