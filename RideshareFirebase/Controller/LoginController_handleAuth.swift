//
//  LoginController_handleAuth.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/30.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase

enum ObservationKey: String {
    case login = "firebaseLoginNotification"
    case signOut = "firebaseSignOutNotification"
}

extension LoginController {
    func handleLogin(){
        guard let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().signIn(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print(error)
                return
            }
            let name = Notification.Name(ObservationKey.login.rawValue)
            NotificationCenter.default.post(name: name, object: nil)
            print(result?.user.uid)
            self.dismiss(animated: true, completion: nil)
            self.homeController?.updateUserLocationInDatabase()
        }
    }
    
    func handleRegister(){
        guard let userType = segmentControl.titleForSegment(at: segmentControl.selectedSegmentIndex) else { return }
        guard let name = nameTextField.text,let email = emailTextField.text, let password = passwordTextField.text else { return }
        Auth.auth().createUser(withEmail: email, password: password) { (result, error) in
            if let error = error{
                print(error)
                return
            }
            
            let isDriver = userType == "Driver" ? true : false
            let userData = isDriver ? ["name": name, "type": userType, "isOnTrip": false, "isPickupEnabled": false] as [String : Any] : ["name": name, "type": userType] as [String: Any]
            FirebaseManager.createUserInDatabase(uid: result!.user.uid, userData: userData)
            if isDriver {
                FirebaseManager.createDriverInDatabase(uid: result!.user.uid, userData: userData)
            }
            
            let name = Notification.Name(ObservationKey.login.rawValue)
            NotificationCenter.default.post(name: name, object: nil)

            self.dismiss(animated: true, completion: nil)
            self.homeController?.updateUserLocationInDatabase()

        }
    }
}
