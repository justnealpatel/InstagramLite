//
//  PostsTableViewCell.swift
//  InstagramLite
//
//  Created by Neal Patel on 3/5/16.
//  Copyright © 2016 Neal Patel. All rights reserved.
//

import UIKit
import Parse

var caption: String?

class PostsTableViewCell: UITableViewCell {

    @IBOutlet weak var postsImageView: UIImageView!
    @IBOutlet weak var captionLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    var picture: PFFile? {
        didSet {
            print(picture)
            picture?.getDataInBackgroundWithBlock({ (data: NSData?, error: NSError?) -> Void in
                if error == nil {
                    self.postsImageView.image = UIImage(data: data!)!
                }
                else {
                    print(error?.localizedDescription)
                }
            })
        }
    }
    var caption: String? {
        didSet {
            captionLabel.text = caption
        }
    }
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
