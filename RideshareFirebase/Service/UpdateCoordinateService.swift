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

class UpdateCoordinateService {
    static let shareInstance = UpdateCoordinateService()
    
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
    
    func updateTripRequest() {
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value) { (snapshot) in
            guard let userDict = snapshot.value as? [String: Any] else { return }
            guard let userType = userDict["type"] as? String else { return }
            guard let name = userDict["name"] as? String else { return }
            if userType == "Driver" { return }
            
            guard let pickupCoordinate = userDict["coordinate"] as? NSArray else { return }
            guard let destinationCoordinate = userDict["tripCoordinate"] as? NSArray else { return }
            
            let ref = Database.database().reference().child("trips").childByAutoId()
            let value = ["id": ref.key, "pickupCoordinate": pickupCoordinate, "destinationCoordinate": destinationCoordinate, "passengerId": uid, "name": name, "tripIsAccepted": false] as [String : Any]
            ref.updateChildValues(value)
            
        }
        
        
    }
    
}

