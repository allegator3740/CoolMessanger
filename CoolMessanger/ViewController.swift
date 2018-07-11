//
//  ViewController.swift
//  CoolMessanger
//
//  Created by Oleg on 28.05.2018.
//  Copyright © 2018 Oleg. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase
import FirebaseAuth


class ViewController: UITableViewController {
    var handle : AuthStateDidChangeListenerHandle?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "logout", style: .plain, target: self, action: #selector(handleLogout))
        //        Optional.some(5)
        if Auth.auth().currentUser?.uid == nil{
            perform(#selector(handleLogout), with: self, afterDelay: 0)
        }
        
    }
    
    //clicking button OUT
    @objc func handleLogout()  {
        
        //user is not logged in
        do {
            try Auth.auth().signOut()
        } catch let logoutError {
            print(logoutError)
        }
        
        let loginController = LogoutController()
        present(loginController, animated: true, completion: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        handle = Auth.auth().addStateDidChangeListener { (auth, user) in
            if user != nil {
                print("user is signed in")
                print(user!.email!)
            } else {
                print("unautherized")
            }
        }
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillAppear(animated)
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    
}



