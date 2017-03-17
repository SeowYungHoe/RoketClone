//
//  ProfileViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit

class ProfileViewController: UIViewController {

    
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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

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
