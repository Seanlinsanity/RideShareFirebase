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
    
    let addressLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.textAlignment = .center
        lb.font = UIFont.boldSystemFont(ofSize: 24)
        lb.numberOfLines = 0
        return lb
    }()
    
    let pickupDistanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
        return lb
    }()
    
    
    let tripDistanceLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textColor = .white
        lb.textAlignment = .center
        lb.font = UIFont.systemFont(ofSize: 18, weight: .semibold)
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
    
    init(pickupCoordinate: CLLocationCoordinate2D, destinationCoordinate: CLLocationCoordinate2D, tripKey: String) {
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
        fetchPickupAddress()
        setupTripInfo()
    }
    
    private func fetchPickupAddress(){
        let location = CLLocation(latitude: pickupCoordinate!.latitude, longitude: pickupCoordinate!.longitude)
        CLGeocoder().reverseGeocodeLocation(location) { (placemarks, error) in
            if error != nil {
                print(error!)
                return
            }
            
            guard let placemark = placemarks?.first else { return }
            let address = "\(placemark.subThoroughfare!) \(placemark.thoroughfare!), \(placemark.locality!) \(placemark.administrativeArea!), \(placemark.country!)"
            self.addressLabel.text = address
        }
    }
    
    private func setupTripInfo(){
        
        setupTripInfoUI()
        
        let destinationCL = CLLocation(latitude: destinationCoordinate!.latitude, longitude: destinationCoordinate!.longitude)
        let pickupCL = CLLocation(latitude: pickupCoordinate!.latitude, longitude: pickupCoordinate!.longitude)
        let userCL = CLLocation(latitude: driverCoordinate!.latitude, longitude: driverCoordinate!.longitude)
        let tripDistance = pickupCL.distance(from: destinationCL) / 1000
        let pickupDistance = pickupCL.distance(from: userCL) / 1000

        pickupDistanceLabel.text = "乘客距離您      \(String(format: "%.2f", pickupDistance)) km "
        tripDistanceLabel.text = "此趟行程金額      $\(String(format: "%.2f", tripDistance))"
        
    }
    
    private func setupTripInfoUI(){
        
        view.addSubview(addressLabel)
        addressLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: mapView.bottomAnchor, constant: 16).isActive = true
        addressLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        addressLabel.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        view.addSubview(pickupDistanceLabel)
        pickupDistanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        pickupDistanceLabel.topAnchor.constraint(equalTo: addressLabel.bottomAnchor, constant: 16).isActive = true
        pickupDistanceLabel.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -32).isActive = true
        pickupDistanceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(tripDistanceLabel)
        tripDistanceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        tripDistanceLabel.topAnchor.constraint(equalTo: pickupDistanceLabel.bottomAnchor, constant: 8).isActive = true
        tripDistanceLabel.widthAnchor.constraint(equalTo: pickupDistanceLabel.widthAnchor).isActive = true
        tripDistanceLabel.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
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
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "接受", style: .plain, target: self, action: #selector(handleAccept))
        navigationItem.leftBarButtonItem?.tintColor = .white
        navigationItem.rightBarButtonItem?.tintColor = .white
    }
    
    @objc private func handleAccept(){
        
    }
    
    @objc private func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
}













