//
//  TweetsViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/20/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class TweetsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!

    var tweets: [Tweet]?
    var refreshControlTableView: UIRefreshControl!

    @IBOutlet weak var tableView: UITableView!
//    @IBOutlet weak var navigationBar: UINavigationBar!
    
    @IBAction func signOut(sender: AnyObject) {
        User.currentUser?.logout()
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // set navbar styling
        if let navigationBar = navigationController?.navigationBar {
            navigationBar.translucent  = false
//            navigationBar.barTintColor = UIColor.redColor()
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
        var currentTweet = tweets?[indexPath.row]
        cell.tweet = tweets?[indexPath.row]
        print("currentTweet")
        print(currentTweet)

        
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
