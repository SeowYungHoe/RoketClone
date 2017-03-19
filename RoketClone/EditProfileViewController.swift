//
//  EditProfileViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseStorage
import FirebaseDatabase
import Firebase
import Photos

class EditProfileViewController: UIViewController, UIImagePickerControllerDelegate,
UINavigationControllerDelegate{

    //----------------------------------Outlets-------------------------------
    @IBOutlet weak var profilePictureImageView: UIImageView!
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var changeProfilePictureButton: UIButton!{
        didSet{
            changeProfilePictureButton.addTarget(self, action: #selector(displayImagePickerGallery), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var confirmButton: UIButton!{
        didSet{
            confirmButton.addTarget(self, action: #selector(confirmClicked), for: .touchUpInside)
        }
    }
    
    
    //---------------Constant and variable---------------
    var picker = UIImagePickerController()
    var displayUserProfilePicture = String()
    var displayUserName = String()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        fetchUserInformation()
        picker.delegate = self
    }
    
    //---------------------------------------Functions-------------------------------------
    
    func confirmClicked() {
        
        
    guard let username = usernameTextField.text else {return}
    
    
    let uid = FIRAuth.auth()?.currentUser?.uid
    let ref = FIRDatabase.database().reference()
    let value = ["username": username, "userID": uid] as [String : Any]
        
    
    ref.child("user").child(uid!).updateChildValues(value, withCompletionBlock: { (err, ref) in
    
    if err != nil {
    
    print("err")
    
    return
    
    
    }
    })
    
}
    
    //--------------------------Fetching--------------------------
    
    func fetchUserInformation () {
        
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("user").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let value = snapshot.value as? NSDictionary else {return}
            
            let displayName = value["username"] as? String
            
            if let displayPicture = value["profilePicture"] as? String{
                self.profilePictureImageView.downloadImage(from: displayPicture)
            }
            
            
         
            
            self.displayUserName = displayName!
            self.usernameTextField.text = self.displayUserName
            
 
        })
        
    }


    //-------------------------------------ImagePicker--------------------------------------------

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        
        if let editedImage = info[UIImagePickerControllerEditedImage] as? UIImage{
            
            print(editedImage)
            uploadImageToStorage(image: editedImage)
            self.profilePictureImageView.image = editedImage
            
            
        }else if let originalImage = info[UIImagePickerControllerOriginalImage] as? UIImage{
            
            print(originalImage)
            uploadImageToStorage(image: originalImage)
            self.profilePictureImageView.image = originalImage
            
            
        }
        
//        dismiss(animated: true, completion: nil)
        
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)

    }
    
    func displayImagePickerGallery(){
        
        picker.allowsEditing = true
        picker.sourceType = .photoLibrary
        self.present(picker, animated: true, completion: nil)
        picker.delegate = self
        picker.allowsEditing = true

        
    }
    
    

    
    //-----------------------Profile Picture Related------------------------------------------
    
    func uploadImageToStorage(image: UIImage) {
        
      
        
        guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
        
        let storageRef = FIRStorage.storage().reference()
        let metadata = FIRStorageMetadata()
        metadata.contentType = "image/jpeg"
        
        let timeStamp = Date.timeIntervalSinceReferenceDate
        let storageNaming = (" \(timeStamp)")
        
        storageRef.child("ProfilePicture").child("\(storageNaming).jpeg").put(imageData, metadata: nil) { (meta,error) in
            
            if error != nil {
                                
                return
                
            }
            
            if  let downloadURL = meta?.downloadURL() {
                
                print(downloadURL)
                
                let uid = FIRAuth.auth()?.currentUser?.uid
                let ref = FIRDatabase.database().reference()
                
                ref.child("user").child(uid!).updateChildValues(["profilePicture":downloadURL.absoluteString])
                
            }
            
        }
        
        self.dismiss(animated: true, completion: nil)
        
    }


}
