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
    var tableViewHeightAnchor: NSLayoutConstraint!
    
    var searchMapResults = [MKMapItem]()

    let editingBackgroundView = UIView()
    
    let mapView: MKMapView = {
        let mapView = MKMapView()
        mapView.translatesAutoresizingMaskIntoConstraints = false
        return mapView
    }()
    
    let searchTextBackground: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.backgroundColor = .white
        view.layer.cornerRadius = 8
        view.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        view.layer.shadowRadius = 8
        view.layer.shadowOpacity = 0.5
        view.layer.shadowOffset = CGSize(width: 0, height: 4)
        return view
    }()
    
    let searchTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = "要去哪裡？"
        tf.font = UIFont.systemFont(ofSize: 18)
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        tf.returnKeyType = .search
        tf.clearButtonMode = .whileEditing
        return tf
    }()
    
    lazy var tableView: UITableView = {
        let tableView = UITableView()
        tableView.translatesAutoresizingMaskIntoConstraints = false
        tableView.delegate = self
        tableView.dataSource = self
        tableView.layer.masksToBounds = true
        tableView.layer.cornerRadius = 8
        tableView.layer.shadowColor = UIColor(white: 0.4, alpha: 0.4).cgColor
        tableView.layer.shadowRadius = 8
        tableView.layer.shadowOpacity = 0.5
        tableView.layer.shadowOffset = CGSize(width: 0, height: 4)
        return tableView
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
        btn.setTitle("行程確認", for: .normal)
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
    
    let activityIndicatorView: UIActivityIndicatorView = {
        let activityIndicatorView = UIActivityIndicatorView()
        activityIndicatorView.translatesAutoresizingMaskIntoConstraints = false
        activityIndicatorView.activityIndicatorViewStyle = .whiteLarge
        activityIndicatorView.backgroundColor = .gray
        activityIndicatorView.layer.cornerRadius = 10
        activityIndicatorView.clipsToBounds = true
        return activityIndicatorView
    }()
    
    let cellId = "cellId"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        
        searchTextField.addTarget(self, action: #selector(textFieldDidChange(_:)), for: .editingChanged)
        
        checkLocationService()
        checkDriverAccount()
        
        tableView.register(SearchTableViewCell.self, forCellReuseIdentifier: cellId)
    }
    
    func checkLocationService(){
        print("check")
        if CLLocationManager.locationServicesEnabled(){
            setupLocationManager()
            checkLocationAuthorization()
        }
    }
    
    func checkLocationAuthorization(){
        if (CLLocationManager.authorizationStatus() == .authorizedAlways ||  CLLocationManager.authorizationStatus() == .authorizedWhenInUse){
            mapView.delegate = self
            mapView.showsUserLocation = true
            mapView.userTrackingMode = .follow
            
            centerMapOnUserLocation()
            fetchDriverAnnotations()
        }else{
            locationManager.requestAlwaysAuthorization()
        }
    }
    
    private func setupLocationManager(){
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.startUpdatingLocation()
    }
    
    private func checkDriverAccount(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        Database.database().reference().child("drivers").child(uid).child("isPickupEnabled").observe(.value, with: { (snapshot) in
            if snapshot.exists(){
                guard let available = snapshot.value as? Bool else { return }
                if available{
                    self.observeTrips()
                }else{
                    return
                }
            }
        }, withCancel: nil)
    }
    
    private func observeTrips(){
        Database.database().reference().child("trips").observe(.childAdded, with: { (snapshot) in
            print(snapshot.key)
            guard let tripDict = snapshot.value as? [String: Any] else { return }
            guard let pickupCoordinate = tripDict["pickupCoordinate"] as? NSArray, let destinationCoordinate = tripDict["destinationCoordinate"] as? NSArray, let isAccepted = tripDict["tripIsAccepted"] as? Bool, let name = tripDict["name"] as? String else { return }
            if isAccepted { return }
            
            let pickupLocation = CLLocationCoordinate2D(latitude: pickupCoordinate[0] as! CLLocationDegrees, longitude: pickupCoordinate[1] as! CLLocationDegrees)
            let destinationLocation = CLLocationCoordinate2D(latitude: destinationCoordinate[0] as! CLLocationDegrees, longitude: destinationCoordinate[1] as! CLLocationDegrees)
            
            let pickupController = PickupController(pickupCoordinate: pickupLocation, destinationCoordinate: destinationLocation, tripKey: snapshot.key)
            pickupController.driverCoordinate = self.mapView.userLocation.coordinate
            pickupController.passengerName = name
            let navController = UINavigationController(rootViewController: pickupController)
            self.present(navController, animated: true, completion: nil)
            
        }, withCancel: nil)
    }
    
    private func fetchDriverAnnotations(){
        Database.database().reference().child("drivers").observe(.value, with: { (snapshot) in
            guard let driversSnapshot = snapshot.children.allObjects as? [DataSnapshot] else { return }
            for driver in driversSnapshot {
                guard let driverDictionary = driver.value as? [String: Any] else { return }
                guard let isPickupEnabled = driverDictionary["isPickupEnabled"] as? Bool else { return }
                
                if !isPickupEnabled {
                    guard let driverAnnotation = self.mapView.annotations.first(where: {$0.title == driver.key}) else { continue }
                    self.mapView.removeAnnotation(driverAnnotation)
                    continue
                }
                
                self.updateDriverAnnotation(driverDictionary: driverDictionary, driver: driver)
                
            }
        }) { (error) in
            print("fetch Driver Error: ", error)
        }
    }
    
    private func updateDriverAnnotation(driverDictionary: [String: Any], driver: DataSnapshot){
        guard let coordinateArray = driverDictionary["coordinate"] as? NSArray else { return }
        let driverCoordinate = CLLocationCoordinate2D(latitude: coordinateArray[0] as! CLLocationDegrees, longitude: coordinateArray[1] as! CLLocationDegrees)
        
        if let driverAnnotation = self.mapView.annotations.first(where: {$0.title == driver.key}) as? DriverAnnotation {
            driverAnnotation.update(coordinate: driverCoordinate)
        }else{
            let driverAnnotation = DriverAnnotation(coordinate: driverCoordinate, title: driver.key)
            self.mapView.addAnnotation(driverAnnotation)
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
        
        view.addSubview(searchTextBackground)
        searchTextBackground.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32).isActive = true
        searchTextBackground.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 32).isActive = true
        searchTextBackground.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -32).isActive = true
        searchTextBackground.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        searchTextField.delegate = self
        searchTextBackground.addSubview(searchTextField)
        searchTextField.topAnchor.constraint(equalTo: searchTextBackground.topAnchor).isActive = true
        searchTextField.leftAnchor.constraint(equalTo: searchTextBackground.leftAnchor, constant: 8).isActive = true
        searchTextField.rightAnchor.constraint(equalTo: searchTextBackground.rightAnchor, constant: -8).isActive = true
        searchTextField.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(tableView)
        tableView.topAnchor.constraint(equalTo: searchTextBackground.bottomAnchor).isActive = true
        tableView.leftAnchor.constraint(equalTo: searchTextBackground.leftAnchor).isActive = true
        tableView.rightAnchor.constraint(equalTo: searchTextBackground.rightAnchor).isActive = true
        tableViewHeightAnchor = tableView.bottomAnchor.constraint(equalTo: searchTextBackground.bottomAnchor, constant: 0)
        tableViewHeightAnchor.isActive = true
        
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
        UpdateCoordinateService.shareInstance.updateTripRequest()
    }
    
    func presentLoginController() {
        menuLauncher.handleDismiss()
        let loginController = LoginController()
        loginController.homeController = self
        present(loginController, animated: true, completion: nil)
    }
    
    func presentLoadingView(){
        view.addSubview(activityIndicatorView)
        activityIndicatorView.startAnimating()
        activityIndicatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        activityIndicatorView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        activityIndicatorView.widthAnchor.constraint(equalToConstant: 60).isActive = true
        activityIndicatorView.heightAnchor.constraint(equalToConstant: 60).isActive = true
    }
    
    func dismissLoadingView(){
        activityIndicatorView.stopAnimating()
        activityIndicatorView.removeFromSuperview()
    }
    
    @objc private func handleCenterButton(){
        centerMapOnUserLocation()
        UIView.animate(withDuration: 0.2, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.centerButton.alpha = 0
        }, completion: nil)
    }
    
    func centerMapOnUserLocation() {
        if mapView.overlays.count > 0 {
            zoomToFitAnnotation()
        }else{
            let coordinateRegion = MKCoordinateRegionMakeWithDistance(mapView.userLocation.coordinate, regionRadius, regionRadius)
            mapView.setRegion(coordinateRegion, animated: true)
        }
    }

}

