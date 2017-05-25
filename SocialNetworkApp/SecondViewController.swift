//
//  SecondViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/5/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import Firebase

class SecondViewController: UIViewController {

    @IBOutlet weak var secondContainer: UIView!
    @IBOutlet weak var firstContainer: UIView!
    
    
    @IBAction func didTapBack(_ sender: Any) {
                                dismiss(animated: true, completion: nil)
    }
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func showComponent(_ sender: UISegmentedControl) {
        
        if(sender.selectedSegmentIndex == 0){
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.firstContainer.alpha = 1
                self.secondContainer.alpha = 0
            })
        }
        else {
            
            UIView.animate(withDuration: 0.5, animations: {
                
                self.firstContainer.alpha = 0
                self.secondContainer.alpha = 1
            })
            
        }
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

