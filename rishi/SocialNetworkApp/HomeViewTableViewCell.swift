//
//  HomeViewTableViewCell.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/14/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit

public class HomeViewTableViewCell: UITableViewCell {

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var post: UITextView!
    @IBOutlet weak var handle: UILabel!
    
    @IBOutlet weak var imageViewHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var postImage: UIImageView!
    
    override public func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    public func configure(profilePic:String?, name:String, handle:String, post:String)
    {
        self.post.text = post
        self.handle.text = "@"+handle
        self.name.text = name
        
        
        if((profilePic) != nil)
        {
            let imageData = NSData(contentsOf: NSURL(string:profilePic!)! as URL)
            self.profilePic.image = UIImage(data:imageData! as Data)
        }
        else
        {
            self.profilePic.image = UIImage(named:"Twitter-25")
        }
        
    }
}
