//
//  SecondViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/5/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class SecondViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating, UITableViewDataSource {

    @IBOutlet weak var followUsersTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var loggedInUser: FIRUser?
    
    var databaseRef = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(self.loggedInUser)
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        followUsersTableView.tableHeaderView = searchController.searchBar
        
        
        databaseRef.child("user_profiles").queryOrdered(byChild: "email").observe(.childAdded, with: { (snapshot) in
            
            
            let key = snapshot.key
            let snapshot = snapshot.value as? NSDictionary
            snapshot?.setValue(key, forKey: "uid")
            
            if(key == self.loggedInUser?.uid)
            {
                print("Same as logged in user, so don't show!")
            }
            else
            {
                self.usersArray.append(snapshot)
                //insert the rows
                self.followUsersTableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            }
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

    
    }
    
    func filterContent(searchText: String){
    
        self.filteredUsers = self.usersArray.filter{ user in
            
            let username = user!["email"] as? String
            
            return(username?.lowercased().contains(searchText.lowercased()))!
            
        }
        
        followUsersTableView.reloadData()    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        return self.usersArray.count
       
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
     
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            user = filteredUsers[indexPath.row]
        }
        else
        {
            user = self.usersArray[indexPath.row]
        }
        
        cell.textLabel?.text = user?["email"] as? String
        cell.detailTextLabel?.text = user?["handle"] as? String
        
        
        return cell
    }
   
    func updateSearchResults(for searchController: UISearchController) {
        //update search results
        filterContent(searchText: self.searchController.searchBar.text!)
        
    }


}

