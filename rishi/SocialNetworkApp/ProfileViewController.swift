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
    
    @IBAction func didTapLogout(_ sender: Any) {
        
        try! FIRAuth.auth()!.signOut()
        
        let mainStoryboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let welcomeViewController: UIViewController = mainStoryboard.instantiateViewController(withIdentifier: "welcomeViewController")
        self.present(welcomeViewController, animated: true, completion: nil)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.loggedInUser = FIRAuth.auth()?.currentUser
        
        self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).observeSingleEvent(of: .value) { (snapshot: FIRDataSnapshot) in
        
            let snapshot = snapshot.value as AnyObject
            
            self.name.text = snapshot.value(forKey: "name") as? String
            
            self.handle.text = snapshot.value(forKey: "handle") as? String
       
            
            if (snapshot.value(forKey: "about") != nil){
                
                self.about.text = snapshot.value(forKey: "about") as? String
                print("ABOUT: ", self.about.text!)
            }
            
            if (snapshot.value(forKey: "profile_pic") != nil){
              
                let databaseProfilePic = snapshot.value(forKey: "profile_pic")! as! String
                let data = NSData(contentsOf: NSURL(string: databaseProfilePic)! as URL)
                self.setProfilePicture(imageView: self.profilePicture, imageToSet: UIImage(data:data! as Data)!)
            }
            
        }
  
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.imageTapped(gesture:)))
        profilePicture.addGestureRecognizer(tapGesture)
        profilePicture.isUserInteractionEnabled = true
        
    }
    
    func setProfilePicture(imageView: UIImageView, imageToSet: UIImage){
        
        imageView.layer.cornerRadius = 10.0
        imageView.layer.borderColor = (UIColor.white as! CGColor)
        imageView.layer.masksToBounds = true
        imageView.image = imageToSet
    }
    
    
    func dismissFullScreenImage(sender: UITapGestureRecognizer){
        sender.view?.removeFromSuperview()
    }
    
    func imageTapped(gesture: UIGestureRecognizer) {
    
        if (gesture.view as? UIImageView) != nil {
            print("Image Tapped")
            
            let actionSheet = UIAlertController(title: "Profile picture", message: "Select", preferredStyle: .actionSheet)
            
            let viewPicture = UIAlertAction(title: "View Photo", style: .default, handler: { (action:UIAlertAction) in
                
                let imageView = gesture.view as! UIImageView
                let newImageView = UIImageView(image: imageView.image)
                newImageView.frame = self.view.frame
                newImageView.backgroundColor = UIColor.black
                newImageView.contentMode = .scaleAspectFit
                newImageView.isUserInteractionEnabled = true
                
                let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
                newImageView.addGestureRecognizer(tap)
                
                self.view.addSubview(newImageView)
            })
            
            
            let photoGallery = UIAlertAction(title: "Photos", style: .default, handler: { (action:UIAlertAction) in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
                    
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            })
            
            let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
                
                if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
                    
                    self.imagePicker.delegate = self
                    self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
                    self.imagePicker.allowsEditing = true
                    self.present(self.imagePicker, animated: true, completion: nil)
                }
            })
            
            actionSheet.addAction(viewPicture)
            actionSheet.addAction(photoGallery)
            actionSheet.addAction(camera)
            
            actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
            self.present(actionSheet, animated: true, completion: nil)
            
        }
    
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        let image = info[UIImagePickerControllerOriginalImage] as! UIImage
        setProfilePicture(imageView: self.profilePicture, imageToSet: image)
        
        if let imageData: NSData = UIImagePNGRepresentation(self.profilePicture.image!)! as NSData {
        
            let profilePicStorageRef = storageRef.child("user_profiles/\(self.loggedInUser!.uid!)/profile_pic")
            
            let uploadTask = profilePicStorageRef.put(imageData as Data, metadata: nil)
            {metadata, error in
            
                if (error == nil){
                
                    let downloadURL = metadata!.downloadURL()
                    self.databaseRef.child("user_profiles").child(self.loggedInUser!.uid!).child("profile_pic").setValue(downloadURL!.absoluteString)
                
                }
                else {
                
                    print(error?.localizedDescription as Any)
                }
            }
        self.dismiss(animated: true, completion: nil)
        
    
    }
    
//    @IBAction func didTapProfilePicture(_ sender: UITapGestureRecognizer) {
//        
//        print("DID TAP PP")
//        let actionSheet = UIAlertController(title: "Profile picture", message: "Select", preferredStyle: .actionSheet)
//        
//        let viewPicture = UIAlertAction(title: "View Photo", style: .default, handler: { (action:UIAlertAction) in
//            
//            let imageView = sender.view as! UIImageView
//            let newImageView = UIImageView(image: imageView.image)
//            newImageView.frame = self.view.frame
//            newImageView.backgroundColor = UIColor.black
//            newImageView.contentMode = .scaleAspectFit
//            newImageView.isUserInteractionEnabled = true
//            
//            let tap = UITapGestureRecognizer(target: self, action: #selector(self.dismissFullScreenImage))
//            newImageView.addGestureRecognizer(tap)
//            
//            self.view.addSubview(newImageView)
//        })
//        
//        
//        let photoGallery = UIAlertAction(title: "Photos", style: .default, handler: { (action:UIAlertAction) in
//            
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.savedPhotosAlbum) {
//                
//                self.imagePicker.delegate = self
//                self.imagePicker.sourceType = UIImagePickerControllerSourceType.savedPhotosAlbum
//                self.imagePicker.allowsEditing = true
//                self.present(self.imagePicker, animated: true, completion: nil)
//            }
//        })
//        
//        let camera = UIAlertAction(title: "Camera", style: .default, handler: { (action:UIAlertAction) in
//            
//            if UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.camera) {
//                
//                self.imagePicker.delegate = self
//                self.imagePicker.sourceType = UIImagePickerControllerSourceType.camera
//                self.imagePicker.allowsEditing = true
//                self.present(self.imagePicker, animated: true, completion: nil)
//            }
//        })
//        
//        actionSheet.addAction(viewPicture)
//        actionSheet.addAction(photoGallery)
//        actionSheet.addAction(camera)
//        
//        actionSheet.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.cancel, handler: nil))
//        self.present(actionSheet, animated: true, completion: nil)
//        
//        
//    }

    func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    }
}
