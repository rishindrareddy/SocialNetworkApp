//
//  ProfileSetupViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/22/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase

class ProfileSetupViewController: UIViewController {

    @IBOutlet weak var aboutMe: UITextField!
    @IBOutlet weak var interests: UITextField!
    @IBOutlet weak var profession: UITextField!
    @IBOutlet weak var address: UITextField!
    @IBOutlet weak var handle: UITextField!
    @IBOutlet weak var fullName: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    
    var user: AnyObject? = .none
    var rootRef = Database.database().reference()
    
    @IBAction func didTapCancel(_ sender: Any) {
        
         dismiss(animated: true, completion: nil)
        
    }
    @IBAction func didTapGetStarted(_ sender: Any) {
        
        //required feilds name and handle
        if ((self.handle.text?.characters.count)! > 0) && ((self.fullName.text?.characters.count)! > 0) {
            
            self.rootRef.child("handles").child(self.handle.text!).observeSingleEvent(of: .value, with: {(snapshot:DataSnapshot) in
                
                if(!snapshot.exists())
                {
                    //update the handle in the user_profiles and in the handles node
                    
                    self.rootRef.child("user_profiles").child(self.user!.uid).child("handle").setValue(self.handle.text!.lowercased())
                    
                    //update the name of the user
                    
                    self.rootRef.child("user_profiles").child(self.user!.uid).child("name").setValue(self.fullName.text!)
                    
                    //update about of the user
                    self.rootRef.child("user_profiles").child(self.user!.uid).child("about").setValue(self.aboutMe.text!)
                    
                    
                    //update profession of the user
                    self.rootRef.child("user_profiles").child(self.user!.uid).child("profession").setValue(self.profession.text!)
                    
                    //update interests of the user
                    self.rootRef.child("user_profiles").child(self.user!.uid).child("interests").setValue(self.profession.text!)
                    
                    //update address of the user
                    self.rootRef.child("user_profiles").child(self.user!.uid).child("address").setValue(self.profession.text!)
                    
                    //update the handle in the handle node
                    
                    self.rootRef.child("handles").child(self.handle.text!.lowercased()).setValue(self.user?.uid)
                    
                    
                    
                    
                    //send the user to home screen
                    self.performSegue(withIdentifier: "HomeViewSegue", sender: self)
                    
                    
                }
                else
                {
                    self.errorMessage.text = "Handle already in use!"
                    self.giveAlert(" Handle already exists !!!")
                }
                
                
            })
        }
        else {
            
            giveAlert(" Please enter handle and full name !")
            
        }
        
        
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

      self.user = Auth.auth().currentUser
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
    func giveAlert (_ msg : String) {
        //pop an alert
        let alert1 = UIAlertController(title: "Oops!", message: msg , preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default , handler: nil)
        
        alert1.addAction(action1)
        
        self.present(alert1, animated: true, completion: nil)
    }

    

}
