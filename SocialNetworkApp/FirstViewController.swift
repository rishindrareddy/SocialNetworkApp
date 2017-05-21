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
    var posts = [AnyObject?]()
    
    @IBOutlet weak var homeTableView: UITableView!
    @IBOutlet weak var loading: UIActivityIndicatorView!
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.posts.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell: HomeViewTableViewCell = tableView.dequeueReusableCell(withIdentifier: "HomeTableViewCell", for: indexPath) as! HomeViewTableViewCell
        
//        let index: Int = self.posts.count-1 - indexPath.row
//        let post = posts[index]?.value["text"] as! String
        //for reverse order - newest on top
      //  let post = posts[((self.posts.count)-1) - indexPath.row]!.value["text"] as! String
        let post = posts[indexPath]
        
        cell.configure(nil,name:self.loggedInUserDetails!.value["name"] as! String,handle:self.loggedInUserDetails!.value["handle"] as? String,post:post)
        
        return cell
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
       
        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid).observeSingleEvent(of: .value) { (snapshot:FIRDataSnapshot) in
           
            self.loggedInUserDetails = snapshot
           // print(self.loggedInUserDetails)
            
            //get all the tweets that are made by the user
            
            self.databaseRef.child("posts/\(self.loggedInUser!.uid)").observe(.childAdded, with: { (snapshot:FIRDataSnapshot) in
               
                self.posts.append(snapshot)
                
                self.homeTableView.insertRows(at: [IndexPath(row:0, section: 0)] , with: UITableViewRowAnimation.automatic)
                
                self.loading.stopAnimating()
                
            }){(error) in
                
                print(error.localizedDescription)
            }
            
        }
        
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    
}

