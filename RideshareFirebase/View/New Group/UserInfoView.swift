//
//  UserInfoView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase

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
        lb.textColor = .white
        lb.font = UIFont.boldSystemFont(ofSize: 20)
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        return lb
    }()
    
    let pickupSwitch: UISwitch = {
        let pickupSwitch = UISwitch()
        pickupSwitch.translatesAutoresizingMaskIntoConstraints = false
        pickupSwitch.isHidden = true
        pickupSwitch.addTarget(self, action: #selector(handlePickupSwitch), for: .valueChanged)
        return pickupSwitch
    }()
    
    @objc private func handlePickupSwitch(){
        guard let uid = Auth.auth().currentUser?.uid else { return }
        let isEnabled = pickupSwitch.isOn
        Database.database().reference().child("users").child(uid).child("isPickupEnabled").setValue(isEnabled)
        Database.database().reference().child("drivers").child(uid).child("isPickupEnabled").setValue(isEnabled)
    }
    
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
        nameLabel.topAnchor.constraint(equalTo: userImageView.bottomAnchor, constant: 8).isActive = true
        nameLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        addSubview(pickupSwitch)
        pickupSwitch.topAnchor.constraint(equalTo: nameLabel.bottomAnchor, constant: 8).isActive = true
        pickupSwitch.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        pickupSwitch.widthAnchor.constraint(equalToConstant: 60).isActive = true
        pickupSwitch.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        chekUserId()
    }
    
    func chekUserId() {
        guard let uid = Auth.auth().currentUser?.uid else {
            nameLabel.text = "Visitor"
            pickupSwitch.isHidden = true
            return
        }
        
        Database.database().reference().child("users").child(uid).observeSingleEvent(of: .value, with: { (snapshot) in
            guard let userData = snapshot.value as? [String : Any] else { return }
            let name = userData["name"] as? String
            self.nameLabel.text = name
            if let isPickupEnable = userData["isPickupEnabled"] as? Bool {
                self.pickupSwitch.isHidden = false
                self.pickupSwitch.isOn = isPickupEnable
            }else{
                self.pickupSwitch.isHidden = true
            }
            
        }) { (error) in
            print(error)
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
