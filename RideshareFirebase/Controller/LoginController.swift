//
//  LoginController.swift
//  RideshareFirebase
//
//  Created by SEAN on 2018/7/28.
//  Copyright © 2018 SEAN. All rights reserved.
//

import UIKit
import Firebase


class LoginController: UIViewController{
    
    
    let logoImageView: UIImageView = {
        let iv = UIImageView()
        iv.image = #imageLiteral(resourceName: "uber_logo")
        iv.contentMode = .scaleAspectFit
        iv.translatesAutoresizingMaskIntoConstraints = false
        return iv
    }()
    
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = " 電子郵件"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let passwordTextField: UITextField = {
        let tf = UITextField()
        tf.placeholder = " 密碼"
        tf.backgroundColor = .white
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.placeholder = " 名字"
        tf.backgroundColor = .white
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
        
    }()
    
    let inputContainer: UIView = {
        let view = UIView()
        view.backgroundColor = .white
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    
    let registerLoginButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("建立新帳戶", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 20)
        button.backgroundColor = .black
        button.setTitleColor(.white, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleRegisterLogin), for: .touchUpInside)
        return button
    }()
    
    let haveAccountButton : UIButton = {
        let button = UIButton(type: .system)
        button.setTitle("已經有帳戶?", for: UIControlState())
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 17.5)
        button.setTitleColor(.black, for: .normal)
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(self, action: #selector(handleHaveAccount), for: .touchUpInside)
        
        return button
    }()
    
    let cancelButton : UIButton = {
        let button = UIButton(type: .system)
        button.setImage(#imageLiteral(resourceName: "cancel").withRenderingMode(.alwaysOriginal), for: .normal)
        button.imageView?.contentMode = .scaleAspectFit
        button.translatesAutoresizingMaskIntoConstraints = false
        button.addTarget(self, action: #selector(handleDismiss), for: .touchUpInside)
        return button
    }()
    
    let segmentControl: UISegmentedControl = {
        let types = [ "Passenger" , "Driver" ]
        let sc = UISegmentedControl(items: types)
        let font: [AnyHashable : Any] = [NSAttributedStringKey.font : UIFont.boldSystemFont(ofSize: 18)]
        sc.setTitleTextAttributes(font, for: .normal)
        sc.selectedSegmentIndex = 0
        sc.tintColor = .black
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    @objc private func handleRegisterLogin(){
        
        if registerLoginButton.titleLabel?.text == "登入"  {
            handleLogin()
        }else{
            handleRegister()
        }
    }
    
    @objc private func handleHaveAccount(){
        inputContainer.subviews.forEach { (view) in
            view.removeFromSuperview()
        }
        
        if registerLoginButton.titleLabel?.text == "登入"  {
            setupRegisterUI()
        }else{
            setupLoginUI()
        }
    }
    
    @objc private func handleDismiss(){
        dismiss(animated: true, completion: nil)
    }
    
    func addSeperatorView(view: UIView) {
        let seperatorView = UIView()
        seperatorView.backgroundColor = UIColor(red: 220/255, green: 220/255, blue: 220/255, alpha: 1)
        seperatorView.translatesAutoresizingMaskIntoConstraints = false
        
        view.addSubview(seperatorView)
        seperatorView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        seperatorView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        seperatorView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
        seperatorView.heightAnchor.constraint(equalToConstant: 1.5).isActive = true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(handleKeyBoardWillShow), name: NSNotification.Name.UIKeyboardWillChangeFrame, object: nil)
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(handleDismissKeyBoard)))
    }
    
    @objc private func handleDismissKeyBoard(){
        view.endEditing(true)
    }
    
    @objc private func handleKeyBoardWillShow(notification: NSNotification){
        let duration = notification.userInfo?[UIKeyboardAnimationDurationUserInfoKey] as! Double
        let curve = notification.userInfo?[UIKeyboardAnimationCurveUserInfoKey] as! UInt
        let beginFrame = notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue
        let endFrame = notification.userInfo?[UIKeyboardFrameEndUserInfoKey] as? NSValue
        let deltaY = (endFrame?.cgRectValue.origin.y)! - (beginFrame?.cgRectValue.origin.y)!
        
        UIView.animateKeyframes(withDuration: duration, delay: 0, options:  UIViewKeyframeAnimationOptions(rawValue: curve), animations: {
            self.view.frame.origin.y += deltaY / 2
        }, completion: nil)
    }
    
    private func setupUI() {
        view.addSubview(cancelButton)
        cancelButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        cancelButton.topAnchor.constraint(equalTo: view.topAnchor, constant: 32).isActive = true
        cancelButton.widthAnchor.constraint(equalToConstant: 40).isActive = true
        cancelButton.heightAnchor.constraint(equalToConstant: 40).isActive = true
        
        view.addSubview(logoImageView)
        logoImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        logoImageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 64).isActive = true
        logoImageView.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -64).isActive = true
        logoImageView.heightAnchor.constraint(equalTo: logoImageView.widthAnchor, multiplier: 0.5).isActive = true
        
        view.addSubview(inputContainer)
        inputContainer.topAnchor.constraint(equalTo: logoImageView.bottomAnchor, constant: 16).isActive = true
        inputContainer.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputContainer.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 16).isActive = true
        inputContainer.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -16).isActive = true
        inputContainerViewHeightConstraint = inputContainer.heightAnchor.constraint(equalToConstant: 165)
        inputContainerViewHeightConstraint?.isActive = true
        
        addSeperatorView(view: nameTextField)
        addSeperatorView(view: emailTextField)
        addSeperatorView(view: passwordTextField)
        
        setupLoginUI()
        
        view.addSubview(registerLoginButton)
        registerLoginButton.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        registerLoginButton.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 96).isActive = true
        registerLoginButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        registerLoginButton.heightAnchor.constraint(equalToConstant: 55).isActive = true
        
        view.addSubview(haveAccountButton)
        haveAccountButton.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        haveAccountButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -48).isActive = true
        haveAccountButton.widthAnchor.constraint(equalTo: inputContainer.widthAnchor).isActive = true
        haveAccountButton.heightAnchor.constraint(equalToConstant: 48).isActive = true
    }
    
    var inputContainerViewHeightConstraint: NSLayoutConstraint?
    
    func setupRegisterUI(){
        
        view.addSubview(segmentControl)
        segmentControl.topAnchor.constraint(equalTo: inputContainer.bottomAnchor, constant: 16).isActive = true
        segmentControl.heightAnchor.constraint(equalToConstant: 40).isActive = true
        segmentControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        segmentControl.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        
        inputContainerViewHeightConstraint?.constant = 165
        
        inputContainer.addSubview(nameTextField)
        nameTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        nameTextField.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/3).isActive = true
        
        inputContainer.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: nameTextField.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo:nameTextField.heightAnchor).isActive = true
        
        inputContainer.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo:emailTextField.heightAnchor).isActive = true
        
        registerLoginButton.setTitle("建立新帳戶", for: .normal)
        haveAccountButton.setTitle("已經有帳戶？", for: .normal)
    }
    
    func setupLoginUI(){
        
        segmentControl.removeFromSuperview()
        
        inputContainerViewHeightConstraint?.constant = 110
        
        inputContainer.addSubview(emailTextField)
        emailTextField.topAnchor.constraint(equalTo: inputContainer.topAnchor).isActive = true
        emailTextField.centerXAnchor.constraint(equalTo: inputContainer.centerXAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputContainer.widthAnchor, constant: -24).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputContainer.heightAnchor, multiplier: 1/2).isActive = true
        
        inputContainer.addSubview(passwordTextField)
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.centerXAnchor.constraint(equalTo: emailTextField.centerXAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo:emailTextField.heightAnchor).isActive = true
        
        registerLoginButton.setTitle("登入", for: .normal)
        haveAccountButton.setTitle("建立帳戶", for: .normal)
    }
    
}
