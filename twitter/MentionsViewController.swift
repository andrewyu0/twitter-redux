//
//  MentionsViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/28/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class MentionsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var navigationBar: UINavigationItem!
    @IBOutlet weak var tableView: UITableView!
    var tweets: [Tweet]?
    
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
        tableView.delegate = self
        
        fetchMentionsTimeline(nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func fetchMentionsTimeline(completion:(()->())?) {
        
        TwitterClient.sharedInstance.mentionsTimelineWithParams(nil) { (tweets, error) -> () in
            self.tweets = tweets
            
            print("self.tweets")
            print(self.tweets)
            
            self.tableView.reloadData()
            if completion != nil {
                completion!()
            }
        }
    }
    
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
    
}
