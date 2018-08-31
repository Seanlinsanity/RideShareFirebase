//
//  RequestStatusView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/31.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

class RequestStatusView: UIView {
    
    var countDownTime = 60
    let waitingMatch = "正在為您配對合適的駕駛"
    let driverComing = "駕駛正在來接您的路上"
    
    let countingLabel: UILabel = {
        let lb = UILabel()
        lb.textAlignment = .center
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.font = UIFont.boldSystemFont(ofSize: 50)
        return lb
    }()
    
    let statusLabel: UILabel = {
        let lb = UILabel()
        lb.translatesAutoresizingMaskIntoConstraints = false
        lb.textAlignment = .center
        return lb
    }()
    
    let isAcceptedImage: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "ok")
        iv.contentMode = .scaleAspectFit
        iv.isHidden = true
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    var displayLink: CADisplayLink?
    var animationStartDate = Date()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        backgroundColor = .white
        
        countingLabel.text = String(countDownTime)
        addSubview(countingLabel)
        countingLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        countingLabel.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        countingLabel.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        countingLabel.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        addSubview(isAcceptedImage)
        isAcceptedImage.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        isAcceptedImage.topAnchor.constraint(equalTo: topAnchor, constant: 16).isActive = true
        isAcceptedImage.widthAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        isAcceptedImage.heightAnchor.constraint(equalTo: heightAnchor, multiplier: 0.5).isActive = true
        
        statusLabel.text = waitingMatch
        addSubview(statusLabel)
        statusLabel.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        statusLabel.topAnchor.constraint(equalTo: countingLabel.bottomAnchor, constant: -8).isActive = true
        statusLabel.widthAnchor.constraint(equalTo: widthAnchor).isActive = true
        statusLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -8).isActive = true
        
        displayLink = CADisplayLink(target: self, selector: #selector(handleCountingUpdate))
        displayLink?.add(to: .main, forMode: .defaultRunLoopMode)
    }
    
    @objc func handleCountingUpdate(){
        let now = Date()
        let elapsedTime = Int(now.timeIntervalSince(animationStartDate))
        if countDownTime - elapsedTime < 0 {
            displayLink?.remove(from: .main, forMode: .defaultRunLoopMode)
            return
        }
        countingLabel.text = String(countDownTime - elapsedTime)
    }
    
    func handleRequestAccepted(){
        displayLink?.remove(from: .main, forMode: .defaultRunLoopMode)
        
        countingLabel.isHidden = true
        isAcceptedImage.isHidden = false
        
        statusLabel.text = driverComing

    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
}
