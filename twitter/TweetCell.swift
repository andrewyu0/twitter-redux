//
//  TweetCell.swift
//  twitter
//
//  Created by Andrew Yu on 2/21/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class TweetCell: UITableViewCell {
    
    
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var authorHandleLabel: UILabel!
    @IBOutlet weak var retweetLabel: UILabel!
    @IBOutlet weak var tweetTextLabel: UILabel!
    
    @IBOutlet weak var tweetImageView: UIImageView!
    @IBOutlet weak var replyImageView: UIImageView!
    @IBOutlet weak var retweetImageView: UIImageView!
    @IBOutlet weak var favoriteImageView: UIImageView!
    
    
    var tweet: Tweet! {

        didSet {
            if let text = tweet.text {
                tweetTextLabel.text = text
            }
            if let user = tweet.user {
                let avatarUrl = NSURL(string: user.profileImageUrl!)
                authorLabel.text = user.name
                authorHandleLabel.text = "@\(user.screenname!)"
                tweetImageView.setImageWithURL(avatarUrl!)
            }
        }
    }
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
