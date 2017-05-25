//
//  MessageViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class MessageViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, createMailViewControllerDelegate {
    
    
    @IBOutlet weak var msgTableView: UITableView!
    var loggedInUser: AnyObject? = .none
    var databaseRef = FIRDatabase.database().reference()
    
    var rootRef: FIRDatabaseReference!
    
    var userID: String = ""
    var email = "mypersonalbox6@gmail.com"
    var password = "123456"
    var handle = ""
    var msgArray = [msgItem]()
    var count = 20

    
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var subTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedInUser = FIRAuth.auth()?.currentUser
    
        rootRef = FIRDatabase.database().reference()
        
        //Get the messages from users mailbox
        FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
            if(error == nil){
                
                print ("Successful")
                self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                //self.handle = value?["handle"] as? String ?? ""
                
                self.rootRef.child("users").child(self.userID).child("mailbox").observeSingleEvent(of: .value, with: { (snapshot) in
                    
                    
                    for item in snapshot.children {
                        
                        let child = item as! FIRDataSnapshot
                        let dict = child.value as! NSDictionary
                        print(dict.value(forKey: "from")!)
                        print(dict.value(forKey: "to")!)
                        print(dict.value(forKey: "body")!)
                        print(dict.value(forKey: "sub")!)
                        
                        let m = msgItem(from: dict.value(forKey: "from")! as! String,to: dict.value(forKey: "to")! as! String,sub: dict.value(forKey: "sub")! as! String,body: dict.value(forKey: "body")! as! String, id: child.key as! String)
                        self.msgArray.append(m)
                        
                    }
                    
                    self.msgTableView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            } else {
                
            }
        })
    }
//    @IBAction func composeMessage(_ sender: Any) {
//        
//        
//    }
//    
    
    
    
    func addNew(mail: msgItem) {
        
        
        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            self.handle = (value?["handle"] as? String)!
            
            var  elem: NSMutableDictionary = [:]
            
            
            elem.setValue(self.handle, forKey: "from")
            elem.setValue(mail.to, forKey: "to")
            elem.setValue(mail.sub, forKey: "sub")
            elem.setValue(mail.body, forKey: "body")
            
            
            let key = self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).child("mailbox").childByAutoId().key
            
            self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).child("mailbox").child(key).setValue(elem)
            
            
            mail.from = self.handle
            mail.id = key
            self.msgArray.append(mail)
            self.msgTableView.reloadData()
            
            
        }){ (error) in
            print(error.localizedDescription)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return msgArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
       
        let mail = msgArray[indexPath.row]
        cell.textLabel?.text = "user:" + mail.to
        cell.detailTextLabel?.text = "Sub:" + mail.sub
        self.count-=1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("You selected cell #\(indexPath.row)!")
        
        performSegue(withIdentifier: "viewMessageSegue", sender: msgArray[indexPath.row])
        
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Remove from firebase
            FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
                if(error == nil){
                    self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                    self.rootRef.child("users").child(self.userID).child("mailbox").child(self.msgArray[indexPath.row].id).removeValue()
                    
                    self.msgArray.remove(at: indexPath.row)
                    self.msgTableView.reloadData()
                    
                } else {
                    
                    print("could not delete")
                    
                }
                
            })
            
                   }
    }
    
    //MARK: View lifecycle
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createMailSegue" {
            let destVC1 = segue.destination as! createMailViewController
            destVC1.delegate = self
            
            
        }
        
        if segue.identifier == "viewMessageSegue" {
            let destVC2 = segue.destination as! ShowMailViewController
         
            let temp = sender as? msgItem
            destVC2.toLabelText = temp?.to as! String
            destVC2.fromLabelText = temp?.from as! String
            destVC2.subLabelText = temp?.sub as! String
            destVC2.mailBodyText = temp?.body as! String
            
            
        }
        
    }
    
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
