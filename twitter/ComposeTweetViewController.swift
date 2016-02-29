//
//  ComposeTweetViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/21/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

@objc protocol ComposeTweetControllerDelegate {
    optional func composeTweetController(composeTweetViewController: ComposeTweetViewController, didTweet tweet: Tweet)
}

class ComposeTweetViewController: UIViewController {

    @IBOutlet weak var userAvatarImageView: UIImageView!
    @IBOutlet weak var userScreenNameLabel: UILabel!
    @IBOutlet weak var userNameLabel: UILabel!
    @IBOutlet weak var newTweetTextView: UITextView!

    var currentUser = User.currentUser!
    weak var delegate: ComposeTweetControllerDelegate?
    
    var isReplyTweet = false
    var tweetToReply: Tweet?
    var tweetCharCount: UIBarButtonItem?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let avatarUrl = NSURL(string: currentUser.profileImageUrl!)
        userNameLabel.text = currentUser.name
        userScreenNameLabel.text = "@\(currentUser.screenname!)"
        userAvatarImageView.setImageWithURL(avatarUrl!)
        userAvatarImageView.layer.cornerRadius = 5
    }
    
    @IBAction func onHome(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func onTweet(sender: AnyObject) {
        print("tweet button pressed")
    }
    
    

}
