//
//  HomeController_CLLocation.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/31.
//  Copyright © 2018 SEAN. All rights reserved.
//

import Foundation
import CoreLocation
import MapKit

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthStatus()
    }
    
    
}

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMapOnUserLocation()
        updateUserLocationInDatabase()
    }
    
    func updateUserLocationInDatabase(){
        DatabaseService.shareInstance.updateUserLocation(coordinate: mapView.userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is DriverAnnotation {
            let identifier = "driver"
            let mkAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            mkAnnotationView.image = #imageLiteral(resourceName: "driverAnnotation")
            return mkAnnotationView
        }else{
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, regionWillChangeAnimated animated: Bool) {
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.centerButton.alpha = 1
        }, completion: nil)
    }
    
    func searchLocation(){
        searchMapResults.removeAll()
        
        let request = MKLocalSearchRequest()
        guard let searchText = searchTextField.text else { return }
        request.naturalLanguageQuery = searchText
        request.region = mapView.region
        
        MKLocalSearch(request: request).start { (response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let response = response else { return }
            self.searchMapResults = response.mapItems
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
            
        }
    }
    
}











