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
    
    var rootRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
    }
    
    
    @IBAction func didTapLogin(_ sender: Any) {
        FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error
            ) in
            
            if(error == nil){
                
                let email = FIRAuth.auth()?.currentUser?.email!
                
                if (FIRAuth.auth()?.currentUser?.isEmailVerified)! {
                    let ref = self.rootRef.child("user_profiles").observe(.value, with: {
                        snapshot in
                        
                        for item in snapshot.children {
                            
                            let child = item as! FIRDataSnapshot
                            let dict = child.value as! NSDictionary
                            
                            if dict.value(forKeyPath: "email")! as! String == email {
                                
                                if (dict.value(forKey: "name")! as! String == "") && (dict.value(forKey: "handle")! as! String == ""){
                                    //segue to loginToSetUp
                                    self.performSegue(withIdentifier: "loginToSetup", sender: nil)
                                }
                                else {
                                    
                                    self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)

                                }
                            }
                            else {
                                self.errorMsg.text = "invalid email address"
                            }
                            
                            
                        }
                    })
                }
                else {
                    self.giveAlert("please verify email address ! \n check your inbox for verification link.")
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
        let alert1 = UIAlertController(title: "Oops!", message: msg, preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default , handler: nil)
        
        alert1.addAction(action1)
        
        self.present(alert1, animated: true, completion: nil)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
        
    }
    
}
