//
//  FirstViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/5/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import SDWebImage

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject? = .none
    var loggedInUserDetails: AnyObject? = .none
    var posts : Array = [AnyObject?]()
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    var defaultImageViewHeightConstraint:CGFloat = 77.0
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print("COUNT: \(self.posts.count)")
        return self.posts.count
        
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeViewTableViewCell
       
        let count = self.posts.count
        let post = posts[(count-1) - indexPath.row]!.value(forKey: "text") as! String
        
        let imageTap = UITapGestureRecognizer(target: self, action: #selector(didTapMediaInPost(sender:)))
        cell.postImage.addGestureRecognizer(imageTap)
        
        let p = posts[(count-1)-indexPath.row]!.value(forKey: "picture")
        
        if(p != nil)
        {
            cell.postImage.isHidden = false
            cell.imageViewHeightConstraint.constant = defaultImageViewHeightConstraint
            
            let picture = posts[(count-1) - indexPath.row]!.value(forKey: "picture") as! String
            
            let url = NSURL(string:picture as! String)
            cell.postImage.layer.cornerRadius = 10
            cell.postImage.layer.borderWidth = 3
            cell.postImage.layer.borderColor = UIColor.white.cgColor
            
            cell.postImage.sd_setImage(with: url as! URL)
            //cell.postImage.sd_setImage(with: url, placeholderImage: UIImage(named:"wallpaper ")!)
            
        }
        else
        {
            cell.postImage.isHidden = true
            cell.imageViewHeightConstraint.constant = 0
        }

        cell.configure(profilePic: nil, name: self.loggedInUserDetails!.value(forKey: "name") as! String, handle: self.loggedInUserDetails!.value(forKey: "handle") as! String, post: post)
        
        return cell
    }

    func didTapMediaInPost(sender: UITapGestureRecognizer){
    
        let imageView = sender.view as! UIImageView
        let newImageView = UIImageView(image: imageView.image)
        
        newImageView.frame = self.view.frame
        
        newImageView.backgroundColor = UIColor.black
        newImageView.contentMode = .scaleAspectFit
        newImageView.isUserInteractionEnabled = true
        
        let tap = UITapGestureRecognizer(target:self,action:#selector(self.dismissFullScreenImage))
        
        newImageView.addGestureRecognizer(tap)
        self.view.addSubview(newImageView)
    
    }
    override func viewDidLoad() {
        super.viewDidLoad() 
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
       
        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
           
            self.loggedInUserDetails = snapshot.value as AnyObject
            
            //get all the tweets that are made by the user
             self.databaseRef.child("posts/\(self.loggedInUser!.uid!)").observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
             
             self.posts.append(snapshot.value as! NSDictionary)

             self.homeTableView.insertRows(at: [IndexPath(row:0, section: 0)] , with: UITableViewRowAnimation.automatic)
             
             self.loading.stopAnimating()
                
             }){(error) in
             
             print(error.localizedDescription)
             }
            
        }
        self.homeTableView.rowHeight = UITableViewAutomaticDimension
        self.homeTableView.estimatedRowHeight = 140

        
    }
    
    func dismissFullScreenImage(sender:UITapGestureRecognizer)
    {
        sender.view?.removeFromSuperview()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }

    
}

