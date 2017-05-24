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
                
                self.performSegue(withIdentifier: "HomeViewSegue", sender: nil)
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
    
}
