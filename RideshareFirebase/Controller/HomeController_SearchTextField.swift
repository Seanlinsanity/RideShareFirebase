//
//  HomeController_SearchTextField.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/26.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

extension HomeController: UITextFieldDelegate{

    @objc func textFieldDidChange(_ textField: UITextField) {
        
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        print("begin editing")
        view.insertSubview(editingBackgroundView, belowSubview: searchTextBackground)
        editingBackgroundView.frame = view.frame
        editingBackgroundView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyBoard)))
    }
    
    @objc func handleDismissKeyBoard(){
        print("dismiss")
        view.endEditing(true)
        editingBackgroundView.removeFromSuperview()
        tableViewHeightAnchor.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("should return")
        presentLoadingView()
        searchLocation()
        view.endEditing(true)
        
        tableViewHeightAnchor.constant = 400
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
        
        return true
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        print("end editing")
    }
    
    func textFieldShouldClear(_ textField: UITextField) -> Bool {
        print("clear text")
        
        searchMapResults.removeAll()
        tableView.reloadData()
        
        removeDestinationAndRoute()        
        return true
    }
    
}





