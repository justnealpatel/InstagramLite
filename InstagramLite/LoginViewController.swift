//
//  LoginViewController.swift
//  InstagramLite
//
//  Created by Neal Patel on 2/28/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import Parse
import TKSubmitTransition
import SCLAlertView

var currentUser: PFUser?
var btn: TKTransitionSubmitButton!

class LoginViewController: UIViewController, UIViewControllerTransitioningDelegate {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var signInButton: TKTransitionSubmitButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        UIApplication.sharedApplication().setStatusBarStyle(.LightContent, animated: false)
        btn = TKTransitionSubmitButton(frame: CGRect(x: 0, y: 0, width: self.view.frame.size.width - 174, height: 44)) // make btn of type transitionbutton
        btn.center = self.view.center
        btn.frame.origin.x = self.view.frame.width / 2
        btn.setTitle("Sign in", forState: .Normal)
        btn.titleLabel?.font = UIFont(name: "HelveticaNeue-Light", size: 14)
        btn.frame.origin.x = 90
        btn.frame.origin.y = 400
        btn.addTarget(self, action: "signInPressed:", forControlEvents: UIControlEvents.TouchUpInside) // adds action programmatically
        self.view.addSubview(btn) // adds button to view
    }

    override func viewDidAppear(animated: Bool) {
        print("PFUSER123 is \(PFUser.currentUser()?.username)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func signInPressed(button: TKTransitionSubmitButton) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("You've logged in!")
                currentUser = user!
                btn.animate(2, completion: { () -> () in // animation to second view controller
                    let secondVC = AfterLoginViewController()
                    secondVC.transitioningDelegate = self
                    self.performSegueWithIdentifier("login", sender: nil)
                })
            } else {
                SCLAlertView().showError("Hold On", subTitle: "Wrong username or password")
            }
        }
    }
    
    @IBAction func signUpPressed(sender: AnyObject) {
        let newUser = PFUser()
        newUser.username = usernameTextField.text
        newUser.password = passwordTextField.text
        newUser.signUpInBackgroundWithBlock { (success: Bool, error: NSError?) -> Void in
            if success {
                print("You're an official user")
                btn.animate(2, completion: { () -> () in // animation to second view controller
                    let secondVC = AfterLoginViewController()
                    secondVC.transitioningDelegate = self
                    self.performSegueWithIdentifier("login", sender: nil)
                })
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    SCLAlertView().showWarning("Warning", subTitle: "This user already exists")
                }
            }
        }
    }
    
    // MARK: UIViewControllerTransitioningDelegate
    func animationControllerForPresentedController(presented: UIViewController, presentingController presenting: UIViewController, sourceController source: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        btn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return TKFadeInAnimator(transitionDuration: 0.5, startingAlpha: 0.8)
    }
    
    func animationControllerForDismissedController(dismissed: UIViewController) -> UIViewControllerAnimatedTransitioning? {
        btn.backgroundColor = UIColor(red: 0, green: 0, blue: 0, alpha: 0)
        return nil
    }
}