//
//  DriverAnnotation.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/1.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class DriverAnnotation: NSObject, MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }
    
    func update(coordinate: CLLocationCoordinate2D) {
        
        UIView.animate(withDuration: 0.2) {
            self.coordinate.latitude = coordinate.latitude
            self.coordinate.longitude = coordinate.longitude
        }
    }
    
    
}
