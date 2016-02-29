//
//  LoginViewController.swift
//  InstagramLite
//
//  Created by Neal Patel on 2/28/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import Parse

class LoginViewController: UIViewController {

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func alertView(let titleSample : String, let messageSample : String) {
        
        let alertController = UIAlertController(title: titleSample, message: messageSample, preferredStyle: .Alert)
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .Cancel) { (action) in
            
        }
        
        alertController.addAction(cancelAction)
        
        self.presentViewController(alertController, animated: true) {
        }
    }
    
    @IBAction func signInPressed(sender: AnyObject) {
        PFUser.logInWithUsernameInBackground(usernameTextField.text!, password: passwordTextField.text!) { (user: PFUser?, error: NSError?) -> Void in
            if user != nil {
                print("You've logged in!")
                self.performSegueWithIdentifier("login", sender: nil)
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
                self.performSegueWithIdentifier("login", sender: nil)
            } else {
                print(error?.localizedDescription)
                if error?.code == 202 {
                    self.alertView("Error", messageSample: "Username already exists!")
                }
            }
        }
    }
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
