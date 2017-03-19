//
//  ProfileViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import Firebase



class ProfileViewController: UIViewController {

    //---------------------------Outlets------------------
    @IBOutlet weak var backButton: UIBarButtonItem!{
        didSet{
            backButton.action = #selector(backToHomePage)
            backButton.target = self
        }
    }
    
    @IBOutlet weak var editProfileButton: UIButton!{
        didSet{
            editProfileButton.addTarget(self, action: #selector(goEditProfilePage), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var profilePicture: UIImageView!
    @IBOutlet weak var hiThereLabel: UILabel!
    
    //----------------------------Constants and Variables----------------------------------
    var usersInformation: [UserProfile] = []
    var displayUserProfilePicture = String()
    var displayUserName = String()



    
    override func viewDidLoad() {
        super.viewDidLoad()
    
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        fetchUserInformation()

    }

    //----------------------------Functions-----------------------
    
    func fetchUserInformation () {
        
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("user").child(uid!).observeSingleEvent(of: .value, with: { (snapshot) in
            
            
            guard let value = snapshot.value as? NSDictionary else {return}
            
            let displayName = value["username"] as? String
            
            if let displayPicture = value["profilePicture"] as? String {
                
                self.profilePicture.downloadImage(from: displayPicture)

            }
            
            

            
            self.displayUserName = displayName!
            self.hiThereLabel.text = "Hi There \(self.displayUserName)"
            print(self.displayUserName)

         

        })
        
    }
    
        

    

    
    
    //---------------------------Navigation-----------------------
    func goEditProfilePage() {
 
        
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "EditProfileViewController") as? EditProfileViewController else {return}
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func backToHomePage() {
        
        let storyboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainPageNavi") as? UINavigationController
        
        self.navigationController?.present(controller!, animated: true, completion: nil)
        
    }

}
