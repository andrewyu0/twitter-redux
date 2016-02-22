//
//  ViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/16/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit
import BDBOAuth1Manager

class ViewController: UIViewController {

    
    @IBOutlet weak var navigationBar: UINavigationItem!
    
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

    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    @IBAction func onLogin(sender: AnyObject) {

        TwitterClient.sharedInstance.loginWithCompletion(){
            (user: User?, error: NSError?) in
            if user != nil {
                // perform segue
                self.performSegueWithIdentifier("loginSegue", sender: self)
            }
            else {
                // handle login error
            }
        }
        
        
    }

}

