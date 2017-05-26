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
import FirebaseAuth


class FriendReqRecvViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    var friendKey : String = ""
    var friendData : NSDictionary = [:]
    
    var friendReqList = [NSDictionary?]()
    
    //handles of users
    //var friendReq = [String]()
    var friendList = [String]()
    
    
    @IBOutlet weak var reqRcvTableView: UITableView!
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject? = .none
    
    var userid = ""
    
        override func didReceiveMemoryWarning() {
            
            super.didReceiveMemoryWarning()
        }
    
        
        func numberOfSectionsInTableView(tableView: UITableView) -> Int {
            return 1
        }
    
        internal func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
            return (self.friendReqList.count)
            
        }
    
        func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for : indexPath as IndexPath) as! FriendReqTableViewCell
            cell.textLabel?.text = self.friendReqList[indexPath.row]?["handle"] as? String
            return (cell)
            
        }
    
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            
            tableView.deselectRow(at: indexPath, animated: true)
            let handleItem = self.friendReqList[indexPath.row]! as NSDictionary
            self.friendData = handleItem as! NSDictionary
            let handle = handleItem["handle"]! as! String
            self.databaseRef.child("handles").observeSingleEvent(of: .childAdded, with: { (snapshot) in
                self.friendKey = snapshot.value as! String
            }) { (error) in
                print(error.localizedDescription)
                
                
                let alertController = UIAlertController(title: "Alert", message: "Friend request action", preferredStyle: .alert)
                
                let okAction = UIAlertAction(title: "Accept", style: .default) {
                    ACTION in
                    self.acceptReq()
                }
                
                let rejAction = UIAlertAction(title: "Reject", style: .default) {
                    ACTION in
                    self.rejectReq()
                }
                

                let cancel = UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil)
                alertController.addAction(okAction)
                alertController.addAction(rejAction)
                alertController.addAction(cancel)
                
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
           
    
    
    
}
    
    func acceptReq () {
        
        print ("ok is tapped")
        
        let req_snt = "freq_sent/userid as! String/\(self.friendKey as! String)"
        let req_rcv = "freq_rcv/\(self.friendKey as! String)/\(userid as! String)"
        
        let friend1 = "friends/userid as! String/\(self.friendKey as! String)"
        let friend2 = "friends/\(self.friendKey as! String)/userid as! String"
        
        
        
        
        let data = ["name" : self.friendData["name"] as! String, "handle" : self.friendData["handle"] as! String ]
        
        
        let childUpdates = [req_snt : NSNull(), req_rcv : NSNull(), friend1 : data] as [String : Any]
        
        self.databaseRef.updateChildValues(childUpdates)
        
        
        
    }
    
    func rejectReq () {
        
        let req_rcv = "freq_rcv/\(self.friendKey as! String)/\(userid as! String)"
        
        let childUpdates = [ req_rcv : NSNull()] as [String : Any]
        
        self.databaseRef.updateChildValues(childUpdates)
        
        
        
    }
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        self.userid = FIRAuth.auth()?.currentUser?.uid as! String
        
        databaseRef.child("freq_rcv").child(self.userid).observe(.childAdded, with: { (snapshot) in
            
            
            let snapshot = snapshot.value as? NSDictionary
            
            //add the followers to the array
            self.friendReqList.append(snapshot)
            
            //insert row
            self.reqRcvTableView.insertRows(at: [IndexPath(row:self.friendReqList.count-1,section:0)], with: UITableViewRowAnimation.automatic)
            
            
        }) { (error) in
            print(error.localizedDescription)
        }
    }

}

