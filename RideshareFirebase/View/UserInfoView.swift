//
//  UserInfoView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

class UserInfoView: UIView {
    
    let userImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "user")
        iv.backgroundColor = .white
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.layer.cornerRadius = 50
        iv.contentMode = .scaleAspectFit
        return iv
    }()
    
    let nameLabel: UILabel = {
        let lb = UILabel()
        lb.text = "Visitor"
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .black
        
        addSubview(userImageView)
        userImageView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        userImageView.topAnchor.constraint(equalTo: topAnchor, constant: 64).isActive = true
        userImageView.widthAnchor.constraint(equalToConstant: 100).isActive = true
        userImageView.heightAnchor.constraint(equalTo: userImageView.widthAnchor).isActive = true
        
        addSubview(nameLabel)
        nameLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        nameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 16).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 120).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
