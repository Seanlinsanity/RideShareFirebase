//
//  PassengerAnnotation.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PassengerAnnotation: NSObject, MKAnnotation{
    dynamic var coordinate: CLLocationCoordinate2D
    var title: String?
    
    init(coordinate: CLLocationCoordinate2D, title: String) {
        self.coordinate = coordinate
        self.title = title
        
        super.init()
    }
    
}
