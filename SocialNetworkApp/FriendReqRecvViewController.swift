//
//  FriendReqRecvViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase


class FriendReqRecvViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    
        var rootRef = FIRDatabase.database().reference()
    
      ///to be done
        @IBOutlet weak var homeTableView: UITableView!
        
        var userID: String = ""
        
        var email = "mypersonalbox6@gmail.com"
        
        var password = "123456"
        
        var loggedInUser = "1IGoS5fFHyV80teAvtad9Q6d4ik2"
        
        var loggedInUserDetails: AnyObject? = .none
        
    
        //handles of users
        
        var myListIds = [String]()
    
        override func didReceiveMemoryWarning() {
            
            super.didReceiveMemoryWarning()
            
        }
    
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            
            return 1
            
        }
    
        
        internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            
            return (self.myListIds.count)
            
        }
    
        
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath as IndexPath) as UITableViewCell
            
            let friendList =  self.myListIds[indexPath.row] as! String
          //  cell.configure (name: friendList)
            
            return (cell)
        }
        
        
        //When pressed accept
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
//            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath as IndexPath) as! FriendTableViewCell
//            
//            let userInfo = cell.nameLabel.text
//            
//            print (userInfo)
            
            
        }
    
        
        //Delete from table
        
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.delete
                
            {
                
                //var handle = self.myListIds[indexPath.row] as! String
                
                
                
                //
                
                //                    print(handle)
                
                //                self.myListIds.remove(at: indexPath.row)
                
                //                self.homeTableView.reloadData()
                
       
                
            }
            
        }
    
        
        override func viewDidLoad() {
            
            super.viewDidLoad()
            
            
            
            FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
                
                if(error == nil){
                    
                    print ("Successful")
                    
                    print (user)
                    
                    self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                    
                    
                    print (self.userID)
                    
                    self.rootRef.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                        
                        let value = snapshot.value as? NSDictionary
                        
                        //print (value)
                        
                        
                        
                        let fl = value?["freq_recv"] as! NSArray
                        
                        
                        
                        //print (fl)
                        
                        
                        
                        for item in fl{
                            
                            self.myListIds.append(item as! String)
                            
                            
                            
                        }
                        
                        self.homeTableView.reloadData()
                        
                        
                        
                    }) { (error) in
                        
                        print(error.localizedDescription)
                        
                    }
                    
                    
                    
                }//end FIRauth
                
                
                
                
                
            })
            
            
            
        } //end viewdidload
        
        
        
}

