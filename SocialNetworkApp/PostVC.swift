//
//  PostVC.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/14/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseDatabase
import FirebaseAuth

class PostVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject? = .none
    
    @IBOutlet weak var btnPostIt: UIStackView!
    @IBOutlet weak var messageText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        messageText.textContainerInset = UIEdgeInsetsMake(30, 20, 20, 20)
        messageText.text = "Hello, what's happening?"
        messageText.textColor = UIColor.lightGray
    }

    func textViewDidBeginEditing(_ textView: UITextView) {
        if messageText.textColor == UIColor.lightGray {
            messageText.text = ""
            messageText.textColor = UIColor.black
        }
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return false
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        let imagePickerController = UIImagePickerController()
        imagePickerController.delegate = self
        
        let actionSheet = UIAlertController(title: "Photo Source", message: "Choose a source", preferredStyle: .actionSheet)
        
        actionSheet.addAction(UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
            
            if UIImagePickerController.isSourceTypeAvailable(.camera) {
                imagePickerController.sourceType = .camera
                self.present(imagePickerController, animated: true, completion: nil)
            }else{
                print("Camera not available")
            }
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Photo Library", style: .default, handler: { (action:UIAlertAction) in
            imagePickerController.sourceType = .photoLibrary
            self.present(imagePickerController, animated: true, completion: nil)
        }))
        
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        self.present(actionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        var attributedString = NSAttributedString()
        if messageText.text.characters.count>0 {
            attributedString = NSAttributedString(string: self.messageText.text)
        }
        else {
            attributedString = NSAttributedString(string: "Hello, what's up?")
        }
        
        let textAttachment = NSTextAttachment()
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        textAttachment.image = image
        let oldWidth:CGFloat = textAttachment.image!.size.width
        let scaleFactor:CGFloat = oldWidth/(messageText.frame.size.width-50)
        
        textAttachment.image = UIImage.init(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
       
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        let combination = NSMutableAttributedString()
        combination.append(attributedString)
        combination.append(attrStringWithImage)
       
        messageText.attributedText = combination
        print(messageText)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    @IBAction func btnPostItClick(_ sender: Any) {
     
        if messageText.text.characters.count>0 {
            
            let key = self.databaseRef.child("posts").childByAutoId().key
           
            let childUpdates = ["/posts/\(self.loggedInUser!.uid!)/\(key)/text":messageText.text,
                                "/posts/\(self.loggedInUser!.uid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)"] as [String : Any]
 
            self.databaseRef.updateChildValues(childUpdates)
            
            dismiss(animated: true, completion: nil)
            }
        
        }

    }
    

