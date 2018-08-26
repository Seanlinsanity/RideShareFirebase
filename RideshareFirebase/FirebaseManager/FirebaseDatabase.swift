//
//  FirebaseDatabase.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/30.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase

class FirebaseManager {
    
    class func createUserInDatabase(uid: String, userData: [String: Any]) {
        Database.database().reference().child("users").child(uid).updateChildValues(userData)
    }
    
    class func createDriverInDatabase(uid: String, userData: [String: Any]) {
        Database.database().reference().child("drivers").child(uid).updateChildValues(userData)
    }

}
