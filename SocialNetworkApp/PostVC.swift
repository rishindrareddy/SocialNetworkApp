//
//  PostVC.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/14/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit

class PostVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @IBOutlet weak var btnPostIt: UIStackView!
   // var loggedInUser = AnyObject?()
    @IBOutlet weak var messageText: UITextView!
    
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
    
    @IBAction func btnPostItClick(_ sender: Any) {
     
        if messageText.text.characters.count>0 {
            //add it to database 
//            
//            let para:NSMutableDictionary = NSMutableDictionary()
//            let prodArray:NSMutableArray = NSMutableArray()
//            
//            para.setValue(String(receivedString), forKey: "room")
//            para.setValue(observationString, forKey: "observation")
//            para.setValue(stringDate, forKey: "date")
//            
//            for product in products
//            {
//                let prod: NSMutableDictionary = NSMutableDictionary()
//                prod.setValue(product.name, forKey: "name")
//                prod.setValue(product.quantity, forKey: "quantity")
//                prodArray.addObject(prod)
//            }
//            
//            para.setObject(prodArray, forKey: "products")
            
            
            let date = NSDate()
            
            let formatter = DateFormatter()
            formatter.dateFormat = "yyyy-MM-dd HH:mm:ss ZZZ"
            
            let defaultTimeZoneStr = formatter.string(from: date as Date)
            
            let postArray:NSMutableArray = NSMutableArray()
            let postdetails:NSMutableDictionary = NSMutableDictionary()
            
            //user, content, ts
            
            postdetails.setValue(messageText, forKey: "postContent")
            postdetails.setValue(defaultTimeZoneStr, forKey: "timestamp")
            
            postArray.add(postdetails)
    
        }

    }
    override func viewDidLoad() {
        super.viewDidLoad()

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
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
