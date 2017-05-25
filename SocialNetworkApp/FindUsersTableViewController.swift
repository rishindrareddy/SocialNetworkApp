//
//  FindUsersTableViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

class FindUsersTableViewController: UITableViewController, UISearchResultsUpdating {
    
    @IBOutlet var findUsersTableView: UITableView!
    let searchController = UISearchController(searchResultsController: nil)
    
    //var loggedInUser:FIRUser?
    var usersArray = [NSDictionary?]()
    var filteredUsers = [NSDictionary?]()
  
    var databaseRef = FIRDatabase.database().reference()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        tableView.tableHeaderView = searchController.searchBar
        
        
        databaseRef.child("user_profiles").queryOrdered(byChild: "email").observe(.childAdded, with: { (snapshot) in
            
            let snapshot = snapshot.value as? NSDictionary
            
            
              self.usersArray.append(snapshot)
                //insert the rows
                self.findUsersTableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
        
//        databaseRef.child("user_profiles").queryOrdered(byChild: "name").observe(.childAdded, with: { (snapshot) in
//            
//            let snapshot = snapshot.value as? NSDictionary
//            
//            
//            self.usersArray.append(snapshot)
//            //insert the rows
//            self.findUsersTableView.insertRows(at: [IndexPath(row:self.usersArray.count-1,section:0)], with: UITableViewRowAnimation.automatic)
//            
//            
//            
//        }) { (error) in
//            print(error.localizedDescription)
//        }

    }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
      
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
       
        if searchController.isActive && searchController.searchBar.text != ""{
            return filteredUsers.count
        }
        return self.usersArray.count

    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        
        let user : NSDictionary?
        
        if searchController.isActive && searchController.searchBar.text != ""{
            
            user = filteredUsers[indexPath.row]
        }
        else
        {
            user = self.usersArray[indexPath.row]
        }
        
        
        cell.textLabel?.text = user?["name"] as? String
        cell.detailTextLabel?.text = user?["handle"] as? String
        
        
        return cell
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */


    @IBAction func dismissFindUsersTableView(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }

    func updateSearchResults(for searchController: UISearchController) {
    
        filterContent(searchText: self.searchController.searchBar.text!)
    
    }
    func filterContent(searchText:String)
    {
        self.filteredUsers = self.usersArray.filter { user in
        
            let u = user!["email"] as? String
            let n = user!["name"] as? String
            
            let username = [u,n].flatMap{$0}.joined(separator: " ")
        
        return(username.lowercased().contains(searchText.lowercased()))
        
    }
    
        tableView.reloadData()
    }

}
