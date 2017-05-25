//
//  viewFriendViewController.swift
//  SocialNetworkApp
//
//  Created by Student on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class viewFriendViewController: UIViewController {

    @IBOutlet weak var proPic: UIImageView!
    @IBOutlet weak var userName: UILabel!
    @IBOutlet weak var msgButton: UIButton!
    @IBOutlet weak var followButton: UIButton!
    @IBOutlet weak var addFriendButton: UIButton!
    @IBOutlet weak var userHandle: UILabel!
    
   // var viewerKey = ""
    var friendKey = ""
    
    
    let ref = Database.database().reference().child("user_profiles")
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if  friendKey != nil {
            
            //to confirm if this guy is already friend
            var conf1 = self.ref.child("/\(friendKey)!/friends_list").value(forKey: (Auth.auth().currentUser?.uid)!)
            
            //to confirm if this guy is all ready in the follower list
            var conf2 = self.ref.child("/\(Auth.auth().currentUser?.uid)!/following_list").value(forKey: friendKey)
            
            print("conf1 \n")
            print (conf1 as! Bool)
            print("conf2 \n")
            print (conf2 as! Bool)
            
            if conf1 as! Bool == true {
                self.addFriendButton.isEnabled = false
            }
            if conf2 as! Bool == true {
                self.followButton.isEnabled = false
            }
            
            prefill()
        }
        // Do any additional setup after loading the view.
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func prefill () {
        
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
