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
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureUI()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        fetchUser()
    }
    
    @objc func onLogout(){
        do {
            let isLoggedOut = DatabaseManager.shared.onLogout()
            if isLoggedOut{
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
    }
    
    let image :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.backgroundColor = color.time
        image.tintColor = .white
        image.layer.cornerRadius = 50
        image.isUserInteractionEnabled = true
        return image
    }()
    
    let logout : UIButton = {
        let logout = UIButton()
        logout.setTitle("LOGOUT", for: .normal)
        logout.backgroundColor = color.green
        logout.heightAnchor.constraint(equalToConstant: 50).isActive = true
        logout.addTarget(self, action: #selector(onLogout), for: .touchUpInside)
        return logout
    }()
    
    let userName:UILabel = {
        let label = UILabel()
        label.textColor = color.white
        label.contentMode = .center
        label.textAlignment = .center
        return label
    }()
    
    let email:UILabel = {
        let label = UILabel()
        label.contentMode = .center
        label.textColor = color.white
        label.textAlignment = .center
        return label
    }()
    
    func configureUI(){
        let app = UINavigationBarAppearance()
        app.backgroundColor = color.navBarBackground
        let textAttributes = [NSAttributedString.Key.foregroundColor:color.white]
        app.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.scrollEdgeAppearance = app
        navigationItem.title = "Profile"
    }
    
    func fetchUser(){
        let uid = Auth.auth().currentUser?.uid
        DatabaseManager.shared.fetchCurrentUser(uid: uid!) { user in
            DispatchQueue.main.async {
                // self.currentUser = user
                self.userName.text = "USER NAME : "+user.username
                self.email.text = "EMAIL : "+user.email
                
            }
        }
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid!)") { image in
            DispatchQueue.main.async {
                self.image.image = image
                
            }
        }
    }
    
    func configure(){
        view.backgroundColor = color.background

        email.translatesAutoresizingMaskIntoConstraints = false
        logout.translatesAutoresizingMaskIntoConstraints = false
        userName.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
                
        let stack = UIStackView(arrangedSubviews: [userName,email])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        
        view.addSubview(stack)
        view.addSubview(image)
        view.addSubview(logout)
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor,constant: 120).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
        stack.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 40).isActive = true
        stack.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor,constant: -20).isActive = true
        stack.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor,constant: 20).isActive = true
        
        logout.topAnchor.constraint(equalTo: stack.bottomAnchor,constant: 20).isActive = true
        logout.centerXAnchor.constraint(equalTo:view.centerXAnchor).isActive = true
        logout.widthAnchor.constraint(equalToConstant: 200).isActive = true
    }
}
