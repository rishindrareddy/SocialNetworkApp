//
//  viewFriendViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/25/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth

class viewFriendViewController: UIViewController {

    
    @IBOutlet weak var messageButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var handleLabel: UILabel!
    @IBOutlet weak var nameLabel: UILabel!
    
    var dbRef : FIRDatabaseReference!
    var friendEmail : String?
    var userKey : String!
    
    var loggedInUser : FIRUser?
    var otherUser : NSDictionary?
    var loggedInUserData : NSDictionary?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.dbRef = FIRDatabase.database().reference()
        
        self.dbRef.child("user_profiles").child(self.loggedInUser!.uid).observe(.value, with: { (snapshot) in
            
            self.loggedInUserData = snapshot.value as? NSDictionary
            self.loggedInUserData?.setValue(self.loggedInUser!.uid as! String, forKey: "uid")
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
        self.dbRef.child("user_profiles").child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            let uid = self.otherUser?["uid"] as! String
            self.otherUser = snapshot.value as? NSDictionary
            self.otherUser?.setValue(uid, forKey: "uid")
            
        }, withCancel: { (error) in
            print(error.localizedDescription)
        })
        
        self.dbRef.child("following").child(self.loggedInUser!.uid).child(self.otherUser?["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists()) {
                self.followButton.setTitle("Unfollow", for: .normal)
            }
            else {
                self.followButton.setTitle("Follow", for: .normal)
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
        self.nameLabel.text = self.otherUser?["name"] as? String
        self.handleLabel.text = self.otherUser?["handle"] as? String
        
        self.dbRef.child("friends").child(self.loggedInUser!.uid).child(self.otherUser!["uid"] as! String).observe(.value, with: { (snapshot) in
            
            if (snapshot.exists()){
                self.addFriendButton.setTitle("Unfriend", for: .normal)
            }
            else {
                
                self.dbRef.child("freq_sent").child(self.loggedInUser!.uid).child(self.otherUser!["uid"] as! String).observe(.value, with: { (snapshot) in
                    
                    if (snapshot.exists()){
                        self.addFriendButton.setTitle("friend request already sent", for: .normal)
                        self.addFriendButton.isEnabled = false
                    }
                    else {
                        self.addFriendButton.setTitle("Add friend", for: .normal)
                        self.addFriendButton.isEnabled = true
                    }
                    
                }, withCancel: { (error) in
                    print(error.localizedDescription)
                })
                self.addFriendButton.setTitle("Add friend", for: .normal)
                  
                
            }
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
    }
    
    @IBAction func messageClicked(_ sender: Any) {
    }
    
    @IBAction func followClicked(_ sender: Any) {
        
        let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
        
        
        if(self.followButton.titleLabel?.text == "Follow")
        {
            print("follow user")
            
            let followersData = ["name":self.loggedInUserData?["name"] as! String,
                                 "handle":self.loggedInUserData?["handle"] as! String,
                                 "profile_pic":"\(self.loggedInUserData?["profile_pic"])"]
            
            let followingData = ["name":self.otherUser?["name"] as! String,
                                 "handle":self.otherUser?["handle"] as! String,
                                 "profile_pic":"\(self.otherUser?["profile_pic"])"]
            
            //"profile_pic":self.otherUser?["profile_pic"] != nil ? self.loggedInUserData?["profile_pic"] as! String : ""
            let childUpdates = [followersRef:followersData,
                                followingRef:followingData]
            
            
            self.dbRef.updateChildValues(childUpdates)
            
            print("data updated")
            
            
            
            
            //update following count under the logged in user
            //update followers count in the user that is being followed
            let followersCount:Int?
            let followingCount:Int?
            if(self.otherUser?["followersCount"] == nil)
            {
                //set the follower count to 1
                followersCount=1
            }
            else
            {
                followersCount = self.otherUser?["followersCount"] as! Int + 1
            }
            
            //check if logged in user  is following anyone
            //if not following anyone then set the value of followingCount to 1
            if(self.loggedInUserData?["followingCount"] == nil)
            {
                followingCount = 1
            }
                //else just add one to the current following count
            else
            {
                
                followingCount = self.loggedInUserData?["followingCount"] as! Int + 1
            }
            
            dbRef.child("user_profiles").child(self.loggedInUser!.uid).child("followingCount").setValue(followingCount!)
            dbRef.child("user_profiles").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(followersCount!)
            
            
        }
        else
        {
            dbRef.child("user_profiles").child(self.loggedInUserData?["uid"] as! String).child("followingCount").setValue(self.loggedInUserData!["followingCount"] as! Int - 1)
            dbRef.child("user_profiles").child(self.otherUser?["uid"] as! String).child("followersCount").setValue(self.otherUser!["followersCount"] as! Int - 1)
            
            let followersRef = "followers/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
            let followingRef = "following/" + (self.loggedInUserData?["uid"] as! String) + "/" + (self.otherUser?["uid"] as! String)
            
            
            let childUpdates = [followingRef:NSNull(),followersRef:NSNull()]
            dbRef.updateChildValues(childUpdates)
            
            
        }

        
    }
   
    @IBAction func addFriendClicked(_ sender: Any) {
        
        let req_snt = "freq_sent/\(self.loggedInUserData?["uid"] as! String)/\(self.otherUser?["uid"] as! String)"
        let req_rcv = "freq_rcv/\(self.otherUser?["uid"] as! String)/\(self.loggedInUserData?["uid"] as! String)"
        
        if (self.addFriendButton.titleLabel?.text == "Add friend") {
            
            let udata = ["name":self.loggedInUserData?["name"] as! String,
                         "handle":self.loggedInUserData?["handle"] as! String]
            
            let fdata = ["name":self.otherUser?["name"] as! String,
                         "handle":self.otherUser?["handle"] as! String]
            
            let childUpdates = [req_snt : fdata, req_rcv : udata]
            
            self.dbRef.updateChildValues(childUpdates)
            
        } else if (self.addFriendButton.titleLabel?.text == "Unfriend") {
            
            let friendRef = "friends/\(self.loggedInUserData?["uid"] as! String)/\(self.otherUser?["uid"] as! String)"
            
            let childUpdates = [friendRef : NSNull()]
            self.dbRef.updateChildValues(childUpdates)
        }
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
