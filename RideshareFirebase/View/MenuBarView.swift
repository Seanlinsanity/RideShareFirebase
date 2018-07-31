//
//  MenuBarView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase

protocol MenuDelegate {
    func presentLoginController()
}

class MenuBarView: UIView {
    
    var delegate: MenuDelegate?
    
    let userInfoView: UserInfoView = {
        let view = UserInfoView()
        view.backgroundColor = .black
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    lazy var buttonStackView: MenuButtonStackView = {
        let stackView = MenuButtonStackView()
        stackView.menuBarView = self
        return stackView
    }()
    
    private func setupObserver(){
        let loginNotificationName = Notification.Name(rawValue: ObservationKey.login.rawValue)
        let signOutNotificationName = Notification.Name(rawValue: ObservationKey.signOut.rawValue)

        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSignOutUpdateUI), name: loginNotificationName, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(handleLoginSignOutUpdateUI), name: signOutNotificationName, object: nil)
    }
    
    @objc private func handleLoginSignOutUpdateUI(){
        userInfoView.chekUserId()
        buttonStackView.checkUserId()
    }

    func handlePresentLoginController(){
        delegate?.presentLoginController()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        setupUserInfoView()
        setupStackView()
        
        setupObserver()
    }
    
    private func setupUserInfoView(){
        addSubview(userInfoView)
        userInfoView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        userInfoView.topAnchor.constraint(equalTo: topAnchor).isActive = true
        userInfoView.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        userInfoView.heightAnchor.constraint(equalTo: userInfoView.widthAnchor).isActive = true
    }
    
    private func setupStackView(){
        buttonStackView.axis = .vertical
        buttonStackView.distribution = .fillEqually
        buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        
        addSubview(buttonStackView)
        buttonStackView.leftAnchor.constraint(equalTo: leftAnchor).isActive = true
        buttonStackView.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        buttonStackView.topAnchor.constraint(equalTo: userInfoView.bottomAnchor, constant: 16).isActive = true
        buttonStackView.heightAnchor.constraint(equalToConstant: 300).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
    
}
