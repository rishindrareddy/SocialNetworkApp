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
                        
                        self.performSegue(withIdentifier: "HandleViewSegue", sender: nil)
                    }
                })
            }
        
        })
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
    
}
