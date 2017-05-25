//
//  ShowMailViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/24/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit

class ShowMailViewController: UIViewController {

//    @IBOutlet weak var toLabel: UILabel!
//    
//    
//    @IBOutlet weak var toLabelView: UILabel!
//    
//    
//    @IBOutlet weak var fromLabelView: UILabel!
//    
//    
//    @IBOutlet weak var subLabelView: UILabel!
//    
//    
//    @IBOutlet weak var mailBodyView: UITextView!
    
    
    @IBOutlet weak var mailBodyView: UITextView!
    @IBOutlet weak var subLabelView: UILabel!
    @IBOutlet weak var toLabelView: UILabel!
    @IBOutlet weak var fromLabelView: UILabel!
    
    var toLabelText = ""
    var fromLabelText = ""
    var subLabelText = ""
    var mailBodyText = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        toLabelView.text   = toLabelText
        fromLabelView.text = fromLabelText
        subLabelView.text  = subLabelText
        mailBodyView.text  = mailBodyText
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

}
