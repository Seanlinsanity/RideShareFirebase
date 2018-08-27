//
//  HomeController_TableView.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/8/27.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit

extension HomeController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchMapResults.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! SearchTableViewCell
        let mapItem = searchMapResults[indexPath.row]
        cell.locationLabel.text = mapItem.name
        cell.addressLabel.text = mapItem.placemark.title
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let mapItem = searchMapResults[indexPath.row]
        searchTextField.text = mapItem.name
        view.endEditing(true)
        
        tableViewHeightAnchor.constant = 0
        UIView.animate(withDuration: 0.4, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 1, options: .curveEaseOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
}
