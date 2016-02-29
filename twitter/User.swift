//
//  User.swift
//  twitter
//
//  Created by Andrew Yu on 2/18/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

var _currentUser: User?
let currentUserKey = "kCurrentUserKey"

let userDidLoginNotification = "userDidLoginNotification"
let userDidLogoutNotification = "userDidLogoutNotification"

class User: NSObject {
    
    var name            : String?
    var screenname      : String?
    var tagline         : String?
    var profileImageUrl : String?
    var profileBannerUrl: String?
    var userDescription : String?
    var followersCount  : NSNumber?
    var followingCount  : NSNumber?
    var tweetsCount     : NSNumber?
    
    var dictionary : NSDictionary
    
    init(dictionary: NSDictionary){
        self.dictionary = dictionary
        
        name            = dictionary["name"] as! String?
        tagline         = dictionary["description"] as! String?
        screenname      = dictionary["screen_name"] as! String?
        profileImageUrl = dictionary["profile_image_url"] as! String?
        profileBannerUrl = dictionary["profile_banner_url"] as! String?
        userDescription = dictionary["description"] as! String?

        followersCount = dictionary["followers_count"] as! NSNumber?
        followingCount = dictionary["friends_count"] as! NSNumber?
        tweetsCount    = dictionary["statuses_count"] as! NSNumber?

    }

    // Logout function
    func logout(){
        
        User.currentUser = nil
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        NSNotificationCenter.defaultCenter().postNotificationName(userDidLogoutNotification, object: nil)
        
    }
    
    // Set user and persist
    // Store and restore currentUser
    class var currentUser: User? {

        get {
            if _currentUser == nil {
                let data = NSUserDefaults.standardUserDefaults().objectForKey(currentUserKey) as? NSData
        
                if data != nil {
                    do {
                        let dictionary = try NSJSONSerialization.JSONObjectWithData(data!, options: []) as! NSDictionary
                        _currentUser = User(dictionary:dictionary)
                    }
                    catch {
                    // report error
                    }
                }
            }
            else {
            // do something with error
            }
            return _currentUser
        }
        
        set(user) {
            _currentUser = user
            // If user exists, store it
            if _currentUser != nil {
                do {
                    let data = try NSJSONSerialization.dataWithJSONObject(user!.dictionary, options: [])
                    NSUserDefaults.standardUserDefaults().setObject(data, forKey: currentUserKey)
                }
                catch {
                    // report error
                }
            }
            else {
                NSUserDefaults.standardUserDefaults().setObject(nil, forKey: currentUserKey)
            }
            NSUserDefaults.standardUserDefaults().synchronize()
        }
    }
    
}
