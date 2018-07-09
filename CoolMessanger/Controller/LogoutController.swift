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

class LogoutController: UIViewController {
    
    let inputsConrainerView : UIView = {
        let view = UIView()
        view.backgroundColor = UIColor.yellow
        view.layer.masksToBounds = true
        view.layer.cornerRadius = 5
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()
    let loginRegisterButton : UIButton = {
        let button = UIButton(type: UIButtonType.system)
        button.backgroundColor = UIColor.init(r: 80, g: 101, b: 161)
        button.setTitle("register", for: .normal)
        button.setTitleColor(UIColor.white, for: .normal)
        button.addTarget(self, action: #selector(handleRegistration), for: .touchUpInside)
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
    let profileImageView : UIImageView = {
       let imView = UIImageView()
        imView.image = UIImage.init(named: "pen.png")
        imView.contentMode = .scaleAspectFill
        imView.translatesAutoresizingMaskIntoConstraints = false
        return imView
    }()
    
    @objc func handleRegistration() {
        print("ok")
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Data is not valid")
            return
        }
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print("ok")
            if error != nil {
                print(error!)
            }
         
            guard let uid = user?.uid else { return }
            var ref : DatabaseReference
            ref = Database.database().reference()
//            ref.removeValue()
            let usersRef = ref.child("users").child(uid)

            let values = ["name" : name, "email" : email, "password" : password]
            usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
                if error != nil{
                    print(error!)
                }else{
                    print("saved user successfully into firebase database")
                }
            })
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = UIColor.init(r: 61, g: 91, b: 151)
        view.addSubview(inputsConrainerView)
        view.addSubview(loginRegisterButton)
        inputsConrainerView.addSubview(nameTextField)
        inputsConrainerView.addSubview(nameSeparatorView)
        inputsConrainerView.addSubview(emailTextField)
        inputsConrainerView.addSubview(emailSeparatorView)
        inputsConrainerView.addSubview(passwordTextField)
        view.addSubview(profileImageView)

        setupProfileImageView()
        setupInputsContainerView()
        setupLoginRegisterButton()
    }

    func setupInputsContainerView() {
        inputsConrainerView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        inputsConrainerView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        inputsConrainerView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 0.6).isActive = true
        inputsConrainerView.heightAnchor.constraint(equalToConstant: 150).isActive = true
        
        nameTextField.leftAnchor.constraint(equalTo: inputsConrainerView.leftAnchor, constant: 0).isActive = true
        nameTextField.topAnchor.constraint(equalTo: inputsConrainerView.topAnchor).isActive = true
        nameTextField.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        nameTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: 1 / 3).isActive = true
        
        nameSeparatorView.centerXAnchor.constraint(equalTo: inputsConrainerView.centerXAnchor).isActive = true
        nameSeparatorView.topAnchor.constraint(equalTo: nameTextField.bottomAnchor, constant: -1).isActive = true
        nameSeparatorView.widthAnchor.constraint(equalTo: nameTextField.widthAnchor).isActive = true
        nameSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        emailTextField.leftAnchor.constraint(equalTo: inputsConrainerView.leftAnchor, constant: 0).isActive = true
        emailTextField.topAnchor.constraint(equalTo: nameTextField.bottomAnchor).isActive = true
        emailTextField.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        emailTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: 1 / 3).isActive = true
        
        emailSeparatorView.centerXAnchor.constraint(equalTo: inputsConrainerView.centerXAnchor).isActive = true
        emailSeparatorView.topAnchor.constraint(equalTo: emailTextField.bottomAnchor, constant: -1).isActive = true
        emailSeparatorView.widthAnchor.constraint(equalTo: emailTextField.widthAnchor).isActive = true
        emailSeparatorView.heightAnchor.constraint(equalToConstant: 1).isActive = true
        
        passwordTextField.leftAnchor.constraint(equalTo: inputsConrainerView.leftAnchor, constant: 0).isActive = true
        passwordTextField.topAnchor.constraint(equalTo: emailTextField.bottomAnchor).isActive = true
        passwordTextField.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        passwordTextField.heightAnchor.constraint(equalTo: inputsConrainerView.heightAnchor, multiplier: 1 / 3).isActive = true
    }
    
    func setupLoginRegisterButton() {
        loginRegisterButton.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        loginRegisterButton.topAnchor.constraint(equalTo: inputsConrainerView.bottomAnchor, constant: 12).isActive = true
        loginRegisterButton.widthAnchor.constraint(equalTo: inputsConrainerView.widthAnchor).isActive = true
        loginRegisterButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
    }
    
    func setupProfileImageView() {
        profileImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        profileImageView.bottomAnchor.constraint(equalTo: inputsConrainerView.topAnchor, constant: -60).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 150).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 170).isActive = true
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle{
        return .lightContent
    }
    
}

extension UIColor {
    convenience init(r:CGFloat, g:CGFloat, b:CGFloat){
        self.init(red: r/255, green: g/255, blue: b/255, alpha: 1)
    }
}
