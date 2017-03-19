//
//  Users.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 19/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import Foundation

class Users {
    
    var username : String?
    var profilePicture : String?
    var userID : String?
    
    
    init(withDictionary dictionary: [String:Any]) {
        
        username = dictionary["username"] as? String
        userID = dictionary["userID"] as? String
        profilePicture = dictionary["profilePicture"] as? String
        
    }
}
