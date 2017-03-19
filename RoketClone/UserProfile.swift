//
//  UserProfile.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 18/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import Foundation

class UserProfile {
    
    
    
    var username : String?
    var profilePicture : URL?
    var userID : String?
    
    init(withDictionary dictionary: [String:Any]) {
        
        username = dictionary["username"] as? String
        userID = dictionary["userID"] as? String
        
        
        if let pictureURL = dictionary["profilePicture"] as? String {
            
            profilePicture = URL(string: pictureURL)
            
        }
        
    }
    
    
}
