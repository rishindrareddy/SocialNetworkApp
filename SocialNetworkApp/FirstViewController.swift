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

class FirstViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject? = .none
    var loggedInUserDetails: AnyObject? = .none
    var posts : Array = [AnyObject?]()
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
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
        
        cell.configure(profilePic: nil, post: post)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
       
        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
           
            self.loggedInUserDetails = snapshot
            
            //get all the tweets that are made by the user
             self.databaseRef.child("posts/\(self.loggedInUser!.uid!)").observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
             
             self.posts.append(snapshot.value as! NSDictionary)

             self.homeTableView.insertRows(at: [IndexPath(row:0, section: 0)] , with: UITableViewRowAnimation.automatic)
             
             self.loading.stopAnimating()
                
             }){(error) in
             
             print(error.localizedDescription)
             }
            
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
            }

    
}

