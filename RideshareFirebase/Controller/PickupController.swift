//
//  PickupController.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/29.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation

class PickupController: UIViewController {
    
    var pickupCoordinate: CLLocationCoordinate2D?
    var tripKey: String?
    var destinationCoordinate: CLLocationCoordinate2D?
    var driverCoordinate: CLLocationCoordinate2D?
    var passengerName: String?{
        didSet{
            passengerNameLabel.text = passengerName
        }
    }
    
    let regionRadius: CLLocationDistance = 1000
    
    lazy var mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        mapView.layer.cornerRadius = (self.view.frame.width - 32) / 2
        return mapView
    }()
    
    let pickupDistanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return lb
    }()
    
    
    let tripDistanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 20, weight: .semibold)
        return lb
    }()
    
    let passengerNameLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 30)
        return lb
    }()
    
    init(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D,tripKey: String) {
        self.pickupCoordinate = pickupCoordinate
        self.destinationCoordinate = destinationCoordinate
        self.tripKey = tripKey

        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        UIApplication.shared.statusBarStyle = .default
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .darkGray

        setupMapView()
        
        UIApplication.shared.statusBarStyle = .lightContent
        
        setupNavigationBar()
        setupTripInfo()
    }
    
    private func setupTripInfo(){
        
        let destinationCL = CLLocation(latitude: destinationCoordinate!.latitude, longitude: destinationCoordinate!.longitude)
        let pickupCL = CLLocation(latitude: pickupCoordinate!.latitude, longitude: pickupCoordinate!.longitude)
        let userCL = CLLocation(latitude: driverCoordinate!.latitude, longitude: driverCoordinate!.longitude)
        let tripDistance = pickupCL.distance(from: destinationCL) / 1000
        let pickupDistance = pickupCL.distance(from: userCL) / 1000

        pickupDistanceLabel.text = "乘客距離您      \(String(format: "%.2f", pickupDistance))公里 "
        view.addSubview(pickupDistanceLabel)
        pickupDistanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickupDistanceLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 32).isActive = true
        pickupDistanceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        pickupDistanceLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        tripDistanceLabel.text = "此趟行程      \(String(format: "%.2f", tripDistance))公里 "
        view.addSubview(tripDistanceLabel)
        tripDistanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tripDistanceLabel.topAnchor.constraint(equalTo: pickupDistanceLabel.bottomAnchor, constant: 8).isActive = true
        tripDistanceLabel.widthAnchor.constraint(equalTo: pickupDistanceLabel.widthAnchor).isActive = true
        tripDistanceLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        view.addSubview(passengerNameLabel)
        passengerNameLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        passengerNameLabel.topAnchor.constraint(equalTo: tripDistanceLabel.bottomAnchor, constant: 16).isActive = true
        passengerNameLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        passengerNameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    private func setupMapView(){
        mapView.delegate = self

        view.addSubview(mapView)
        mapView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        mapView.topAnchor.constraint(equalTo: view.topAnchor, constant: 64).isActive = true
        mapView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        mapView.heightAnchor.constraint(equalTo: mapView.widthAnchor).isActive = true
        
        dropPickupAnnotaionInMap()
        centerMapOnLocation()
    }
    
    private func setupNavigationBar(){
        
        navigationController?.navigationBar.barTintColor = .black
        navigationController?.navigationBar.isTranslucent = false
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "取消", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "接受", style: .plain, target: self, action: #selector(handleCancel))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
}

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













