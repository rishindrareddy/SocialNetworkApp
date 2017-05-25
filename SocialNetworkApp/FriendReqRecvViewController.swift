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
    
    
    @IBOutlet weak var reqRcvTableView: UITableView!
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject? = .none
    
        var friendReq = [String]()
        var friendList = [String]()
    
        override func didReceiveMemoryWarning() {
            
            super.didReceiveMemoryWarning()
        }
    
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            
            return 1
            
        }
    
        internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            
            return (self.friendReq.count)
            
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath as IndexPath) as! FriendReqTableViewCell
            
            let friendList =  self.friendReq[indexPath.row] as! String
            cell.configure(name: friendList)
            return (cell)
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           
            tableView.deselectRow(at: indexPath, animated: true)
            print("You selected cell #\(indexPath.row)!")
            let handleItem = self.friendReq[indexPath.row]
            print(handleItem)
            
            
            let alertController = UIAlertController(title: "Friend Request Alert!", message: "Accept Friend?", preferredStyle: .alert)
            
            /*let okAction = UIAlertAction(title: "Ok", style: .default) { action in
                
                print ("ok is tapped")
                self.friendReq.remove(at: indexPath.row)
                self.friendList.append(handleItem)
                print (self.friendList)
                
                self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).child("freq_recv").setValue(self.friendReq)
                self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).child("friend_list").setValue(self.friendList)
                
                ///updating another user data
                
                self.databaseRef.child("user_profiles").queryOrdered(byChild: "handle").queryEqual(toValue: handleItem).observeSingleEvent(of: .childAdded, with: { (snapshot) in
                    
                    if snapshot.value != nil {
                        print(snapshot.key)
                        let newuser = snapshot.key as! String
                        
                        self.databaseRef.child("user_profiles").child(newuser).observeSingleEvent(of: .value, with: { (snapshot) in
                            let v = snapshot.value as? NSDictionary
                            
                            let l1 = v?["freq_sent"] as! NSArray
                            let l2 = v?["friend_list"] as! NSArray
                            
                            var newsent = [String]()
                            var newfrndlist = [String]()
                            
                            //populated with friend users current value
                            for item in l1{
                                newsent.append(item as! String)
                                
                            }
                            for item in l2{
                                newfrndlist.append(item as! String)
                                
                            }
                            
                            //remove from sent list
                            for item in newsent{
                                if (item == handleItem){
                                    print("Handle!!!!")
                                    print(handleItem)
                                    print("Item!!!!")
                                    print(item)
                                    let index = newsent.index(of: item)
                                    newsent.remove(at: index!)
                                }
                            }
                            
                            // add to friend list
                            
                            newfrndlist.append(handleItem)
                            
                            
                            //set the new values to the new user
                            self.databaseRef.child("user_profiles").child(newuser).child("freq_recv").setValue(newsent)
                            self.databaseRef.child("user_profiles").child(newuser).child("friend_list").setValue(newfrndlist)
                            
                            
                        }) { (error) in
                            print(error.localizedDescription)
                        }
                        
                        
                    }
                    else {
                        print ("user not found")
                        var newuser = "nil"
                    }
                })
                
                
                self.reqRcvTableView.reloadData()
                
            } */
            
            //alertController.addAction(okAction)
            
            self.view?.window?.rootViewController?.present(alertController, animated: true, completion: nil)
        }
    
    
        //Delete from table
    
        func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
            
            if editingStyle == UITableViewCellEditingStyle.delete
                
            {
    
                /*var handle = self.friendReq[indexPath.row] as! String
                
                
                self.friendReq.remove(at: indexPath.row)
                self.reqRcvTableView.reloadData()
                self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).child("freq_recv").setValue(self.friendReq)*/
                
            }
            
        }
    
        
    override func viewDidLoad() {
    
        super.viewDidLoad()
        
        /*        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
           
            let fl = value?["freq_recv"] as! NSArray
            let fr = value?["friend_list"] as! NSArray
            
            for item in fl{
                self.friendReq.append(item as! String)
                
            }
            for item in fr{
                self.friendList.append(item as! String)
                
            }
            
            self.reqRcvTableView.reloadData()
            
        }) { (error) in
            print(error.localizedDescription)
        }*/
    
    }
    
    
    
}

