//
//  HomeController_Driver.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/30.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase
import CoreLocation

extension HomeController {
    
    func observeTrips(){
        Database.database().reference().child("trips").observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            guard let tripDict = snapshot.value as? [String: Any] else { return }
            guard let pickupCoordinate = tripDict["pickupCoordinate"] as? NSArray, let destinationCoordinate = tripDict["destinationCoordinate"] as? NSArray, let isAccepted = tripDict["tripIsAccepted"] as? Bool, let name = tripDict["name"] as? String else { return }
            if isAccepted { return }
            
            let pickupLocation = CLLocationCoordinate2D(latitude: pickupCoordinate[0] as! CLLocationDegrees, longitude: pickupCoordinate[1] as! CLLocationDegrees)
            let destinationLocation = CLLocationCoordinate2D(latitude: destinationCoordinate[0] as! CLLocationDegrees, longitude: destinationCoordinate[1] as! CLLocationDegrees)
            
            let pickupController = PickupController(pickupCoordinate: pickupLocation, destinationCoordinate: destinationLocation, tripKey: snapshot.key)
            pickupController.driverCoordinate = self.mapView.userLocation.coordinate
            pickupController.passengerName = name
            let navController = UINavigationController(rootViewController: pickupController)
            self.present(navController, animated: true, completion: nil)
            
        }, withCancel: nil)
    }
}
