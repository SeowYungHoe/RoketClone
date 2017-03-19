//
//  LoginViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {

    //---------------------Outlets--------------------
    
    @IBOutlet weak var emailTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    
    @IBOutlet weak var registerButton: UIButton!{
        didSet{
            registerButton.addTarget(self, action: #selector(pushToRegisterPage), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var loginButton: UIButton!{
        didSet{
            loginButton.addTarget(self, action: #selector(whenClickedLoginButton), for: .touchUpInside)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }


    func pushToRegisterPage() {
        
    let controller = UIStoryboard(name: "Main", bundle: Bundle.main).instantiateViewController(withIdentifier: "RegisterViewController")
        navigationController?.pushViewController(controller, animated: true)
    }
    
    func whenClickedLoginButton() {
        
        FIRAuth.auth()?.signIn(withEmail: emailTextField.text!, password: passwordTextField.text!, completion: { (user,error) in
            
            if error != nil {
                
                print(error! as NSError)
                self.showErrorAlert(errorMessage: "Email/Password Incorrect")
                return
            }
            
            
            let storyboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
            let controller = storyboard.instantiateViewController(withIdentifier: "HomePageViewController") as! HomePageViewController
            let navController = UINavigationController(rootViewController: controller)
            self.present(navController, animated:true, completion: nil)
            
//            let storyboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
//            let controller = storyboard.instantiateViewController(withIdentifier: "MainPageNavi") as? UINavigationController
//
//            self.navigationController?.present(controller!, animated: true, completion: nil)
        
    })
    
    }
    
    
    func showErrorAlert(errorMessage: String){
        let alert = UIAlertController(title: "Error", message: errorMessage, preferredStyle:  .alert)
        let okAction = UIAlertAction(title: "OK", style: .default, handler: nil)
        alert.addAction(okAction)
        
        present(alert, animated:true, completion: nil)
    }
}



