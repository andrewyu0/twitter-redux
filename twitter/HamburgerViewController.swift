//
//  HamburgerViewController.swift
//  twitter
//
//  Created by Andrew Yu on 2/24/16.
//  Copyright © 2016 Andrew Yu. All rights reserved.
//

import UIKit

class HamburgerViewController: UIViewController, TweetsViewControllerDelegate {

    @IBOutlet weak var menuView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var leftMarginConstraint: NSLayoutConstraint!
    
    var selectedViewController: UIViewController?
    var originalLeftMargin: CGFloat!
    var menuViewController: UIViewController! {

        // Property observer
        didSet {
            view.layoutIfNeeded()
            print("menuViewController set (HamburgerViewController)")
            menuView.addSubview(menuViewController.view)
        }
    }
    
    var contentViewController: UIViewController! {
        didSet {

            view.layoutIfNeeded()
            
            contentView.addSubview(contentViewController.view)
            
            UIView.animateWithDuration(0.3) { () -> Void in
                
                self.leftMarginConstraint.constant = 0
                self.view.layoutIfNeeded()
            }
        }
    }
    
    func selectViewController(viewController: UIViewController){
        print("selectViewController (HamburgerViewController)")
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onPanGesture(sender: UIPanGestureRecognizer) {
        print("pan gesture fired")
        let translation = sender.translationInView(view)
        let velocity = sender.velocityInView(view)
        
        // gesture statement 
        if sender.state == UIGestureRecognizerState.Began {
            print("gesture began")

            originalLeftMargin = leftMarginConstraint.constant
            
            
        } else if sender.state == UIGestureRecognizerState.Changed {
            
            leftMarginConstraint.constant = originalLeftMargin + translation.x
            print("gesture changed")
            print(leftMarginConstraint.constant)
            
        } else if sender.state == UIGestureRecognizerState.Ended {

            UIView.animateWithDuration(0.3, animations:{

                print("gesture ended")
                // Opening
                if velocity.x > 0 {
                    // snap on ending edge of festure
                    self.leftMarginConstraint.constant = self.view.frame.size.width - 50
                }else {
                    self.leftMarginConstraint.constant = 0
                }
                self.view.layoutIfNeeded()
                
            })
            
        }
    }

}
