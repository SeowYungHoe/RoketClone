//
//  HomePageViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 17/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit

class HomePageViewController: UIViewController {
//--------------------Outlets---------------------
    
 
    @IBOutlet weak var profileButton: UIButton!{
        didSet{
            profileButton.addTarget(self, action: #selector(pushToProfilePage), for: .touchUpInside)

        }
    }
    
    
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    func pushToProfilePage(){
        
        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController") as! ProfileViewController
        let navController = UINavigationController(rootViewController: controller)
        self.present(navController, animated:true, completion: nil)
        
//        let storyboard = UIStoryboard(name: "Profile", bundle: Bundle.main)
//        let controller = storyboard.instantiateViewController(withIdentifier: "ProfileViewController")
//        self.navigationController?.pushViewController(controller, animated: true)
        
        
    }

}
