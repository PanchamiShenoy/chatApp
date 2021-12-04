//
//  ResetPasswordViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 04/12/21.
//

import UIKit
import FirebaseAuth
class ResetPasswordViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        // Do any additional setup after loading the view.
    }
    @objc func onReset(){
       // showAlert(title: "ERROR", messageContent: "Not able to reset Password")
        Auth.auth().sendPasswordReset(withEmail: emailTextField.text!) { error in
            if error != nil {
                // showAlert(title: "ERROR", messageContent: "Not able to reset Password")
                print("mail not sent")
                self.transitionToLogin()
            }
            print("mail sent")
            self.transitionToLogin()
        }
       
    }
    func transitionToLogin(){
        self.dismiss(animated: true, completion: nil)

    }
    let forgotPasswordTitle : UILabel = {
      let title = UILabel()
        title.text = "FORGOT PASSWORD"
        title.textAlignment = .center
        title.textColor = UIColor.systemIndigo
        title.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return title
    }()
    var emailTextField = CustomTextField(placeholder: "Email",isPassword: false)
    let forgotPassword : UIButton = {
        let forgotPassword = UIButton()
        forgotPassword.setTitle("LOGIN", for: .normal)
        forgotPassword.backgroundColor = .systemIndigo
        forgotPassword.heightAnchor.constraint(equalToConstant: 50).isActive = true
        forgotPassword.addTarget(self, action: #selector(onReset), for: .touchUpInside)
        return forgotPassword
    }()
    
    lazy var emailContainer: CustomContainerView = {
        return CustomContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        
    }()
    
    func configure(){
        view.backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [forgotPasswordTitle,emailContainer,forgotPassword])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        stack.topAnchor.constraint(equalTo: view.topAnchor,constant: 200).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: +20).isActive = true
        
    }
}
