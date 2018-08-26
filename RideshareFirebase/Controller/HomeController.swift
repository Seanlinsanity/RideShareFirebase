//
//  ViewController.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/26.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import MapKit
import CoreLocation
import Firebase

class HomeController: UIViewController, MenuDelegate {
    
    let locationManager = CLLocationManager()
    var regionRadius: CLLocationDistance = 1000
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let searchView: UITextView = {
        let textView = UITextView()
        textView.text = "  要去哪裡？"
        textView.font = UIFont.systemFont(ofSize: 18)
        textView.textColor = .gray
        textView.backgroundColor = .white
        textView.translatesAutoresizingMaskIntoConstraints = false
        textView.layer.cornerRadius = 8
        textView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        textView.layer.shadowRadius = 8
        textView.layer.shadowOpacity = 0.5
        textView.layer.shadowOffset = CGSize(width: 0, height: 4)
        return textView
    }()
    
    let menuButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "menuSliderBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleShowMenu), for: .touchUpInside)
        return btn
    }()
    
    let requestRideButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("完成", for: .normal)
        btn.layer.cornerRadius = 8
        btn.backgroundColor = .black
        btn.titleLabel?.font = UIFont.systemFont(ofSize: 20)
        btn.setTitleColor(.white, for: .normal)
        btn.addTarget(self, action: #selector(handleRequestRide), for: .touchUpInside)
        return btn
    }()
    
    let centerButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.alpha = 0
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(#imageLiteral(resourceName: "centerMapBtn").withRenderingMode(.alwaysOriginal), for: .normal)
        btn.addTarget(self, action: #selector(handleCenterButton), for: .touchUpInside)
        return btn
    }()
    
    lazy var menuLauncher: MenuLauncher = {
        let menuLauncher = MenuLauncher()
        menuLauncher.delegate = self
        return menuLauncher
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        mapView.delegate = self
        
        checkLocationAuthStatus()
    }
    
    func checkLocationAuthStatus(){
        if CLLocationManager.locationServicesEnabled() && (CLLocationManager.authorizationStatus() == .authorizedAlways ||  CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            setupLocationManager()
        }else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
        
        mapView.showsUserLocation = true
        mapView.userTrackingMode = .follow
        
        centerMapOnUserLocation()
        fetchDriverAnnotations()
    }
    
    @objc private func handleCenterButton(){
        centerMapOnUserLocation()
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.centerButton.alpha = 0
        }, completion: nil)
    }
    
    func centerMapOnUserLocation() {
        let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius, regionRadius)
        mapView.setRegion(coordinateRegion, animated: true)
    }
    
    private func fetchDriverAnnotations(){
        Database.database().reference().child("drivers").observe(.value, with: { (snapshot) in
            guard let driversSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            print(driversSnapshot)
            for driver in driversSnapshot {
                guard let driverDictionary = driver.value as? [String: Any] else { return }
                guard let isPickupEnabled = driverDictionary["isPickupEnabled"] as? Bool else { return }
                
                if !isPickupEnabled {
                    guard let driverAnnotation = self.mapView.annotations.first(where: {$0.title == driver.key}) else { continue }
                    self.mapView.removeAnnotation(driverAnnotation)
                    continue
                }
                
                guard let coordinateArray = driverDictionary["coordinate"] as? NSArray else { return }
                let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
                
                if let driverAnnotation = self.mapView.annotations.first(where: {$0.title == driver.key}) as? DriverAnnotation {
                    driverAnnotation.update(coordinate: driverCoordinate)
                }else{
                    let driverAnnotation = DriverAnnotation(coordinate: driverCoordinate, title: driver.key)
                    self.mapView.addAnnotation(driverAnnotation)
                }
                
            }
        }) { (error) in
            print("fetch Driver Error: ", error)
        }
    }
    
    fileprivate func setupUI() {
        view.backgroundColor = .white
        
        view.addSubview(mapView)
        mapView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        mapView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        mapView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        mapView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        view.addSubview(menuButton)
        menuButton.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        menuButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        menuButton.widthAnchor.constraint(equalToConstant: 16).isActive = true
        menuButton.heightAnchor.constraint(equalToConstant: 16).isActive = true
        
        view.addSubview(searchView)
        searchView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        searchView.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        searchView.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        searchView.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(requestRideButton)
        requestRideButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16).isActive = true
        requestRideButton.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        requestRideButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        requestRideButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(centerButton)
        centerButton.bottomAnchor.constraint(equalTo: requestRideButton.topAnchor, constant: -16).isActive = true
        centerButton.widthAnchor.constraint(equalToConstant: 64).isActive = true
        centerButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        centerButton.heightAnchor.constraint(equalToConstant: 64).isActive = true
    }
    
    @objc private func handleShowMenu(){
        menuLauncher.showMenuBar()
    }
    
    @objc private func handleRequestRide(){

    }
    
    func presentLoginController() {
        menuLauncher.handleDismiss()
        let loginController = LoginController()
        loginController.homeController = self
        present(loginController, animated: true, completion: nil)
    }

}

