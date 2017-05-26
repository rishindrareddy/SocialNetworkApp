
//
//  ProfileViewController.swift
//  SocialNetworkApp
//
//  Created by Siddhi Suthar on 5/22/17.
//  Copyright © 2017 Siddhi. All rights reserved.
//

import UIKit
import FirebaseAuth
import Firebase
import FirebaseStorage
import FirebaseDatabase

class ProfileViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

 
    
    @IBOutlet weak var postsContainer: UIView!
    @IBOutlet weak var about: UITextField!
    @IBOutlet weak var handle: UILabel!
    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var profilePicture: UIImageView!
    
    var imagePicker = UIImagePickerController()
    var loggedInUser: AnyObject? = .none
    var databaseRef = FIRDatabase.database().reference()
    var storageRef = FIRStorage.storage().reference()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.loggedInUser = FIRAuth.auth()?.currentUser
        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
        
            let snapshot = snapshot.value as AnyObject
            self.name.text = snapshot.value(forKey: "name") as? String
            self.handle.text = snapshot.value(forKey: "handle") as? String
       
            if (snapshot.value(forKey: "about") != nil){
                self.about.text = snapshot.value(forKey: "about") as? String
            }
            
            if (snapshot.value(forKey: "profile_pic") != nil){
                let databaseProfilePic = snapshot.value(forKey: "profile_pic")! as! String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL)
                self.setProfilePicture(imageView: self.profilePicture, imageToSet: UIImage(data:data! as Data)!)
            }
            
            
        }
  
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.didTapProfilePicture))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        
    }
    
     func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
        
        print("TAPPED: ")
        
        let myActionSheet = UIAlertController(title:"Profile Picture",message:"Select",preferredStyle: UIAlertControllerStyle.actionSheet)
        
        let viewPicture = UIAlertAction(title: "View Picture", style: UIAlertActionStyle.default) { (action) in
            
            let imageView = sender.view as! UIImageView
            let newImageView = UIImageView(image: imageView.image)
            
            newImageView.frame = self.view.frame
            
            newImageView.backgroundColor = UIColor.black
            newImageView.contentMode = .scaleAspectFit
            newImageView.isUserInteractionEnabled = true
            
            let tap = UITapGestureRecognizer(target:self,action:#selector(self.dismissFullScreenImage))
            
            newImageView.addGestureRecognizer(tap)
            self.view.addSubview(newImageView)
        }
        
        let photoGallery = UIAlertAction(title: "Photos", style: UIAlertActionStyle.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.savedPhotosAlbum)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                self.imagePicker.allowsEditing = true
                self.present(self.imagePicker, animated: true
                    , completion: nil)
            }
        }
        
        let camera = UIAlertAction(title: "Camera", style: UIAlertActionStyle.default) { (action) in
            
            if UIImagePickerController.isSourceTypeAvailable( UIImagePickerControllerSourceType.camera)
            {
                self.imagePicker.delegate = self
                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                self.imagePicker.allowsEditing = true
                
                self.present(self.imagePicker, animated: true, completion: nil)
            }
        }
        
        myActionSheet.addAction(viewPicture)
        myActionSheet.addAction(photoGallery)
        myActionSheet.addAction(camera)
        
        myActionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
        
        self.present(myActionSheet, animated: true, completion: nil)
        
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingImage image: UIImage, editingInfo: [String : AnyObject]?) {
        
        //let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        setProfilePicture(imageView: self.profilePicture,imageToSet: image as! UIImage)
        
        if let imageData: Data = UIImagePNGRepresentation(self.profilePicture.image!)!
        {
            
            let profilePicStorageRef = storageRef.child("user_profiles/\(self.loggedInUser!.uid)/profile_pic")
            
            let uploadTask = profilePicStorageRef.put(imageData, metadata: nil)
            {metadata,error in
                
                if(error == nil)
                {
                    let downloadUrl = metadata!.downloadURL()
                    
                    self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid).child("profile_pic").setValue(downloadUrl!.absoluteString)
                }
                else
                {
                    print(error?.localizedDescription)
                }
                
            }
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }

    
    func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = (UIColor.white as! CGColor)
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func dismissFullScreenImage(sender: UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    @IBAction func didTapLogout(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "welcomeViewController")
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    }
    
    
    

