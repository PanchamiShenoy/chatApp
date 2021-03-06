//
//  GroupChatViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 06/12/21.
//

import UIKit
import FirebaseAuth
import SwiftUI
class GroupChatViewController: UIViewController {
    var delegate:GroupChatControllerdelegate?
    var currentUser: User!
    var users: [User] = []
    var collectionView: UICollectionView!
    let cellIdentifier = "GCCell"
    var selectedUsers:[IndexPath] = []
    
    override func viewDidLoad(){
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapProfilePic))
        image.addGestureRecognizer(gesture)
        configureCollectionView()
        fetchAllUsers()
        configureUI()
        fetchCurrentUser()
        
    }
    
    @objc func didTapProfilePic() {
        presentPhotoActionSheet()
    }
    @objc func didTapComposeButton(){
        let chatVC = ChatViewController()
        
        let chatID = "\(groupName.text!)_\(UUID())"
        let photoPath = "Profile/\(chatID)"
        var userArray: [User] = []
        userArray.append(currentUser)
        
        for indexPath in selectedUsers {
            let user = users[indexPath.row]
            userArray.append(user)
        }
        StorageManager.shared.uploadMeesageImage(image: image.image!, path: photoPath) { url in
            
        }
        DatabaseManager.shared.addGroupChat(users: userArray, id: chatID, isGroupChat: true, groupChatName: groupName.text, groupChatProfilePath: photoPath)
        
        let chat = ChatModel( users: userArray,lastMessage: nil, messagesArray: [],chatId:chatID,isGroupChat: true, groupChatName: groupName.text, groupChatProfilePath: photoPath)
        
        delegate?.controllerGroupChat(wantsToStartChatWith: chat)
        
    }
    
    @objc func onClose(){
        dismiss(animated: true)
    }
    
    let image :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFit
        image.backgroundColor = color.gray
        image.tintColor = UIColor.white
        image.layer.cornerRadius = 50
        image.isUserInteractionEnabled = true
        return image
    }()
    var groupName = CustomTextField(placeholder: "Enter Group Name",isPassword: false)
    lazy var containerGroupName = CustomContainerView(image: UIImage(systemName: "person.3.fill")!, textField:groupName)
   
    func fetchCurrentUser(){
        let uid = Auth.auth().currentUser?.uid
        DatabaseManager.shared.fetchCurrentUser(uid:uid!) { currentUser in
            self.currentUser = currentUser
        }
    }

    func configureUI(){
        view.backgroundColor = color.background
        
        navigationItem.title = "Group Chats"
        
        let app = UINavigationBarAppearance()
        app.backgroundColor = color.navBarBackground
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)]
        app.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.scrollEdgeAppearance = app
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"arrow.left" ), style: .plain, target: self, action: #selector(onClose))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem?.tintColor = color.navItem
        navigationItem.rightBarButtonItem?.tintColor = color.navItem
        
        view.addSubview(collectionView)
        view.addSubview(image)
        view.addSubview(containerGroupName)
        
        image.translatesAutoresizingMaskIntoConstraints = false
        groupName.translatesAutoresizingMaskIntoConstraints = false
        containerGroupName.translatesAutoresizingMaskIntoConstraints = false
        collectionView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            
            image.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 10),
            image.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            image.heightAnchor.constraint(equalToConstant: 100),
            image.widthAnchor.constraint(equalToConstant: 100),
            
            containerGroupName.topAnchor.constraint(equalTo: image.bottomAnchor, constant: 20),
            containerGroupName.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 20),
            containerGroupName.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor, constant: -20),
            
            collectionView.topAnchor.constraint(equalTo: containerGroupName.bottomAnchor, constant: 20),
            collectionView.leftAnchor.constraint(equalTo: view.leftAnchor),
            collectionView.rightAnchor.constraint(equalTo: view.rightAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ])
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = color.background
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier:cellIdentifier)
    }
    
    func fetchAllUsers() {
        let uidString :String = FirebaseAuth.Auth.auth().currentUser!.uid
        DatabaseManager.shared.fetchAllUsers(uid:uidString) { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
}
extension GroupChatViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ConversationCell
        
        let user = users[indexPath.row]
        cell.title.text = user.username
        cell.time.isHidden = true
        cell.checkBox.isHidden = true
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(user.uid)") { image in
            cell.image.image = image
        }
        
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //        let selectedUser = users[indexPath.row]
        //        if selectedUsers.contains(selectedUser){
        //            selectedUsers.removeAll { value in
        //              return value == selectedUser
        //            }
        //        }
        let selectedCell: UICollectionViewCell = collectionView.cellForItem(at: indexPath)!
        if selectedUsers.contains(indexPath) {
            selectedUsers.removeAll{ value in
                return value == indexPath
            }
            selectedCell.backgroundColor = .white
        } else {
            selectedUsers.append(indexPath)
            selectedCell.backgroundColor = .opaqueSeparator
        }
    }
}
extension GroupChatViewController: UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 90)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
}

extension GroupChatViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Profile picture", message: "How would like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
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

protocol GroupChatControllerdelegate: AnyObject {
    func controllerGroupChat(wantsToStartChatWith chat: ChatModel)
}
