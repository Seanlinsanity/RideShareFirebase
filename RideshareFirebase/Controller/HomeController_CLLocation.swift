//
//  HomeController_CLLocation.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/31.
//  Copyright © 2018 SEAN. All rights reserved.
//

import Foundation
import CoreLocation

extension HomeViewController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        if status == .authorizedAlways || status == .authorizedWhenInUse {
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            centerMapOnUserLocation()
        }
    }
    
    
}
