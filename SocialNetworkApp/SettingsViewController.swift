//
//  SettingsViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class SettingsViewController: UIViewController {
    
    var rootRef = FIRDatabase.database().reference()

    var loggedInUser: AnyObject? = .none
    
    @IBOutlet weak var notificationSwitch: UISwitch!
    @IBOutlet weak var visibilitySwitch: UISwitch!
    
    @IBAction func didTapCancel(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
       
        super.viewDidLoad()
        self.loggedInUser = FIRAuth.auth()?.currentUser
            
            self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
                
                let value = snapshot.value as? NSDictionary
                
                let tempvisible = value?["visibility"] as! String
                
                if( tempvisible == "public"){
                    self.visibilitySwitch.setOn(true, animated: true)
                }
                else {
                    self.visibilitySwitch.setOn(false, animated: true)
                }
                
                let tempnotif = value?["notifications"] as! String
                
                if( tempnotif == "enabled"){
                    self.notificationSwitch.setOn(true, animated: true)
                }
                else {
                    self.notificationSwitch.setOn(false, animated: true)
                }
                
            }) { (error) in
                print(error.localizedDescription)
            }
        
    }

    @IBAction func didTapVisibility(_ sender: Any) {
        
        if visibilitySwitch.isOn {
            
            print("Switch is on")
            self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("visibility").setValue("public")
            
        } else {
            print("Switch is off")
            self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("visibility").setValue("friendsonly")
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func didTapNotifications(_ sender: UISwitch) {
        
        if notificationSwitch.isOn {
            //write into DB
            print("Switch is on")
            self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("email_notif").setValue("enabled")
           
        } else {
            print("Switch is off")
            self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("email_notif").setValue("disabled")
        }
        }
    }


    

