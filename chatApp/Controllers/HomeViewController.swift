//
//  CollectionViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 18/11/21.
//

import UIKit
import FirebaseAuth
import SwiftUI
class CollectionViewController: UIViewController,UICollectionViewDelegate{
    var currentUser:User?
    var conversations: [ChatModel] = []
    
    var tapped :Bool = false
    var collectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        isLoggedIn()
    }
    
    @objc func didTapButton() {
        let vc = GroupChatViewController()
        let navVc = UINavigationController(rootViewController: vc)
        vc.delegate = self
        vc.hidesBottomBarWhenPushed = true
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
    }
    @objc func didTapComposeButton() {
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
        vc.delegate = self
        vc.conversations = conversations
        navVc.modalPresentationStyle = .fullScreen
        present(navVc, animated: true, completion: nil)
    }
    
    func isLoggedIn() {
        if FirebaseAuth.Auth.auth().currentUser == nil {
            DispatchQueue.main.async {
                let vc = LoginViewController()
                vc.modalPresentationStyle = .fullScreen
                self.present(vc, animated: true)
            }
        }
        else{
            configureNavigationBar()
            configureCollectionView()
            fetchCurrentUserDetails()
            
        }
    }
    
    func configureNavigationBar() {
        navigationItem.title = "ChatApp"
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.titleTextAttributes = [.foregroundColor: UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)]
        appearance.backgroundColor = color.navBarBackground
        let attributes = [NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Light", size: 17)!]
        UINavigationBar.appearance().titleTextAttributes = attributes
        
        let search = UIBarButtonItem(barButtonSystemItem: .search, target: self, action: #selector(didTapComposeButton))
        let groupChat = UIBarButtonItem(image:UIImage(systemName:"person.3.fill" ), style:.plain, target:self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItems = [search,groupChat]
        navigationItem.rightBarButtonItem?.tintColor = color.navItem
        groupChat.tintColor = color.navItem
        navigationController?.navigationBar.standardAppearance = appearance
        navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
    }
    
    func fetchCurrentUserDetails() {
        let uid = Auth.auth().currentUser?.uid
        DatabaseManager.shared.fetchCurrentUser(uid:uid!) { currentUser in
            self.currentUser = currentUser
        }
        
        DatabaseManager.shared.fetchChats(uid: uid!) { conversation in
            self.conversations = conversation
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
        
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = color.background
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func photoIcon()->NSMutableAttributedString{
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "camera.fill")
        attachment.image = attachment.image?.withTintColor(color.message)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string:" photo")
        myString.insert(attachmentString, at: 0)
        return myString
    }
    
    
}

extension CollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return conversations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ConversationCell
        let chat = conversations[indexPath.row]
    
        cell.checkBox.isCheckBoxChecked = !tapped
        cell.checkBox.setBackground()
        cell.checkBox.isHidden = true
        if chat.lastMessage?.message != ""{
            cell.message.text = chat.lastMessage?.message
        }else{
            cell.message.attributedText = photoIcon()
        }
        var path :String
        if chat.isGroupChat{
            path = chat.groupChatProfilePath!
            cell.title.text = chat.groupChatName
        }
        else {
            let otherUser = chat.users[chat.otherUserIndex!]
            cell.title.text = otherUser.username
            path = "Profile/\(otherUser.uid)"
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            cell.time.isHidden = true
        } else {
            cell.time.isHidden = false
            cell.time.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        
        StorageManager.shared.downloadImageWithPath(path:path) { image in
            cell.image.image = image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.currentUser = currentUser
        vc.chat = conversations[indexPath.row]
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.navigationBar.tintColor = color.white
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true)
    }
    
}

extension CollectionViewController:UICollectionViewDelegateFlowLayout{
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width, height: 80)
    }
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 0
    }
    
}
extension CollectionViewController: NewMessageControllerdelegate {
    func controller(_ controller: NewConversationViewController, wantsToStartChatWith chat: ChatModel) {
        dismiss(animated: true, completion: nil)
        let vc = ChatViewController()
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true)
    }
}

extension CollectionViewController: GroupChatControllerdelegate {
    func controllerGroupChat(wantsToStartChatWith chat: ChatModel) {
        dismiss(animated: true, completion: nil)
        let vc = ChatViewController()
        vc.chat = chat
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true)
    }
}
