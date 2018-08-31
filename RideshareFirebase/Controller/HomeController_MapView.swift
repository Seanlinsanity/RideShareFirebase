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
import Firebase

extension HomeController: CLLocationManagerDelegate {
    
    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
        checkLocationAuthorization()
    }
    
}

extension HomeController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, didUpdate userLocation: MKUserLocation) {
        centerMapOnUserLocation()
        updateUserLocationInDatabase()
    }
    
    func updateUserLocationInDatabase(){
        UpdateCoordinateService.shareInstance.updateUserLocation(coordinate: mapView.userLocation.coordinate)
    }
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        if annotation is DriverAnnotation {
            let identifier = "driver"
            let mkAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            mkAnnotationView.image = #imageLiteral(resourceName: "driverAnnotation")
            return mkAnnotationView
        }else if annotation is PassengerAnnotation{
            let identifier = "passenger"
            let mkAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            mkAnnotationView.image = #imageLiteral(resourceName: "currentLocationAnnotation")
            return mkAnnotationView
        }else if annotation is MKPointAnnotation {
            let identifier = "destination"
            var mkAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if mkAnnotationView == nil {
                mkAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }else{
                mkAnnotationView?.annotation = annotation
            }
            mkAnnotationView?.image = #imageLiteral(resourceName: "location")
            return mkAnnotationView!
        }else if annotation is TripDriverAnnotation {
            let identifier = "tripDriver"
            var mkAnnotationView = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if mkAnnotationView == nil {
                mkAnnotationView = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }else{
                mkAnnotationView?.annotation = annotation
            }
            mkAnnotationView?.image = #imageLiteral(resourceName: "tripDriver")
            return mkAnnotationView!
        }else{
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        if mapView.overlays.count == 1 {
            let lineRender = MKPolylineRenderer(overlay: overlay)
            lineRender.strokeColor = UIColor.black
            lineRender.lineWidth = 4
            return lineRender
        }else{
            let lineRender = MKPolylineRenderer(overlay: overlay)
            lineRender.strokeColor = UIColor.black
            lineRender.lineWidth = 4
            //        lineRender.lineDashPhase = 2
            lineRender.lineDashPattern = [NSNumber(value: 1),NSNumber(value:5)]
            return lineRender
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
                DispatchQueue.main.async {
                    self.dismissLoadingView()
                }
                return
            }
            guard let response = response else { return }
            self.searchMapResults = response.mapItems
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                self.dismissLoadingView()
            }
            
        }
    }
    
    func searchMapKitForRoute(mapItem: MKMapItem, removeRoutes: Bool){
        
        if removeRoutes{
            mapView.removeOverlays(mapView.overlays)
        }
        
        while (mapView.overlays.count > 1) {
            mapView.remove(mapView.overlays.last!)
        }

        let request = MKDirectionsRequest()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = mapItem
        request.transportType = MKDirectionsTransportType.automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { (response, error) in
            if error != nil {
                print(error!)
                return
            }
            guard let response = response else { return }
            let route = response.routes[0]
            self.mapView.add(route.polyline)
            self.zoomToFitAnnotation()
            self.dismissLoadingView()
        }
        
    }
    
    func removeDestinationAndRoute(){
        mapView.removeOverlays(mapView.overlays)
        if let destinationAnnotation = self.mapView.annotations.first(where: {$0 is MKPointAnnotation}) {
            mapView.removeAnnotation(destinationAnnotation)
        }
        if let passengerAnnotation = self.mapView.annotations.first(where: {$0 is PassengerAnnotation}) {
            mapView.removeAnnotation(passengerAnnotation)
        }
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("users").child(uid).child("tripCoordinate").removeValue()
        
    }
    
    func zoomToFitAnnotation(){
        if mapView.annotations.count == 0 { return }
        
        var topLeftCoordinate = CLLocationCoordinate2D(latitude: -90, longitude: 180)
        var bottomRightCoordinate = CLLocationCoordinate2D(latitude: 90, longitude: -180)
        
        mapView.annotations.filter({!$0.isKind(of: DriverAnnotation.self)}).forEach { (annotation) in
            topLeftCoordinate.longitude = min(topLeftCoordinate.longitude, annotation.coordinate.longitude)
            topLeftCoordinate.latitude = max(topLeftCoordinate.latitude, annotation.coordinate.latitude)
            bottomRightCoordinate.longitude = max(bottomRightCoordinate.longitude, annotation.coordinate.longitude)
            bottomRightCoordinate.latitude = min(bottomRightCoordinate.latitude, annotation.coordinate.latitude)
        }
        
        let centerLatitude = topLeftCoordinate.latitude + (bottomRightCoordinate.latitude - topLeftCoordinate.latitude) * 0.5
        let centerLongitude = topLeftCoordinate.longitude + (bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 0.5
        let center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
        let latitudeDelta = abs(topLeftCoordinate.latitude - bottomRightCoordinate.latitude) * 2
        let longitudeDelta = abs(bottomRightCoordinate.longitude - topLeftCoordinate.longitude) * 2
        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
        
        var region = MKCoordinateRegion(center: center, span: span)
        region = mapView.regionThatFits(region)
        mapView.setRegion(region, animated: true)
    }
}











