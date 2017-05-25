//
//  EditProfileViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {
    
    var rootRef = FIRDatabase.database().reference()

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var aboutTextField: UITextField!
    @IBOutlet weak var interestsTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    
    var loggedInUser: AnyObject? = .none
    
    @IBAction func didTapSave(_ sender: Any) {
        
        self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("name").setValue(nameTextField.text)
        self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("about").setValue(aboutTextField.text)
        self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("profession").setValue(professionTextField.text)
        self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("address").setValue(locationTextField.text)
        self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).child("interests").setValue(interestsTextField.text)
        
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
    
     dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.rootRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            let value = snapshot.value as? NSDictionary
            
            self.nameTextField.text = value?["name"] as? String
            self.aboutTextField.text = value?["about"] as? String
            self.professionTextField.text = value?["profession"] as? String
            self.locationTextField.text = value?["address"] as? String
            self.interestsTextField.text = value?["interests"] as? String
            
            
        }) { (error) in
            print(error.localizedDescription)
        }

        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
