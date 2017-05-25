//
//  StartViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/22/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth

class StartViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
    
       // try! FIRAuth.auth()!.signOut()
        
        FIRAuth.auth()?.addStateDidChangeListener({ (auth, user) in
            
            if let currentUser = user{
                
                print("user is signed in")
                
                //send the user to the homeViewController
                
                let mainStoryboard: UIStoryboard = UIStoryboard(name:"Main",bundle:nil)
                
                let homeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "TabBarControllerView")
                
                //send the user to the homescreen
                self.present(homeViewController, animated: true, completion: nil)
                
            }
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
