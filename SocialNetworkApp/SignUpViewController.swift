//
//  SignUpViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/16/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class SignUpViewController: UIViewController {

    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var errorMessage: UILabel!
    @IBOutlet weak var password: UITextField!
    @IBOutlet weak var cPassword: UITextField!
    @IBOutlet weak var signUp: UIButton!
    
    var databaseRef = FIRDatabase.database().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        signUp.isEnabled = false
        // Do any additional setup after loading the view.
    }

    @IBAction func didTapCancel(_ sender: Any) {
        
        dismiss(animated: true, completion: nil)
    }

    @IBAction func didTapSignUp(_ sender: Any) {
        
//        signUp.isEnabled = false
//        FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
//            if(error != nil)
//            {
//                if(error!._code == 17999)
//                {
//                    self.errorMessage.text = "Invalid email Address"
//                }
//                else
//                {
//                    self.errorMessage.text = error?.localizedDescription
//                }
//            }
//            else
//            {
//                self.errorMessage.text = "Registered Succesfully"
//                
//                FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
//                    
//                    if(error == nil)
//                    {
//                        self.databaseRef.child("user_profiles").child(user!.uid).child("email").setValue(self.email.text!)
//                        
//                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
//                    }
//                })
//            }
//        
//        })
        
        //if credentials are valid.
        if validation() {
            
            signUp.isEnabled = false
            FIRAuth.auth()?.createUser(withEmail: email.text!, password: password.text!, completion: {(user, error) in
                if(error != nil)
                {
                    if(error!._code == 17999)
                    {
                        self.errorMessage.text = "Invalid email Address"
                    }
                    else
                    {
                        self.errorMessage.text = error?.localizedDescription
                    }
                }
                else
                {
                    self.errorMessage.text = "Registered Succesfully"
                    
                    FIRAuth.auth()?.signIn(withEmail: self.email.text!, password: self.password.text!, completion: { (user, error) in
                        
                        if(error == nil)
                        {
                            self.databaseRef.child("user_profiles").child(user!.uid).child("email").setValue(self.email.text!)
                            self.databaseRef.child("user_profiles").child(user!.uid).child("handle").setValue("")
                        
                        self.databaseRef.child("user_profiles").child(user!.uid).child("name").setValue("")
                            self.databaseRef.child("user_profiles").child(user!.uid).child("about").setValue("")
                            self.databaseRef.child("user_profiles").child(user!.uid).child("address").setValue("")
                            self.databaseRef.child("user_profiles").child(user!.uid).child("interest").setValue("")
                            self.databaseRef.child("user_profiles").child(user!.uid).child("profession").setValue("")
                            
                            //self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                            
                            self.giveAlert("Successfully registered ! Please verify your email from your inbox, then login.")
                            
                            FIRAuth.auth()?.currentUser?.sendEmailVerification(completion: nil)
                        }
                    })
                }
                
            })
            
            
        }
        else {
            
            giveAlert(" Please enter valid credentials !")
            
        }
        
    }
    
    
    @IBAction func textDidChange(_ sender: Any) {
        
        if (email.text?.characters.count)!>0 && (password.text?.characters.count)!>0 {
            signUp.isEnabled = true
        }
        else {
            signUp.isEnabled = false
        }
    }
    override func didReceiveMemoryWarning() {
        
        super.didReceiveMemoryWarning()
    }
    
    func giveAlert (_ msg : String) {
        //pop an alert
        let alert1 = UIAlertController(title: "Alert!", message: msg , preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "CANCEL", style: UIAlertActionStyle.default , handler: nil)
        
        alert1.addAction(action1)
        
        self.present(alert1, animated: true, completion: nil)
    }
    
    //sending user to login.
    func giveAlert2 (_ msg : String) {
        //pop an alert
        let alert1 = UIAlertController(title: "Alert", message: msg , preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let action1 = UIAlertAction(title: "OK", style: UIAlertActionStyle.default , handler: {
            ACTION in
            self.transfer()
        })
        
        alert1.addAction(action1)
        
        self.present(alert1, animated: true, completion: nil)
    }
    
    func transfer () {
        self.performSegue(withIdentifier: "signupToLogin", sender: self)
    }
    
    func validation () -> Bool {
        return ((self.email.text?.characters.count)! > 0) && ((self.password.text?.characters.count)! > 0) && ((self.cPassword.text)! == (self.password.text)!)
    }
    
    
}
