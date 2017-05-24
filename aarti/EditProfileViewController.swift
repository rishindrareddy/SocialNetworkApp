//
//  EditProfileViewController.swift
//  TwitterSocial
//
//  Created by Aarti Chella on 5/20/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class EditProfileViewController: UIViewController {
    
    var rootRef = FIRDatabase.database().reference()

    
    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var locationTextField: UITextField!
    @IBOutlet weak var professionTextField: UITextField!
    @IBOutlet weak var aboutTextView: UITextView!
    @IBOutlet weak var interestsTextField: UITextField!
    
    var userID: String = ""
    var email = "mypersonalbox6@gmail.com"
    var password = "123456"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        FIRAuth.auth()?.signIn(withEmail: self.email, password: self.password, completion: { (user, error) in
            if(error == nil){
                
                print ("Successful")
                self.userID = (FIRAuth.auth()?.currentUser?.uid)!
                
                self.rootRef.child("users").child(self.userID).observeSingleEvent(of: .value, with: { (snapshot) in
                    let value = snapshot.value as? NSDictionary
                    self.nameTextField.text = value?["name"] as? String ?? ""
                    self.aboutTextView.text = value?["about"] as? String ?? ""
                    self.professionTextField.text = value?["prof"] as? String ?? ""
                    self.locationTextField.text = value?["loc"] as? String ?? ""
                    self.interestsTextField.text = value?["interests"] as? String ?? ""
                    
                    
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
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func didTapBack(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func editProfileSubmit(_ sender: Any) {
       
//        
        self.rootRef.child("users").child(self.userID).child("about").setValue(aboutTextView.text)
      self.rootRef.child("users").child(self.userID).child("prof").setValue(professionTextField.text)
        self.rootRef.child("users").child(self.userID).child("loc").setValue(locationTextField.text)
        //self.rootRef.child("users").child(self.userID).child("prof").setValue(["interests": interestsTextField.text])
       
        self.rootRef.child("users").child(self.userID).child("interests").setValue(interestsTextField.text)
    
        
        
    }


}
