//
//  SecondViewController.swift
//  TwitterSocial
//
//  Created by Aarti Chella on 5/20/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase


class SecondViewController: UIViewController {

    @IBOutlet weak var searchTableView: UITableView!
    
    @IBOutlet weak var searchUser: UISearchBar!
    
    //database reference
    var ref = Database.database().reference().child(byAppendingPath: "users")
    
    
    
    //search button action function
    @IBAction func searchButton(_ sender: Any) {
        
        
        var input = searchUser.text as String!
 
      //  var ref = Database.database().reference()
        
        if (input?.isEmpty)! {
            let alert = UIAlertController(title: "Oops !!", message: "Search feild empty! Please enter name of the user", preferredStyle: UIAlertControllerStyle.actionSheet)
            
            let action1 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
            alert.addAction(action1)
            self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
        
        }
            
        else{
           
            //query
            ref.observe(.value, with: { snapshot in
                
                let users = snapshot.children.allObjects as? [DataSnapshot]
                
                //if users are empty
                if (users?.isEmpty)! {
                    
                    //alert to say that no matches found
                    let alert = UIAlertController(title: "Oops..", message: "No users found match the search.", preferredStyle: UIAlertControllerStyle.actionSheet)
                    
                    let action1 = UIAlertAction(title: "Cancel", style: .default, handler: nil)
                    alert.addAction(action1)
                    self.view?.window?.rootViewController?.present(alert, animated: true, completion: nil)
                    
                }
                
                
                else{
                    
                    
                    
                    //for pool of users
                    var array = [[String: String]]()
                    
                    for user in users!{
                    
                        if (user.value(forKey: "visibility") as! String) != "public"{
                            print("\n private user found \n")
                        
                        }
                            
                        else{
                         
                            print("\n USER : \n \(user)!")
                            
                            let email : String  = user.value(forKey: "email")  as! String
                            let uname : String = user.value(forKey: "handle") as! String
                            let name  : String = user.value(forKey: "name") as! String
                            
                            if ((email.range(of: input!) != nil) || (uname.range(of: input!) != nil) || (name.range(of: input!) != nil)){
                                
                                //create a dictonary for mathced users
                                var match : [String : String] = [:]
                                
                                //adding user values to match
                                match["name"] = user.value(forKey: "name") as! String
                                match["handle"] = user.value(forKey: "hadle") as! String
                                
                                //adding user to pool
                                array.append(match)
                                
                            } //if loop end
                            
                        } //else loop end
                        
                    }// users for loop end
                    
                    print("\n USERS TO FILL IN TABLE : \n \(array)")
                } //else loop end
                
            }) //query closure end
            
            //func
            //to
            // fill
            //the 
            //table
            //view
            
            
        }//else loop end
    } //search button action func end
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        
        
    }

    
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

