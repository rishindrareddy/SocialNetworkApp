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
import FirebaseStorage

class PostVC: UIViewController, UITextViewDelegate, UITextFieldDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    var databaseRef = FIRDatabase.database().reference()
    var loggedInUser: AnyObject? = .none
   
    @IBOutlet weak var btnPostIt: UIStackView!
    @IBOutlet weak var messageText: UITextView!
    
    var imagePicker = UIImagePickerController()
    
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
    
    @IBAction func btnPostItClick(_ sender: Any) {
        
        var imagesArray = [AnyObject]()
        
        //extract the images from the attributed text
        self.messageText.attributedText.enumerateAttribute(NSAttachmentAttributeName, in: NSMakeRange(0, self.messageText.text.characters.count), options: []) { (value, range, true) in
            
            if(value is NSTextAttachment)
            {
                let attachment = value as! NSTextAttachment
                var image : UIImage? = nil
                
                if(attachment.image !== nil)
                {
                    image = attachment.image!
                    imagesArray.append(image!)
                }
                else
                {
                    print("No image found")
                }
            }
        }
        
        let postLength = messageText.text.characters.count
        let numImages = imagesArray.count
        
        //create a unique auto generated key from firebase database
        let key = self.databaseRef.child("posts").childByAutoId().key
        
        let storageRef = FIRStorage.storage().reference()
        let pictureStorageRef = storageRef.child("user_profiles/\(self.loggedInUser!.uid!)/media/\(key)")
        
        //user has entered text and an image
        if(postLength>0 && numImages>0)
        {
            let lowResImageData = UIImageJPEGRepresentation(imagesArray[0] as! UIImage, 0.50)
            let uploadTask = pictureStorageRef.put(lowResImageData!,metadata: nil)
            { metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = ["/posts/\(self.loggedInUser!.uid!)/\(key)/text":self.messageText.text,
                                        "/posts/\(self.loggedInUser!.uid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)",
                        "/posts/\(self.loggedInUser!.uid!)/\(key)/picture":downloadUrl!.absoluteString] as [String : Any]
                    
                    self.databaseRef.updateChildValues(childUpdates)
                }
            }
            
            dismiss(animated: true, completion: nil)
        }
            
            //user has entered only text
        else if(postLength>0)
        {
            let childUpdates = ["/posts/\(self.loggedInUser!.uid!)/\(key)/text":messageText.text,
                                "/posts/\(self.loggedInUser!.uid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)"] as [String : Any]
            
            self.databaseRef.updateChildValues(childUpdates)
            
            dismiss(animated: true, completion: nil)
            
        }
            //user has entered only an image
        else if(numImages>0)
        {
            let lowResImageData = UIImageJPEGRepresentation(imagesArray[0] as! UIImage, 0.50)
            let uploadTask = pictureStorageRef.put(lowResImageData!,metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    let childUpdates = [
                        "/posts/\(self.loggedInUser!.uid!)/\(key)/timestamp":"\(NSDate().timeIntervalSince1970)",
                        "/posts/\(self.loggedInUser!.uid!)/\(key)/picture":downloadUrl!.absoluteString]
                    
                    self.databaseRef.updateChildValues(childUpdates)
                }
                else
                {
                    print(error?.localizedDescription)
                }
            }
            dismiss(animated: true, completion: nil)
        }
        
        // performSegue(withIdentifier: "postToHome", sender: self)
        
    }
    
    @IBAction func addPhoto(_ sender: Any) {
        
        if UIImagePickerController.isSourceTypeAvailable(.savedPhotosAlbum)
        {
            self.imagePicker.delegate = self
            self.imagePicker.sourceType = .savedPhotosAlbum
            self.imagePicker.allowsEditing = true
            self.present(self.imagePicker, animated: true, completion: nil)
        }
    }
    
    @IBAction func didTapCancel(_ sender: Any) {
        
       dismiss(animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        var attributedString = NSMutableAttributedString()
        if messageText.text.characters.count>0 {
            attributedString = NSMutableAttributedString(string: self.messageText.text)
        }
        else {
            attributedString = NSMutableAttributedString(string: "Hello, what's up?")
        }
        
        let textAttachment = NSTextAttachment()
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        textAttachment.image = image
        let oldWidth:CGFloat = textAttachment.image!.size.width
        let scaleFactor:CGFloat = oldWidth/(messageText.frame.size.width-50)
        
        textAttachment.image = UIImage.init(cgImage: (textAttachment.image?.cgImage)!, scale: scaleFactor, orientation: .up)
       
        let attrStringWithImage = NSAttributedString(attachment: textAttachment)
        attributedString.append(attrStringWithImage)
        messageText.attributedText = attributedString
        print(messageText)
        self.dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
    

