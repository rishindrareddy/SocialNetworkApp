//
//  SettingsTableViewController.swift
//  TwitterSocial
//
//  Created by Aarti Chella on 5/20/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsTableViewController: UITableViewController {
    
    var rootRef = FIRDatabase.database().reference()
    
    @IBOutlet weak var visibilitySwitch: UISwitch!
    @IBOutlet weak var notificationSwitch: UISwitch!
    
    var userID: String = ""
    var email = "mypersonalbox6@gmail.com"
    var password = "123456"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //visibilitySwitch.isOn == false
        visibilitySwitch.setOn(false, animated: true)
        
        
        FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
            if(error == nil){
                
                print ("Successful")
                self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                
                self.rootRef.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    
                    let tempvisible = value?["visibility"] as? String ?? ""
                    if( tempvisible == "public"){
                        self.visibilitySwitch.setOn(true, animated: true)
                    }
                    else {
                        self.visibilitySwitch.setOn(false, animated: true)
                    }
                    
                    let tempnotif = value?["visibility"] as? String ?? ""
                    if( tempnotif == "enabled"){
                        self.notificationSwitch.setOn(true, animated: true)
                    }
                    else {
                        self.notificationSwitch.setOn(false, animated: true)
                    }
                    
                    
                    
                }) { (error) in
                    print(error.localizedDescription)
                }
                
                print (self.userID)
                
            }else{
                _ = error?.localizedDescription
                
            }
        })
    }
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }

    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    

    @IBAction func didTapVisibility(_ sender: UISwitch) {
        
        if visibilitySwitch.isOn {
                //write into DB
            print("Switch is on")
            self.rootRef.child("users").child(self.userID).child("visibility").setValue("public")
            //visibilitySwitch.setOn(false, animated:true)
        } else {
            print("Switch is off")
            self.rootRef.child("users").child(self.userID).child("visibility").setValue("friendsonly")
        }
    }
    
    
    @IBAction func didTapNotifications(_ sender: UISwitch) {
        
        if notificationSwitch.isOn {
            //write into DB
            print("Switch is on")
            self.rootRef.child("users").child(self.userID).child("email_notif").setValue("enabled")
            //visibilitySwitch.setOn(false, animated:true)
        } else {
            print("Switch is off")
            self.rootRef.child("users").child(self.userID).child("email_notif").setValue("disabled")
        }
    }
    

}
