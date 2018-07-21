//
//  LoginController+Handlers.swift
//  CoolMessanger
//
//  Created by Oleg on 12.07.2018.
//  Copyright © 2018 Oleg. All rights reserved.
//

import Foundation
import UIKit
import Firebase

extension LoginController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    @objc func handleRegistration() {
        //unwrapping variables gotten from storyboard
        //22000 айфон
        //800 чехол
        //5000 в больнице
        //1500 райфайзинг
        //6600 аккаунт разработчика
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Data is not valid")
            return
        }
        
        //Creating new user in database
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            if error != nil {
                print(error!)
            }
            
            //Adding cathegory "users" in database and new child
            guard let uid = user?.uid else { return }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).jpg")
            if let uploadData = UIImageJPEGRepresentation(self.profileImageView.image!, 0.1) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                        let values = ["name" : name, "email" : email, "password" : password, "profileImageUrl" : profileImageUrl]
                        
                        self.registerUserIntoDataBaseWithUID(uid: uid, values: values as [String : AnyObject])
                        
                    }
                })
            }
            
            
        }
        
    }
    
    private func registerUserIntoDataBaseWithUID(uid: String, values: [String : AnyObject]) {
        var ref : DatabaseReference
        ref = Database.database().reference()
        let usersRef = ref.child("users").child(uid)
        

        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
            }else{
                print("saved user successfully into firebase database")
            }
//            self.messagesController?.navigationItem.title = values["name"] as? String
//            self.messagesController?.fetchUserAndSetupNavBarTitle()
            let user = User()
            user.name = values["name"] as? String
            user.email = values["email"] as? String
            user.password = values["password"] as? String
            user.profileImageUrl = values["profileImageUrl"] as? String
            self.messagesController?.setupNavBarWithUser(user: user)
            self.dismiss(animated: true, completion: nil)
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let alertController = UIAlertController()
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Take picture", comment: "Default action"), style: .default, handler: { _ in
            let picker = UIImagePickerController()
            picker.delegate = self
            picker.allowsEditing = true
            picker.sourceType = .camera
            self.present(picker, animated: true, completion: nil)        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Choose photo", comment: "Default action"), style: .default, handler: { _ in
                    let picker = UIImagePickerController()
                    picker.delegate = self
                    picker.allowsEditing = true
                    self.present(picker, animated: true, completion: nil)
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Remove photo", comment: "Default action"), style: .default, handler: { _ in
            self.profileImageView.image = UIImage(named: "pphoto.png")
        }))
        alertController.addAction(UIAlertAction(title: NSLocalizedString("Cancel", comment: "Default action"), style: .cancel, handler: { _ in
            NSLog("The \"OK\" alert occured.")
        }))
        self.present(alertController, animated: true, completion: nil)

        
//        let picker = UIImagePickerController()
//        picker.delegate = self
//        picker.allowsEditing = true
//        present(picker, animated: true, completion: nil)
//        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "photo", style: .plain, target: self, action: #selector(handleCamera))
    }
    
//    @objc func handleCamera() {
//        print("common")
//    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        var pickedImage : UIImage?
        
        if let editedImage = info["UIImagePickerControllerEditedImage"] as? UIImage {
            print(editedImage.size)
            pickedImage = editedImage
        } else if let originalImage = info["UIImagePickerControllerOriginalImage"] as? UIImage {
            print(originalImage.size)
            pickedImage = originalImage
        }
        if let image = pickedImage {
            profileImageView.image = image
        }
        dismiss(animated: true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        print("cancelled picker")
        dismiss(animated: true, completion: nil)
    }
}
