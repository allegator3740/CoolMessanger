//
//  LogoutController.swift
//  CoolMessanger
//
//  Created by Oleg on 28.05.2018.
//  Copyright © 2018 Oleg. All rights reserved.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class LoginController: UIViewController {
    
    var inputsContainerViewHeightAnchor : NSLayoutConstraint?
    var nameTextfieldHeightAnchor : NSLayoutConstraint?
    var emailTextfieldHeightAnchor : NSLayoutConstraint?
    var passwordTextfieldHeightAnchor : NSLayoutConstraint?
    
    let inputsConrainerView : UIView = {
        let view = UIView()
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    lazy var loginRegisterButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.init(r: 80, g: 101, b: 161)
        button.setTitle("register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleLoginRegister), for: .touchUpInside)
        button.titleLabel?.font = UIFont.boldSystemFont(ofSize: 16)
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    let nameTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = "Name"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let nameSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let emailTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = "Email"
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    let emailSeparatorView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.init(r: 220, g: 220, b: 220)
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let passwordTextField : UITextField = {
        let tf = UITextField()
        tf.backgroundColor = UIColor.white
        tf.placeholder = "Password"
        tf.isSecureTextEntry = true
        tf.translatesAutoresizingMaskIntoConstraints = false
        return tf
    }()
    lazy var profileImageView : UIImageView = {
        let imView = UIImageView()
        imView.image = UIImage.init(named: "pen.png")
        imView.contentMode = .scaleAspectFit
        imView.addGestureRecognizer(UITapGestureRecognizer.init(target: self, action: #selector(handleSelectProfileImageView)))
        imView.isUserInteractionEnabled = true
        imView.translatesAutoresizingMaskIntoConstraints = false
        return imView
    }()
    lazy var loginRegisterSegmentedControl : UISegmentedControl = {
        let sc = UISegmentedControl(items: ["login", "register"])
        sc.tintColor = UIColor.white
        sc.selectedSegmentIndex = 1
        sc.addTarget(self, action: #selector(handleLoginRegisterChange), for: .valueChanged)
        sc.translatesAutoresizingMaskIntoConstraints = false
        return sc
    }()
    
    
    //Triggers after clicking loginRegisterButton
    @objc func handleLoginRegisterChange()  {
        
        //setting loginRegisterButton title
        let title = loginRegisterSegmentedControl.titleForSegment(at: loginRegisterSegmentedControl.selectedSegmentIndex)
        loginRegisterButton.setTitle(title, for: .normal)
        
        //change height of inputContainerView
        inputsContainerViewHeightAnchor?.constant = loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 100 : 150
        
        //change height of nameTextField
        nameTextfieldHeightAnchor?.isActive = false
        nameTextfieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 0 : 1 / 3)
        nameTextfieldHeightAnchor?.isActive = true
        
        //change height of emailTextField
        emailTextfieldHeightAnchor?.isActive = false
        emailTextfieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1 / 2 : 1 / 3)
        emailTextfieldHeightAnchor?.isActive = true
        
        //change height of passwordTextField
        passwordTextfieldHeightAnchor?.isActive = false
        passwordTextfieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: loginRegisterSegmentedControl.selectedSegmentIndex == 0 ? 1 / 2 : 1 / 3)
        passwordTextfieldHeightAnchor?.isActive = true
    }
    
    @objc func handleLoginRegister() {
        if loginRegisterSegmentedControl.selectedSegmentIndex == 0 {
            handleLogin()
        }else {
            handleRegistration()
        }
    }
    
    func handleLogin() {
        guard let email = emailTextField.text, let password = passwordTextField.text else {
            print("Data is not valid")
            return
        }
        
        Auth.auth().signIn(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
                return
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(r: 61, g: 91, b: 151)
        view.addSubview(inputsConrainerView)
        view.addSubview(loginRegisterButton)
        
        //Adding textFields and separators into container view
        inputsConrainerView.addSubview(nameTextField)
        inputsConrainerView.addSubview(nameSeparatorView)
        inputsConrainerView.addSubview(emailTextField)
        inputsConrainerView.addSubview(emailSeparatorView)
        inputsConrainerView.addSubview(passwordTextField)
        
        view.addSubview(profileImageView)
        view.addSubview(loginRegisterSegmentedControl)
        
        //Setting anchors
        setupProfileImageView()
        setupInputsContainerView()
        setupLoginRegisterButton()
        setupLoginRegisterSegmentedControl()
    }
    
    
    
    func setupInputsContainerView() {
        
        //inputsConrainerView anchors
        inputsConrainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsConrainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsConrainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        inputsContainerViewHeightAnchor = inputsConrainerView.heightAnchor.constraint(equalToConstant: 150)
        inputsContainerViewHeightAnchor?.isActive = true
        
        //nameTextField anchors
        nameTextField.leftAnchor.constraint(equalTo: inputsConrainerView.leftAnchor, constant: 0).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsConrainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        nameTextfieldHeightAnchor = nameTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: 1 / 3 )
        nameTextfieldHeightAnchor?.isActive = true
        
        //nameSeparatorView anchors
        nameSeparatorView.centerXAnchor.constraint(equalTo: inputsConrainerView.centerXAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //emailTextField anchors
        emailTextField.leftAnchor.constraint(equalTo: inputsConrainerView.leftAnchor, constant: 0).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        emailTextfieldHeightAnchor = emailTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: 1 / 3)
        emailTextfieldHeightAnchor?.isActive = true
        
        //emailSeparatorView anchors
        emailSeparatorView.centerXAnchor.constraint(equalTo: inputsConrainerView.centerXAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        //passwordTextField anchors
        passwordTextField.leftAnchor.constraint(equalTo: inputsConrainerView.leftAnchor, constant: 0).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        passwordTextfieldHeightAnchor = passwordTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: 1 / 3)
        passwordTextfieldHeightAnchor?.isActive = true
    }
    
    //LoginRegisterButton anchors
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsConrainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    //ProfileImageView anchors
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: loginRegisterSegmentedControl.topAnchor, constant: 5).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 150).isActive = true
    }
    
    //LoginRegisterSegmentedControl anchors
    func setupLoginRegisterSegmentedControl() {
        loginRegisterSegmentedControl.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterSegmentedControl.bottomAnchor.constraint(equalTo: inputsConrainerView.topAnchor, constant: -12).isActive = true
        loginRegisterSegmentedControl.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor, multiplier : 0.6).isActive = true
        loginRegisterSegmentedControl.heightAnchor.constraint(equalToConstant: 36).isActive = true
    }
    
//    override var preferredStatusBarStyle: UIStatusBarStyle{
//        return .lightContent
//    }
    
}

extension UIColor {
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
