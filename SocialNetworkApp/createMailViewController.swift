//
//  createMailViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit

protocol createMailViewControllerDelegate {
    func addNew(mail: msgItem)
}

class createMailViewController: UIViewController {
    
    var delegate: createMailViewControllerDelegate!

    
    @IBOutlet weak var toTextField: UITextField!
    
    @IBOutlet weak var mailSubTextField: UITextField!
    
    @IBOutlet weak var mailBodyTextField: UITextView!

   
    @IBAction func sendMail(_ sender: Any) {
        let m = msgItem(from: "", to: toTextField.text!, sub: mailSubTextField.text!, body:  mailBodyTextField.text!, id: "" )
        
        delegate.addNew(mail: m)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        
    }
    
}
