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
        print("ok")
        
        //unwrapping variables gotten from storyboard
        guard let email = emailTextField.text, let password = passwordTextField.text, let name = nameTextField.text else {
            print("Data is not valid")
            return
        }
        
        //Creating new user in database
        Auth.auth().createUser(withEmail: email, password: password) { (user, error) in
            print("ok")
            if error != nil {
                print(error!)
            }
            
            //Adding cathegory "users" in database and new child
            guard let uid = user?.uid else { return }
            
            //successfully authenticated user
            let imageName = NSUUID().uuidString
            
            let storageRef = Storage.storage().reference().child("profile_images").child("\(imageName).png")
            if let uploadData = UIImagePNGRepresentation(self.profileImageView.image!) {
                storageRef.putData(uploadData, metadata: nil, completion: { (metaData, error) in
                    if error != nil {
                        print(error!)
                        return
                    }
                    if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                        let values = ["name" : name, "email" : email, "password" : password, "profileImageUrl" : profileImageUrl]
                        
                        self.registerUserIntoDataBaseWithUID(uid: uid, values: values as [String : AnyObject])
                        
                    }
                    print(metaData!)
                })
            }
            
            
        }
        
        dismiss(animated: true, completion: nil)
    }
    
    private func registerUserIntoDataBaseWithUID(uid: String, values: [String : AnyObject]) {
        var ref : DatabaseReference
        ref = Database.database().reference()
        let usersRef = ref.child("users").child(uid)
        
//        let values = ["name" : name, "email" : email, "password" : password, "profileImageUrl" : metadata.downloadUrl()]
        usersRef.updateChildValues(values, withCompletionBlock: { (error, ref) in
            if error != nil{
                print(error!)
            }else{
                print("saved user successfully into firebase database")
            }
        })
    }
    
    @objc func handleSelectProfileImageView() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        present(picker, animated: true, completion: nil)
    }
    
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
