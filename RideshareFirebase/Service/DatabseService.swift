//
//  UpdateService.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/1.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class DatabaseService {
    static let shareInstance = DatabaseService()
    
    func updateUserLocation(coordinate: CLLocationCoordinate2D) {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let value = [ "coordinate": [coordinate.latitude, coordinate.longitude] ]
    
        Database.database().reference().child("users").child(uid).updateChildValues(value) { (error, ref) in
            if error != nil {
                print(error!)
                return
            }
        }
        
        Database.database().reference().child("drivers").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            if snapshot.exists() {
                Database.database().reference().child("drivers").child(uid).updateChildValues(value)
            }
        }, withCancel: nil)
    }
    
}

