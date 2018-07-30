//
//  MenuBarView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

protocol MenuDelegate {
    func handleLogin()
}

class MenuBarView: UIView {
    
    var delegate: MenuDelegate?
    let userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
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
    
    let loginButton: UIButton = {
        let btn = UIButton(type: .system)
        btn.titleLabel?.font = UIFont.boldSystemFont(ofSize: 18)
        btn.setTitleColor(.black, for: .normal)
        btn.setTitle("Log in", for: .normal)
        btn.addTarget(self, action: #selector(handleLogin), for: .touchUpInside)
        return btn
    }()
    
    @objc private func handleLogin(){
        delegate?.handleLogin()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupUserInfoView()
        setupStackView()
    }
    
    private func setupUserInfoView(){
        addSubview(userInfoView)
        userInfoView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        userInfoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        userInfoView.heightAnchor.constraint(equalTo: userInfoView.widthAnchor).isActive = true
    }
    
    private func setupStackView(){
        let stackView = UIStackView(arrangedSubviews: [yourTripsButton, paymentButton, helpButton, settingsButton, loginButton])
        stackView.axis = .vertical
        stackView.distribution = .fillEqually
        stackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(stackView)
        stackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        stackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        stackView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor).isActive = true
        stackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
