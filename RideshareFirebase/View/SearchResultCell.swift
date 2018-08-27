//
//  SearchResultCell.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

class SearchTableViewCell: UITableViewCell {
    
    let locationImageView: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.image = #imageLiteral(resourceName: "location")
        return iv
    }()
    
    let locationLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 16)
        return lb
    }()
    
    let addressLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.systemFont(ofSize: 14)
        return lb
    }()
    
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(locationImageView)
        locationImageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 8).isActive = true
        locationImageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        locationImageView.widthAnchor.constraint(equalToConstant: 20).isActive = true
        locationImageView.heightAnchor.constraint(equalTo: locationImageView.widthAnchor).isActive = true
        
        addSubview(locationLabel)
        locationLabel.leftAnchor.constraint(equalTo: locationImageView.rightAnchor, constant: 8).isActive = true
        locationLabel.topAnchor.constraint(equalTo: topAnchor).isActive = true
        locationLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        locationLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.6).isActive = true
        
        addSubview(addressLabel)
        addressLabel.leftAnchor.constraint(equalTo: locationLabel.leftAnchor).isActive = true
        addressLabel.topAnchor.constraint(equalTo: locationLabel.bottomAnchor).isActive = true
        addressLabel.rightAnchor.constraint(equalTo: rightAnchor).isActive = true
        addressLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.4).isActive = true
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
