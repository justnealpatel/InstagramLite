//
//  AfterLoginViewController.swift
//  InstagramLite
//
//  Created by Neal Patel on 2/28/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import Parse
import ExpandingMenu
import SCLAlertView

var imagePost: UIImage?

class AfterLoginViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    @IBOutlet weak var postsTableView: UITableView!
    var posts: NSArray?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        let menuButtonSize: CGSize = CGSize(width: 64.0, height: 64.0)
        let menuButton = ExpandingMenuButton(frame: CGRect(origin: CGPointZero, size: menuButtonSize), centerImage: UIImage(named: "chooser-button-tab")!, centerHighlightedImage: UIImage(named: "chooser-button-tab-highlighted")!)
        menuButton.center = CGPointMake(self.view.bounds.width - 25.0, self.view.bounds.height - 529.0)
        view.addSubview(menuButton)
        
        let item3 = ExpandingMenuItem(size: menuButtonSize, title: "Camera", image: UIImage(named: "chooser-moment-icon-camera")!, highlightedImage: UIImage(named: "chooser-moment-icon-camera-highlighted")!, backgroundImage: UIImage(named: "chooser-moment-button"), backgroundHighlightedImage: UIImage(named: "chooser-moment-button-highlighted")) { () -> Void in
            self.performSegueWithIdentifier("upload", sender: self)
        }
        
        menuButton.expandingDirection = .Bottom
        menuButton.addMenuItems([item3])
        self.navigationController?.view.addSubview(menuButton)
        menuButton.willPresentMenuItems = { (menu) -> Void in
            print("MenuItems will present.")
        }
        
        menuButton.didDismissMenuItems = { (menu) -> Void in
            print("MenuItems dismissed.")
        }

        postsTableView.dataSource = self
        postsTableView.delegate = self
        print("logged in!")
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        let predicate = NSPredicate(format: "likesCount >= 0")
        let query = PFQuery(className: "Post", predicate: predicate)
        query.findObjectsInBackgroundWithBlock { (media: [PFObject]?, error: NSError?) -> Void in
            if let media = media {
                self.posts = media
                self.postsTableView.reloadData()
            } else {
                print(error?.localizedDescription)
            }
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = postsTableView.dequeueReusableCellWithIdentifier("POST", forIndexPath: indexPath) as! PostsTableViewCell
        cell.picture = posts![indexPath.row]["media"] as? PFFile
        cell.caption = posts![indexPath.row]["caption"] as? String
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let posts = posts {
            return posts.count
        }
        else {
            return 0
        }
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }

    @IBAction func logoutPressed(sender: AnyObject) {
        print("PFUSER is \(PFUser.currentUser()?.username!)")
        PFUser.logOut()
        let loginVC: UIViewController? = (self.storyboard?.instantiateViewControllerWithIdentifier("Login"))! as UIViewController
        self.presentViewController(loginVC!, animated: true, completion: nil)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}