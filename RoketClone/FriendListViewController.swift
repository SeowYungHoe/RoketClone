//
//  FriendListViewController.swift
//  RoketClone
//
//  Created by Seow Yung Hoe on 18/03/2017.
//  Copyright © 2017 Seow Yung Hoe. All rights reserved.
//

import UIKit
import Firebase

class FriendListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    @IBOutlet weak var friendListTableView: UITableView!

    var users: [Users] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.friendListTableView.delegate = self
        self.friendListTableView.dataSource = self
        
        fetchAllFriends()

    }
    
    func fetchAllFriends(){
        
        
        let ref = FIRDatabase.database().reference()
        
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("user").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            
            guard let snapValues = snapshot.value as? NSDictionary else { return }
            
         
            var tempUsers : [Users] = []
            for (_, value) in snapValues {
                
                
                if let postDictionary = value as? [String: Any] {
                    
                    let newPost = Users(withDictionary: postDictionary)
                    
                 
                        
                    tempUsers.append(newPost)
                }
            }
            
            self.users = tempUsers
//            for userPost in self.users {
//                
//                
//                
//                
//            }
            
            self.users = tempUsers
            self.friendListTableView.reloadData()

            
        })
        
    }

    //---------------------TableView---------------------
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = friendListTableView.dequeueReusableCell(withIdentifier: "friendCell", for: indexPath) as! FriendCell
        
        cell.usernameLabel.text = users[indexPath.row].username
        cell.userID = users[indexPath.row].userID
        cell.profilePictureImageView.downloadImage(from: users[indexPath.row].profilePicture)
        checkFollowing(indexPath: indexPath)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        let key = ref.child("user").childByAutoId().key
        
        var isFollower = false
        
        ref.child("user").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in

            //Unfollow
            if let following = snapshot.value as? [String : AnyObject]{
                for(ke, value) in following {
                    if value as! String == self.users[indexPath.row].userID {
                        isFollower = true
                        
                        //Unfollow
                        
     ref.child("user").child(uid!).child("following/\(ke)").removeValue()
                        ref.child("user").child(self.users[indexPath.row].userID!).child("followers/\(ke)").removeValue()
                        
                        self.friendListTableView.cellForRow(at: indexPath)?.accessoryType = .none
                    }
                }
                
                
                
            }
            
            if !isFollower {
                let following = ["following/\(key)" : self.users[indexPath.row].userID]
                let followers = ["followers/\(key)" : uid]
                
                ref.child("user").child(uid!).updateChildValues(following)
                ref.child("user").child(self.users[indexPath.row].userID!).updateChildValues(followers)
                
                self.friendListTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark

            }
        })
        
        ref.removeAllObservers()
        
    }
    
    func checkFollowing(indexPath: IndexPath){
        let ref = FIRDatabase.database().reference()
        let uid = FIRAuth.auth()?.currentUser?.uid
        
        ref.child("user").child(uid!).child("following").queryOrderedByKey().observeSingleEvent(of: .value, with: { snapshot in
            
            if let following = snapshot.value as? [String : AnyObject]{
                for(ke, value) in following {
                    if value as! String == self.users[indexPath.row].userID {
                        self.friendListTableView.cellForRow(at: indexPath)?.accessoryType = .checkmark
                    }
                    
                }
            }
        })
        ref.removeAllObservers()
    }
    
   
}


extension UIImageView {
    
    func downloadImage(from imgURL: String!){
        let url = URLRequest(url: URL(string: imgURL)!)
        let task = URLSession.shared.dataTask(with: url) {
            (data, response, error) in
            
            if error != nil {
                print(error!)
                return
            }
            DispatchQueue.main.async {
                self.image = UIImage(data: data!)
            }
        }
        
        task.resume()
    }
}
