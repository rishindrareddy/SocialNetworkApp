//
//  SecondViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/5/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseDatabase

class SecondViewController: UIViewController, UITableViewDelegate, UISearchResultsUpdating {

    @IBOutlet weak var followUsersTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
    var databaseRef = FIRDatabase.database().reference()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self as! UISearchResultsUpdating
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        followUsersTableView.tableHeaderView = searchController.searchBar
        
        databaseRef.child("user_profiles").queryOrdered(byChild: "name").observe(.childAdded, with: {
        (snapshot) in
        
            self.usersArray.append(snapshot.value as? NSDictionary)
            //insert rows
            self.followUsersTableView.insertRows(at: [IndexPath(row: self.usersArray.count-1, section: 0)], with: UITableViewRowAnimation.automatic)
            
        })
        { (error) in
            print(error.localizedDescription)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//     
//        return cell
//    }
    func updateSearchResults(for searchController: UISearchController) {
        
    }


}

