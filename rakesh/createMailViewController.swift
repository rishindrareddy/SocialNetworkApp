//
//  createMailViewController.swift
//  TwitterSocial
//
//  Created by Datta, Rakesh on 5/24/17.
//  Copyright © 2017 app. All rights reserved.
//

import UIKit

protocol createMailViewControllerDelegate {
    func addNew(mail: msgItem)
}

class createMailViewController: UIViewController {

    var delegate: createMailViewControllerDelegate!
    
    
    //IBSoutlets
    @IBOutlet weak var toTextField: UITextField!
    
    
    @IBOutlet weak var mailBodyTextField: UITextView!
    
    @IBOutlet weak var mailSubTextField: UITextField!
    
    
    
    //IBSAction
    @IBAction func sendMail(_ sender: Any) {
        let m = msgItem(from: "u1", to: toTextField.text!, sub: mailSubTextField.text!, body:  mailBodyTextField.text! )
        
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
