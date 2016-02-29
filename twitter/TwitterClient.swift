//
//  TwitterClient.swift
//  twitter
//
//  Created by Andrew Yu on 2/16/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

let twitterConsumerKey    = "PJrXerfhL6kNJQbU9Otj4w54l"
let twitterConsumerSecret = "HL8k5sQqmaFmIEVyjcSwleEx5iqCaV7Jik46VdX3rdDBVMhb17"
let twitterBaseURL        = NSURL(string: "https://api.twitter.com")

class TwitterClient: BDBOAuth1SessionManager {

    var loginCompletion: ((user: User?, error: NSError?) -> ())?
    
    class var sharedInstance: TwitterClient {
        struct Static {
            // Configure twitter client
            static let instance = TwitterClient(baseURL: twitterBaseURL, consumerKey: twitterConsumerKey, consumerSecret: twitterConsumerSecret)
        }
        return Static.instance
    }
    
    
    func homeTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
    // GET HOME TIMELINE (ALL TWEETS)
        GET("1.1/statuses/home_timeline.json", parameters : params, success : { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
        
            print("----- We have the home timeline (TwitterClient)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error:nil)
    
        },
        failure    : { (operation: NSURLSessionDataTask?, error: NSError?) -> Void in
            print("error getting timeline")
            completion(tweets:nil, error:error)
            self.loginCompletion?(user: nil, error:error)
        })
    
    }
    
    func mentionsTimelineWithParams(params: NSDictionary?, completion: (tweets: [Tweet]?, error: NSError?) -> ()){
        // GET HOME TIMELINE (ALL TWEETS)
        GET("1.1/statuses/mentions_timeline.json", parameters : params, success : { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
            
            print("----- We have the mentions timeline (TwitterClient)")
            let tweets = Tweet.tweetsWithArray(response as! [NSDictionary])
            completion(tweets: tweets, error:nil)
            
            },
            failure    : { (operation: NSURLSessionDataTask?, error: NSError?) -> Void in
                print("error getting timeline")
                completion(tweets:nil, error:error)
                self.loginCompletion?(user: nil, error:error)
        })
        
    }

    func tweetMessageWithParams(params: NSDictionary?, completion: (tweet: Tweet?, error: NSError?) -> ()) {
        POST("1.1/statuses/update.json", parameters: params, success: { (operation: NSURLSessionDataTask!, response: AnyObject?) -> Void in
            
            let tweet = Tweet(dictionary: response as! NSDictionary)
            
            completion(tweet: tweet, error: nil)
            }) { (operation: NSURLSessionDataTask?, error:NSError!) -> Void in
                completion(tweet: nil, error: error)
        }
    }
    
    
    func openURL(url: NSURL){
        fetchAccessTokenWithPath("oauth/access_token", method: "POST", requestToken: BDBOAuth1Credential(queryString: url.query), success: { (accessToken: BDBOAuth1Credential!) -> Void in
            
            print("Got the access token! Woot")
            
            // Save access token
            TwitterClient.sharedInstance.requestSerializer.saveAccessToken(accessToken)
            
            // GET USER
            TwitterClient.sharedInstance.GET(
                "1.1/account/verify_credentials.json",
                parameters : nil,
                success    : { (operation: NSURLSessionDataTask, response: AnyObject?) -> Void in
                    
                    let user = User(dictionary: response as! NSDictionary)
                    
                    // Persist user
                    User.currentUser = user
                    
                    print("----- We have the user")
                    print("user: \(user.name)")

                    self.loginCompletion?(user:user, error:nil)
                },
                failure    : { (operation: NSURLSessionDataTask?, error: NSError?) -> Void in
                    print("error getting current user")
                    self.loginCompletion?(user: nil, error:error)
                }
            )
            
            
            }) { (error: NSError!) -> Void in
                print("Failed to receive access token")
                self.loginCompletion?(user: nil, error:error)
        }
    }
    
    func loginWithCompletion(completion: (user: User?, error: NSError?) -> ()){
        
        loginCompletion = completion
        
        // Fetch token and re-direct to authorization page
        
        TwitterClient.sharedInstance.requestSerializer.removeAccessToken()
        
        TwitterClient.sharedInstance.fetchRequestTokenWithPath(
        
            "oauth/request_token" , // request path
            method      : "GET",
            callbackURL : NSURL(string: "cptwitterdemo://oauth"),
            scope       : nil,
            success     : { (requestToken: BDBOAuth1Credential!) -> Void in
                print("Got the request token")
                print(requestToken)
                var authURL = NSURL(string: "https://api.twitter.com/oauth/authorize?oauth_token=\(requestToken.token)")
                UIApplication.sharedApplication().openURL(authURL!)
            }) { (error: NSError!) -> Void in
                print("Failed to get request token")
                self.loginCompletion?(user: nil, error:error)
        }
        
    }
    
    
    
    
}








