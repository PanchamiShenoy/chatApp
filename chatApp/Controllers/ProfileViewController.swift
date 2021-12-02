//
//  ProfileViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import UIKit
import FirebaseAuth
import SwiftUI

class ProfileViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    
    var imageView:UIImageView!
    let data = ["Logout"]
    var path : String!
    override func viewDidLoad() {
        super.viewDidLoad()
        print(FirebaseAuth.Auth.auth().currentUser?.uid)
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    override func viewDidAppear(_ animated: Bool) {
        tableView.tableHeaderView = createTableHeader()
        fetchUser()
    }
    func createTableHeader()->UIView? {
        
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width:view.frame.width, height: 200))
        headerView.backgroundColor = UIColor.systemIndigo
        
        imageView = UIImageView(frame: CGRect(x: (view.frame.width-150)/2, y: 30, width: 150, height: 150))
        imageView.contentMode = .scaleAspectFill
        imageView.layer.borderColor = UIColor.white.cgColor
        imageView.layer.borderWidth = 2
        imageView.layer.cornerRadius = 70
        imageView.layer.masksToBounds = true
        imageView.tintColor = .white
        imageView.image = UIImage(systemName: "person.fill")
        headerView.addSubview(imageView)
        return headerView
        
    }
    func fetchUser(){
        print("))))))))))))))))))))))))))))))")
        let uid = Auth.auth().currentUser?.uid
        print( "Profile/\(uid)")
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid!)") { image in
            print("((((((((((((((((((((((((((")
            DispatchQueue.main.async {
                self.imageView.image = image
                
            }
        }
        
        
    }
    
}


extension ProfileViewController : UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = data[indexPath.row]
        cell.textLabel?.textAlignment = .center
        cell.textLabel?.textColor = .label
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        do {
            let isLoggedOut = DatabaseManager.shared.onLogout()
            if isLoggedOut{
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        
    }
}
