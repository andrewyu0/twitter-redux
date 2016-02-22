//
//  Tweet.swift
//  twitter
//
//  Created by Andrew Yu on 2/18/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class Tweet: NSObject {

    var user: User?
    var text: String?
    var createdAtString: String?
    var createdAt: NSDate?
    var author: String?
    var authorHandle: String?
    
    init(dictionary: NSDictionary){
        
        
        user = User(dictionary: dictionary["user"] as! NSDictionary)
        text = dictionary["text"] as? String
        createdAtString = dictionary["created_at"] as? String
        author = dictionary["user"]!["name"] as? String
        authorHandle = dictionary["user"]!["screen_name"] as? String

        
        var formatter = NSDateFormatter()
        formatter.dateFormat = "EEE MMM d HH:mm:ss Z y"
        createdAt = formatter.dateFromString(createdAtString!)
    }
    
    class func tweetsWithArray(array: [NSDictionary]) -> [Tweet] {
        var tweets = [Tweet]()
        
        for dictionary in array {
            tweets.append(Tweet(dictionary: dictionary))
        }
        
        return tweets
    }
    
    
}
