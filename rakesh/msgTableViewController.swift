//
//  msgTableViewController.swift
//  TwitterSocial
//
//  Created by Datta, Rakesh on 5/24/17.
//  Copyright © 2017 app. All rights reserved.
//

import Foundation

import UIKit
import FirebaseAuth
import FirebaseDatabase


class msgTableViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, createMailViewControllerDelegate {
    
    var rootRef: FIRDatabaseReference!
    
    var userID: String = ""
    var email = "mypersonalbox6@gmail.com"
    var password = "123456"
    var handle = ""
    
    @IBOutlet weak var toTextField: UITextField!
    @IBOutlet weak var fromTextField: UITextField!
    @IBOutlet weak var subTextField: UITextField!

    
    var array = [msgItem]()
    
    
    // Table view delegate methods
    
    var count = 20
    
    
    @IBOutlet weak var tableView: UITableView!
    
    func addNew(mail: msgItem) {
//        mail.from = self.handle
//        array.append(mail)
//        tableView.reloadData()
        
        FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
            if(error == nil){
                
                print ("Successful")
                self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                self.rootRef.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    self.handle = value?["handle"] as? String ?? ""
                    
                    var  elem:NSMutableDictionary = [:]
                    
                    
                    elem.setValue(self.handle, forKey: "from")
                    elem.setValue(mail.to, forKey: "to")
                    elem.setValue(mail.sub, forKey: "sub")
                    elem.setValue(mail.body, forKey: "body")
                    
                    
                    
                    //self.rootRef.child("users").child(self.userID).child("mailbox").childByAutoId().setValue(elem)
                    
                    let key = self.rootRef.child("users").child(self.userID).child("mailbox").childByAutoId().key
                    
                    self.rootRef.child("users").child(self.userID).child("mailbox").child(key).setValue(elem)
                    
                    
                    mail.from = self.handle
                    mail.id = key
                    self.array.append(mail)
                    self.tableView.reloadData()
                    
                    
                }){ (error) in
                    print(error.localizedDescription)
                }
                //self.handle = value?["handle"] as? String ?? ""
                
//                var  elem:NSMutableDictionary = [:]
//                
//                
//                elem.setValue(self.handle, forKey: "from")
//                elem.setValue(mail.to, forKey: "to")
//                elem.setValue(mail.sub, forKey: "sub")
//                elem.setValue(mail.body, forKey: "body")
//                
//                
//                
//                self.rootRef.child("users").child(self.userID).child("mailbox").childByAutoId().setValue(elem)
//                
                /*
                self.rootRef.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSMutableDictionary
                    let fl = value?["mailbox"] as! NSMutableArray
                    
                    var elem:NSMutableDictionary
                    //var item = msgItem(from: mail.from ,to: mail.to,sub: mail.sub,body: mail.body)
                    elem.setValue(mail.from, forKey: "from")
                    elem.setValue(mail.to, forKey: "to")
                    elem.setValue(mail.sub, forKey: "sub")
                    elem.setValue(mail.body, forKey: "body")
                    
                   
                    
                    //for element in fl {
                      //  elem = (element as? NSDictionary)!
                        let item = msgItem(from: mail.from ,to: mail.to,sub: mail.sub,body: mail.body)
                       // self.array.append(item)
                        
                    //}
                    //self.tableView.reloadData()
                    
                    
                    fl.add(item)
                    
                    print(fl)

                    
                }) { (error) in
                    print(error.localizedDescription)
                }
            
            */
            } else {
                
            }
        })//end of FIRauth
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return array.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell") as! UITableViewCell
        
        
        //var to:String = self.toTextField.text!
            
        
       
        //cell.textLabel?.text = to
        let mail = array[indexPath.row]
        cell.textLabel?.text = "user:" + mail.to
        cell.detailTextLabel?.text = "Sub:" + mail.sub

        
        self.count-=1
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        print("You selected cell #\(indexPath.row)!")
        
        performSegue(withIdentifier: "deleteMailSegue", sender: array[indexPath.row])
        
    }
   
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // Remove from firebase
            FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
                if(error == nil){
                    self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                    self.rootRef.child("users").child(self.userID).child("mailbox").child(self.array[indexPath.row].id).removeValue()
                    
                    self.array.remove(at: indexPath.row)
                    self.tableView.reloadData()
                    
                } else {
                    
                    print("could not delete")
                    
                }
                
            })
            
//            array.remove(at: indexPath.row)
//            tableView.reloadData()
            
        }
    }
    
    //MARK: View lifecycle 
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "createMailSegue" {
            let destVC1 = segue.destination as! createMailViewController
            destVC1.delegate = self
            
            
        }
        
        if segue.identifier == "deleteMailSegue" {
            let destVC2 = segue.destination as! deleteMailViewController
            //destVC2.delegate = self
            //var temp = msgItem(from: "", to: "", sub: "")
            //temp = sender
            let temp = sender as? msgItem
            destVC2.toLabelText = temp?.to as! String
            destVC2.fromLabelText = temp?.from as! String
            destVC2.subLabelText = temp?.sub as! String
            destVC2.mailBodyText = temp?.body as! String

            //destVC2.mailLabelText = temp?.sub as! String
            
        }
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        rootRef = FIRDatabase.database().reference()

        //let m1 = msgItem(from: "u1",to: "u2", sub: "When are you coming?", body: "Default body")
        //self.array.append(m1)
        
        
        
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
                        self.array.append(m)
                        
                        
                        
                        
                    }
                    
//                    let value = snapshot.value as? NSDictionary
//                    let fl = value?["mailbox"] as! NSArray
//                    
//                    //Get the user handle
//                    self.handle = value?["handle"] as? String ?? ""
//                    
//                    var elem:NSDictionary
//                    
//                    for element in fl {
//                        elem = (element as? NSDictionary)!
//                        let item = msgItem(from: elem["from"]as! String ,to: elem["to"]as! String,sub: elem["sub"]as! String,body: elem["body"]as! String)
//                        self.array.append(item)
//                    
//                    }
                    self.tableView.reloadData()
                }) { (error) in
                    print(error.localizedDescription)
                }
                
            } else {
                
            }
        })//end of FIRauth
            
            
        
        //let m1 = msgItem(from: "u1",to: "u2", sub: "When are you coming?", body: "Default body")
        //let m2 = msgItem(from: "u1",to: "u2", sub: "When are you coming?", body: "Default body")
        
        //let m2 = msgItem(from: "u1",to: "u3", sub: "Invitation to course", body: "Default body")
    
        //array.append(m1)
        //array.append(m2)
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
