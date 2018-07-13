//
//  NewMessageController.swift
//  CoolMessanger
//
//  Created by Oleg on 11.07.2018.
//  Copyright © 2018 Oleg. All rights reserved.
//

import UIKit
import Firebase

let cellId = "cellId"

class NewMessageController: UITableViewController {
    
    var users = [User]()
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(userCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }

    @objc func handleCancel() {
        dismiss(animated: true, completion: nil)
    }
    
    func fetchUser() {
        Database.database().reference().child("users").observe(.childAdded, with: { (snapshot) in
            print(snapshot)
            
            if let dictionary = snapshot.value as? [String : AnyObject] {
                let user = User()
                user.name = dictionary["name"] as? String
                user.email = dictionary["email"] as? String
                user.password = dictionary["password"] as? String
                self.users.append(user)
                DispatchQueue.main.async(execute: {
                     self.tableView.reloadData()
                })
            }
        }, withCancel: nil)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath)
        
        let user = users[indexPath.row]
        cell.textLabel?.text = user.name
        cell.detailTextLabel?.text = user.email
        return cell
    }
    

}

class userCell: UITableViewCell {
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: cellId)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
