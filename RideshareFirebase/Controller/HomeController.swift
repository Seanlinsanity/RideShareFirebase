//
//  ViewController.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/26.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import MapKit
import Firebase

class HomeViewController: UIViewController, MenuDelegate {
    
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
    
    lazy var menuLauncher: MenuLauncher = {
        let menuLauncher = MenuLauncher()
        menuLauncher.delegate = self
        return menuLauncher
    }()
    
    func presentLoginController() {
        menuLauncher.handleDismiss()
        let loginController = LoginController()
        present(loginController, animated: true, completion: nil)
    }
        
    fileprivate func setupUI() {
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
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
    }
    
    @objc private func handleShowMenu(){
        menuLauncher.showMenuBar()
    }
    
    @objc private func handleRequestRide(){
        print(456)
    }

}

