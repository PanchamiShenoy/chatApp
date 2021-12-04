//
//  LoginViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 13/11/21.
//


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
    }
    
    @objc func onLogin(){
        let error = validateFields()
        
        if error != nil {
            showAlert(title: "Error", messageContent:error!)
        }else{
            
        FirebaseAuth.Auth.auth().signIn(withEmail: emailTextField.text!, password: passwordTextField.text!) {[weak self] authResult, error in
            guard let strongSelf = self else{
                return
            }
            guard let result = authResult,error == nil else{
                print("failed to login")
                return
            }
            let user = result.user
            print("\n logged in ",user)
            UserDefaults.standard.set(self!.emailTextField.text!,forKey: "email")
            self!.dismiss(animated: true, completion: nil)
        }
            
        }
    }
    
    @objc func onRegister(){
        let signUpVC = SignUpViewController()
        signUpVC.modalPresentationStyle = .fullScreen
        present(signUpVC, animated: true, completion: nil)
    }
    @objc func onForgotPassword(){
        let resetVC = ResetPasswordViewController()
        resetVC.modalPresentationStyle = .fullScreen
        present(resetVC, animated: true, completion: nil)
    }
   let icon :UIImageView = {
        let image = UIImageView()
         image.image = UIImage(named: "imgicon")
         image.clipsToBounds = true
         image.contentMode = .scaleAspectFit
         image.layer.cornerRadius = 50
         image.translatesAutoresizingMaskIntoConstraints = false
         return image
    }()
    
    let SignInTitle : UILabel = {
      let title = UILabel()
        title.text = "SIGN IN"
        title.textAlignment = .center
        title.textColor = UIColor.systemIndigo
        title.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return title
    }()
    
    
    let signup :UIButton = {
        let signup = UIButton()
        signup.setTitle("Don't have an account?Sign Up", for: .normal)
        signup.backgroundColor = .systemBackground
        signup.setTitleColor(.label, for: .normal)
        signup.heightAnchor.constraint(equalToConstant: 30).isActive = true
        signup.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        return signup
    }()
    
    let forgotPassword :UIButton = {
        let forgotPassword = UIButton()
        forgotPassword.setTitle("Forgot your password?", for: .normal)
        forgotPassword.backgroundColor = .systemBackground
        forgotPassword.setTitleColor(.label, for: .normal)
        forgotPassword.heightAnchor.constraint(equalToConstant: 30).isActive = true
        forgotPassword.addTarget(self, action: #selector(onForgotPassword), for: .touchUpInside)
        return forgotPassword
    }()
    
    let login : UIButton = {
        let login = UIButton()
        login.setTitle("LOGIN", for: .normal)
        login.backgroundColor = .systemIndigo
        login.heightAnchor.constraint(equalToConstant: 50).isActive = true
        login.addTarget(self, action: #selector(onLogin), for: .touchUpInside)
        return login
    }()
    
    var emailTextField = CustomTextField(placeholder: "Email",isPassword: false)
    var passwordTextField = CustomTextField(placeholder: "Password",isPassword: true)
    
    lazy var emailContainer: CustomContainerView = {
        return CustomContainerView(image: UIImage(systemName: "envelope")!, textField: emailTextField)
        
    }()
    
    lazy var passwordContainer: CustomContainerView = {
        return CustomContainerView(image: UIImage(systemName: "eye")!, textField: passwordTextField)
    }()
    
    func configure(){
        view.backgroundColor = .systemBackground
        let stack = UIStackView(arrangedSubviews: [SignInTitle,emailContainer,passwordContainer,login,signup,forgotPassword])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(icon)
        view.addSubview(stack)
        icon.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 100).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 100).isActive = true
        icon.topAnchor.constraint(equalTo: view.topAnchor,constant: 100).isActive = true
        stack.topAnchor.constraint(equalTo: icon.topAnchor,constant: 200).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: +20).isActive = true
        
    }
    
    func validateFields() -> String? {
        
        if  emailTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" || passwordTextField.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in all details"
        }
        let cleanemail = emailTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if utilities.isEmailValid(cleanemail) == false {
            return "please enter a valid email "
        }
        let cleanpassword = passwordTextField.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if utilities.isPasswordValid(cleanpassword) == false {
            return "please enter a valid password "
        }
        return nil
    }
    
    func transitionToHome() {
        let homeViewController = storyboard?.instantiateViewController(withIdentifier:"ContainerViewController")
        
        view.window?.rootViewController = homeViewController
        view.window?.makeKeyAndVisible()
    }

}

