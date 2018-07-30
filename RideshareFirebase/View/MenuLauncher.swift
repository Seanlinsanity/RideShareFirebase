//
//  MenuLauncher.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

class MenuLauncher: NSObject {
    
    var delegate: MenuDelegate?
    let blackView = UIView()
    
    lazy var menuBarView: MenuBarView = {
        let menuBarView = MenuBarView()
        menuBarView.delegate = delegate
        return menuBarView
    }()
    
    func showMenuBar(){
        
        if let window = UIApplication.shared.keyWindow {
            let menuBarWidth = window.frame.width * 0.75
            
            blackView.backgroundColor = UIColor(white: 0 ,alpha: 0.5)
            blackView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismiss)))
            
            window.addSubview(blackView)
            blackView.frame = window.frame
            blackView.alpha = 0
            
            window.addSubview(menuBarView)
            menuBarView.frame = CGRect(x: -(menuBarWidth), y: 0, width: menuBarWidth, height: window.frame.height)
            
            UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 1
                self.menuBarView.frame.origin.x = 0
            }, completion: nil)
        }
        
    }
    
    @objc func handleDismiss(){
        if let window = UIApplication.shared.keyWindow {

            UIView.animate(withDuration: 0.25, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
                self.blackView.alpha = 0
                self.menuBarView.frame.origin.x = -(window.frame.width * 0.75)
            }, completion: nil)
        }
    }
    
}
