//
//  LoginViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/21/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginViewController: UIViewController {


    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var errorMsg: UILabel!
    @IBOutlet weak var loginButton: UIButton!
    
    var rootRef = Database.database().reference()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        email.addTarget(self, action: "textChanged", for: UIControlEvents.editingChanged)
                password.addTarget(self, action: "textChanged", for: UIControlEvents.editingChanged)
    }
    
    @IBAction func didTapLogin(_ sender: Any) {
        

    Auth.auth().self
        
        
        Auth.auth().signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error
            ) in
            
            if(error == nil){
                
                let email = Auth.auth().currentUser?.email as! String
                
                if (Auth.auth().currentUser?.isEmailVerified)! {
                    
                    let ref = Database.database().reference().child("user_profiles").observe(.value, with: { snapshot in
                        
                        for item in snapshot.children {
                            
                            let child = item as! DataSnapshot
                            let dict = child.value as! NSDictionary
                            
                            //check details of logged in user
                            if dict.value(forKey: "email")! as! String == email {
                                
                                //if user did not set up his profile earlier, transfer him to setup page
                                if (dict.value(forKey: "name")! as! String == "") && (dict.value(forKey: "handle")! as! String == "") {
                                    self.performSegue(withIdentifier: "loginToSetup", sender: self)
                                }
                                else {
                                    //sending user to home
                                    self.performSegue(withIdentifier: "HomeViewSegue", sender: self)
                                }
                                
                            }
                            else {
                                // self.giveAlert("invalid email address.")
                                self.errorMsg.text = "invalid email address"
                            }
                            
                        }
                        
                    })
                    
                    
                    
                }
                else
                {
                    
                    self.giveAlert("Please verify your email address ! \n go to your inbox and click verify link.")
                    
                }
            }
            else
            {
                self.errorMsg.text = error?.localizedDescription
            }
        })
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func giveAlert (_ msg : String) {
        
        //pop an alert
        let alert1 = UIAlertController(title: "Alert!", message: msg, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default , handler: nil)
        
        alert1.addAction(action1)
        
        self.present(alert1, animated: true, completion: nil)
        
    }
    
    func textChanged (_ textFeild : UITextField) {
        if self.email.text == "" || self.password.text == "" {
            self.loginButton.isEnabled = false
        }
        else {
            self.loginButton.isEnabled = true
        }
    }
    
}
