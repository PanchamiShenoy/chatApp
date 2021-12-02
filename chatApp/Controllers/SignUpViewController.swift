//
//  SignUpViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 13/11/21.
//

import UIKit
import FirebaseAuth
class SignUpViewController: UIViewController {
    @objc func didTapProfilePic() {
        presentPhotoActionSheet()
    }
    
    @objc func onAccountExist(){
        dismiss(animated: true, completion: nil)
    }
    
    let signUp : UIButton = {
        let login = UIButton()
        login.setTitle("SIGN UP", for: .normal)
        login.backgroundColor = .systemIndigo
        login.heightAnchor.constraint(equalToConstant: 50).isActive = true
        login.addTarget(self, action: #selector(onSignUp), for: .touchUpInside)
        return login
    }()
    
    let image :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.backgroundColor = UIColor.gray
        image.tintColor = UIColor.white
        image.layer.cornerRadius = 50
        image.isUserInteractionEnabled = true
        return image
    }()
    let signIn :UIButton = {
        let signIn = UIButton()
        signIn.setTitle("Already have an account?Login In", for: .normal)
        signIn.backgroundColor = .systemBackground
        signIn.setTitleColor(.label, for: .normal)
        signIn.heightAnchor.constraint(equalToConstant: 50).isActive = true
        signIn.addTarget(self, action: #selector(onAccountExist), for: .touchUpInside)
        return signIn
    }()
    
    var firstName = CustomTextField(placeholder: "firstName",isPassword: false)
    var lastName = CustomTextField(placeholder: "lastName",isPassword: false)
    var email = CustomTextField(placeholder: "email",isPassword:false)
    var password = CustomTextField(placeholder: "password",isPassword: true)
    lazy var containerFirstName = CustomContainerView(image: UIImage(systemName: "person.fill")!, textField:firstName)
    lazy var containerlastName = CustomContainerView(image: UIImage(systemName: "person.fill")!, textField:lastName)
    lazy var containerEmail = CustomContainerView(image: UIImage(systemName: "envelope")!, textField:email)
    lazy var containerPassword = CustomContainerView(image: UIImage(systemName: "eye")!, textField:password)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configure()
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        image.addGestureRecognizer(gesture)
        // Do any additional setup after loading the view.
    }
    
    func configure(){
        view.backgroundColor = .systemBackground
        view.addSubview(image)
        email.translatesAutoresizingMaskIntoConstraints = false
        password.translatesAutoresizingMaskIntoConstraints = false
        signUp.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        
        
        let stack = UIStackView(arrangedSubviews: [containerFirstName,containerlastName,containerEmail,containerPassword,signUp,signIn])
        stack.translatesAutoresizingMaskIntoConstraints = false
        stack.axis = .vertical
        stack.spacing = 20
        view.addSubview(stack)
        
        stack.topAnchor.constraint(equalTo: image.bottomAnchor,constant: 40).isActive = true
        stack.rightAnchor.constraint(equalTo: view.rightAnchor,constant: -20).isActive = true
        stack.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 20).isActive = true
        
        image.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        image.topAnchor.constraint(equalTo: view.topAnchor,constant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 100).isActive = true
        image.widthAnchor.constraint(equalToConstant: 100).isActive = true
        
    }
    
    @objc func onSignUp(){
        let error = validateFields()
        
        if error != nil {
            showAlert(title: "ERROR", messageContent: error!)
            return
        }
        else{
            let firstName = firstName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let secondName = lastName.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let email = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let password = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
            let  profilePic = image.image
            
            FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password) { [weak self] authResult, error in
                guard authResult != nil, error == nil else {
                    self?.showAlert(title: "ERROR", messageContent: "erroe in creating user")
                    return
                }
                let uid = authResult?.user.uid
                
                StorageManager.shared.uploadImage(image: profilePic!, uid: uid!) { url in
                    let newUser = User(username: firstName + secondName, email: email, profileURL: url, uid: uid!)
                    DatabaseManager.shared.addUser(user: newUser)
                    // self?.delegate?.userAuthenticated()
                    self?.dismiss(animated: true)
                }
                self?.presentingViewController?.presentingViewController?.dismiss(animated: true, completion: nil)
            }
            
            
            
            
            
        }
        // dismiss(animated: true, completion: nil)
    }
    
    func validateFields() -> String? {
        
        if firstName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            lastName.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            email.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" ||
            password.text?.trimmingCharacters(in: .whitespacesAndNewlines) == "" {
            return "please fill in all details"
        }
        let cleanemail = email.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if utilities.isEmailValid(cleanemail) == false {
            return "please enter a valid email "
        }
        let cleanpassword = password.text!.trimmingCharacters(in: .whitespacesAndNewlines)
        if utilities.isPasswordValid(cleanpassword) == false {
            return "please enter a valid password "
        }
        return nil
    }
    
    
    
}
extension SignUpViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Take Photi", style: .default, handler:nil))
        present(actionSheet, animated: true, completion: nil)
    }
    func presentCamera(){
        let vc =  UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    func presentPhotoLibrary() {
        let vc =  UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        self.image.image = selectedImage
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
