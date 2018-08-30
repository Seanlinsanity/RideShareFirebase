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
    
    func centerMapOnLocation() {
        let pickupPlacemark = MKPlacemark(coordinate: pickupCoordinate!)
        let region = MKCoordinateRegionMakeWithDistance(pickupPlacemark.location!.coordinate, regionRadius, regionRadius)
        mapView.setRegion(region, animated: true)
    }
    
    func dropPickupAnnotaionInMap() {
        
        mapView.annotations.forEach { (annotation) in
            mapView.removeAnnotation(annotation)
        }
        
        let pickupAnnotation = MKPointAnnotation()
        let pickupPlacemark = MKPlacemark(coordinate: pickupCoordinate!)
        pickupAnnotation.coordinate = pickupPlacemark.coordinate
        mapView.addAnnotation(pickupAnnotation)
        
    }
}
