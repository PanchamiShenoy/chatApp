//
//  LoginViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 13/11/21.
//


import UIKit
import FirebaseAuth

class LoginViewController: UIViewController {
    var scrollView = UIScrollView()
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureOrientationObserver()
        
    }
    
    @objc func handleOrientationChange() {
        scrollView.contentSize = CGSize(width: view.frame.width, height: 650)
    }
    
    @objc func onLogin(){
        login.flash()
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
        title.textColor = color.green
        title.font = UIFont.systemFont(ofSize: 23, weight: .bold)
        return title
    }()

    let signup :UIButton = {
        let signup = UIButton()
        signup.setTitle("Don't have an account?Sign Up", for: .normal)
        signup.backgroundColor = color.background
        signup.setTitleColor(color.green, for: .normal)
        signup.heightAnchor.constraint(equalToConstant: 30).isActive = true
        signup.addTarget(self, action: #selector(onRegister), for: .touchUpInside)
        return signup
    }()
    
    let forgotPassword :UIButton = {
        let forgotPassword = UIButton()
        forgotPassword.setTitle("Forgot your password?", for: .normal)
        forgotPassword.backgroundColor = color.background
        forgotPassword.setTitleColor(color.green, for: .normal)
        forgotPassword.heightAnchor.constraint(equalToConstant: 30).isActive = true
        forgotPassword.addTarget(self, action: #selector(onForgotPassword), for: .touchUpInside)
        return forgotPassword
    }()
    
    let login : UIButton = {
        let login = UIButton()
        login.pulsate()
        login.setTitle("LOGIN", for: .normal)
        login.backgroundColor = color.green
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
    
    func configureOrientationObserver() {
        NotificationCenter.default.addObserver(self, selector: #selector(handleOrientationChange), name: UIDevice.orientationDidChangeNotification, object: nil)
    }
    
    func configure(){
        view.backgroundColor = color.background
        
        let stack = UIStackView(arrangedSubviews: [SignInTitle,emailContainer,passwordContainer,login,signup,forgotPassword])
        stack.axis = .vertical
        stack.spacing = 20
        
        stack.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints =  false
        
        view.addSubview(scrollView)
        scrollView.contentSize = CGSize(width: view.frame.width, height: 650)
        scrollView.addSubview(icon)
        scrollView.addSubview(stack)
        
        scrollView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
        
        icon.centerXAnchor.constraint(equalTo: scrollView.centerXAnchor).isActive = true
        icon.heightAnchor.constraint(equalToConstant: 250).isActive = true
        icon.widthAnchor.constraint(equalToConstant: 250).isActive = true
        
        icon.topAnchor.constraint(equalTo: scrollView.topAnchor,constant: 100).isActive = true
        stack.topAnchor.constraint(equalTo: icon.topAnchor,constant: 200).isActive = true
        stack.rightAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.rightAnchor,constant: -20).isActive = true
        stack.leftAnchor.constraint(equalTo: scrollView.safeAreaLayoutGuide.leftAnchor,constant: +20).isActive = true
        
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

