//
//  PickupController_MapView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/30.
//  Copyright © 2018 SEAN. All rights reserved.
//

import Foundation
import MapKit

extension PickupController: MKMapViewDelegate {
    
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
    
        if annotation is DriverAnnotation {
            let identifier = "driver"
            var driverAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if driverAnnotation != nil {
                driverAnnotation?.annotation = annotation
            }else{
                driverAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            driverAnnotation?.image = #imageLiteral(resourceName: "driverAnnotation")
            return driverAnnotation
        }else{
            let identifier = "pickupPoint"
            var pickupAnnotation = mapView.dequeueReusableAnnotationView(withIdentifier: identifier)
            if pickupAnnotation != nil {
                pickupAnnotation?.annotation = annotation
            }else{
                pickupAnnotation = MKAnnotationView(annotation: annotation, reuseIdentifier: identifier)
            }
            pickupAnnotation?.image = #imageLiteral(resourceName: "passenger")
            return pickupAnnotation
        }
    
    }
    
    func centerMapOnLocation() {
        let pickupPlacemark = MKPlacemark(coordinate: pickupCoordinate!)
        let region = MKCoordinateRegionMakeWithDistance(pickupPlacemark.location!.coordinate, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
        
//        let centerLatitude = (pickupCoordinate!.latitude + mapView.userLocation.coordinate.latitude) * 0.5
//        let centerLongitude = (pickupCoordinate!.longitude + mapView.userLocation.coordinate.longitude) * 0.5
//        let center = CLLocationCoordinate2DMake(centerLatitude, centerLongitude)
//        let latitudeDelta = max(abs(mapView.userLocation.coordinate.latitude - centerLatitude), abs(pickupCoordinate!.latitude - centerLatitude)) * 2
//        let longitudeDelta = max(abs(mapView.userLocation.coordinate.longitude - centerLongitude), abs(pickupCoordinate!.longitude - centerLongitude)) * 2
//        let span = MKCoordinateSpan(latitudeDelta: latitudeDelta, longitudeDelta: longitudeDelta)
//
//        var region = MKCoordinateRegion(center: center, span: span)
//        region = mapView.regionThatFits(region)
//        mapView.setRegion(region, animated: true)
    }
    
    func dropPickupAnnotaionInMap() {
        
        mapView.annotations.forEach { (annotation) in
            mapView.removeAnnotation(annotation)
        }
        
        let pickupAnnotation = MKPointAnnotation()
        let pickupPlacemark = MKPlacemark(coordinate: pickupCoordinate!)
        pickupAnnotation.coordinate = pickupPlacemark.coordinate
        mapView.addAnnotation(pickupAnnotation)
        
        let driverUserAnnotation = DriverAnnotation(coordinate: driverCoordinate!, title: "driverUser")
        mapView.addAnnotation(driverUserAnnotation)

        
    }
}
