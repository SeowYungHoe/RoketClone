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

class RegisterViewController: UIViewController {

    
     //----------------------Outlets----------------
    @IBOutlet weak var usernameTextField: UITextField!

    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
   
    @IBOutlet weak var signUpbutton: UIButton!{
        didSet{
            signUpbutton.addTarget(self, action: #selector(signUp), for: .touchUpInside)
        }
    }
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

//-----------------------------Functions--------------------
    
    func signUp() {
        
        let username = usernameTextField.text
        let email = emailTextField.text
        let password = passwordTextField.text
        let ref = FIRDatabase.database().reference()

        FIRAuth.auth()?.createUser(withEmail: email!, password: password!, completion: {(user,error) in
            
            if error != nil {
                print(error! as NSError)
                self.failToSignUpAlert(errorMessage: "Email/Password is invalid")
                
                return
            }
            
            let values = ["username": username, "email": email]
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
            let controller = storyboard.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
            
            self.navigationController?.present(controller, animated: true, completion: nil)
        })
        
        
        alert.addAction(okAction)
        present(alert, animated:true, completion: nil)
    }

    func dismissKeyboard() {
        view.endEditing(true)
    }

}
