//
//  TweetViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/21/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class TweetViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var tweet: Tweet?
    
    @IBOutlet weak var tableView: UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = 180

    }

    
    @IBAction func onBack(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {

        let cell = tableView.dequeueReusableCellWithIdentifier("TweetCell", forIndexPath: indexPath) as! TweetCell

        cell.tweet = tweet
        return cell
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
