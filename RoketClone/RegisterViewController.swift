//
//  RegisterViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage

class RegisterViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    
     //----------------------Outlets----------------
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var profilePictureImageView: UIImageView!
   
    @IBOutlet weak var chooseProfilePictureButton: UIButton!{
        didSet{
            chooseProfilePictureButton.addTarget(self, action: #selector(displayImagePickerGallery), for: .touchUpInside)
        }
    }
    
    
    @IBOutlet weak var signUpbutton: UIButton!{
        didSet{
            signUpbutton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    }
    
    
    
    var picker = UIImagePickerController()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        picker.delegate = self
        
    }

//-----------------------------Functions--------------------
    
    func signUp() {
        
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
//        let displayPic = profilePictureImageView

        
        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: {(user,error) in
            
            if error != nil {
                print(error! as NSError)
                self.failToSignUpAlert(errorMessage: "Email/Password is invalid")
                
                return
            }

            
            let values = ["username": username, "email": email, "userID": uid]
            self.signUpSuccessful(errorMessage: "Sign up success!")
            ref.child("user").child(user!.uid).updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil {
                    print("error")
                    return
                }
            })
        })
        
    }
    
    func failToSignUpAlert(errorMessage:String){
        
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
    }
    
    func signUpSuccessful(errorMessage:String){
        
        let alert = UIAlertController(title: "Success", message: errorMessage, preferredStyle: .alert)
        
        
        let okAction = UIAlertAction(title: "OK", style: .default, handler: { _ -> Void in
            
            
            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "MainNavi") as? UINavigationController
            
            self.navigationController?.present(controller!, animated: true, completion: nil)
            
            
//            let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
//            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
//            
//            self.navigationController?.present(controller, animated: true, completion: nil)
        })
        
        
        alert.addAction(okAction)
        present(alert, animated:true, completion: nil)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }
    
    //-----------------------------------Image-----------------------------
    
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
