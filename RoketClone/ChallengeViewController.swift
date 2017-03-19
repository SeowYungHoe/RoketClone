//
//  ChallengeViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 18/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit

class ChallengeViewController: UIViewController {
    
    @IBOutlet weak var addFriendButton: UIButton!{
        didSet{
            addFriendButton.addTarget(self, action: #selector(pushToAddFriend), for: .touchUpInside)
        }
    }
    
    @IBOutlet weak var backButton: UIBarButtonItem!{
        didSet{
            
            backButton.action = #selector(backToHomePage)
            backButton.target = self
        }
    }

    

    override func viewDidLoad() {
        super.viewDidLoad()

        
    }

    
    //--------------------------------Navigation-----------------------------------------
    func pushToAddFriend(){
        
        let storyboard = UIStoryboard(name: "Friend", bundle: Bundle.main)
        guard let controller = storyboard.instantiateViewController(withIdentifier: "FriendListViewController") as? FriendListViewController else {return}
        
        
        self.navigationController?.pushViewController(controller, animated: true)
    }
    
    func backToHomePage() {
        
        let storyboard = UIStoryboard(name: "MainPage", bundle: Bundle.main)
        let controller = storyboard.instantiateViewController(withIdentifier: "MainPageNavi") as? UINavigationController
        
        self.navigationController?.present(controller!, animated: true, completion: nil)
        
    }

}
