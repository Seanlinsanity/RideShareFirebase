//
//  HomeController_TableView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase
import MapKit

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMapResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchTableViewCell
        let mapItem = searchMapResults[indexPath.row]
        cell.locationLabel.text = mapItem.name
        cell.addressLabel.text = mapItem.placemark.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem = searchMapResults[indexPath.row]
        searchTextField.text = mapItem.name
        view.endEditing(true)
        dismissTableView()
        handleDismissKeyBoard()
        presentLoadingView()
        //addPassengerAnnotation()
        addDestinationAnnotation(mapItem: mapItem)
        addDesitinationInFirebase(mapItem: mapItem)
        searchMapKitForRoute(mapItem: mapItem)
    }
    
    func dismissTableView(){
        tableViewHeightAnchor.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    private func addPassengerAnnotation(){
        guard let uid = Auth.auth().currentUser?.uid, let coordinate = locationManager.location?.coordinate else { return }
        let passengerAnnotation = PassengerAnnotation(coordinate: coordinate, title: uid)
        mapView.addAnnotation(passengerAnnotation)
        
    }
    
    private func addDestinationAnnotation(mapItem: MKMapItem){
        
        if let destinationAnnotation = self.mapView.annotations.first(where: {$0 is MKPointAnnotation}) {
            mapView.removeAnnotation(destinationAnnotation)
        }

        let annotation = MKPointAnnotation()
        annotation.coordinate = mapItem.placemark.coordinate
        mapView.addAnnotation(annotation)
        
    }
    
    func addDesitinationInFirebase(mapItem: MKMapItem){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).updateChildValues(["tripCoordinate": [mapItem.placemark.coordinate.latitude, mapItem.placemark.coordinate.longitude]])
    }
}
