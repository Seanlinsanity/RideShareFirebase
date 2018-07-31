//
//  MenuButtonStackView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/31.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase

class MenuButtonStackView: UIStackView {
    var menuBarView: MenuBarView?
    
    let yourTripsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.setTitleColor(.black, for: .normal)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitle("Your Trips", for: .normal)
        return btn
    }()
    
    let paymentButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Payment", for: .normal)
        return btn
    }()
    
    let helpButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Help", for: .normal)
        return btn
    }()
    
    let settingsButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Settings", for: .normal)
        return btn
    }()
    
    let loginSignOutButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Log in", for: .normal)
        btn.addTarget(self, action: #selector(handleLoginSignOut), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleLoginSignOut(){
        if loginSignOutButton.titleLabel?.text == "Log in" {
            menuBarView?.handlePresentLoginController()
        }else{
            handleSignOut()
        }
    }
    
    private func handleSignOut(){
        do {
            try Auth.auth().signOut()
            
            let name = Notification.Name(rawValue: ObservationKey.signOut.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
        }catch let signOutError {
            print(signOutError)
        }
    }
    
    func checkUserId(){
        if Auth.auth().currentUser != nil {
            loginSignOutButton.setTitle("Sign out", for: .normal)
            loginSignOutButton.setTitleColor(.red, for: .normal)
        }else{
            loginSignOutButton.setTitle("Log in", for: .normal)
            loginSignOutButton.setTitleColor(.black, for: .normal)
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        addArrangedSubview(yourTripsButton)
        addArrangedSubview(paymentButton)
        addArrangedSubview(helpButton)
        addArrangedSubview(settingsButton)
        addArrangedSubview(loginSignOutButton)
        
        checkUserId()
    }
    
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
