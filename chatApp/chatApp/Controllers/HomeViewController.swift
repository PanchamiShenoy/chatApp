//
//  CollectionViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 18/11/21.
//

import UIKit
import FirebaseAuth
class CollectionViewController: UIViewController,UICollectionViewDelegate{
    var currentUser:User?
    var conversations: [ChatModel] = []
    
    var tapped :Bool = false
    var collectionView:UICollectionView!
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        isLoggedIn()
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
        view.backgroundColor = .white
        
        let appearance = UINavigationBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        appearance.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.edit, target: self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        navigationItem.leftBarButtonItem?.tintColor = .systemIndigo
        navigationItem.rightBarButtonItem?.tintColor = .systemIndigo
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
    
    @objc func didTapButton() {
        tapped = !tapped
        collectionView.reloadData()
    }
    @objc func didTapComposeButton() {
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
        vc.delegate = self
        vc.conversations = conversations
        vc.currentUser = currentUser
        present(navVc, animated: true, completion: nil)
    }
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        collectionView.backgroundColor = .systemBackground
        view.addSubview(collectionView)
        collectionView.delegate = self
        collectionView.dataSource = self
        // collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "Cell")
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: "Cell")
    }
    
    func photo()->NSMutableAttributedString{
        let attachment = NSTextAttachment()
        attachment.image = UIImage(systemName: "camera.fill")
        //attachment.image?.withTintColor(.secondaryLabel)
        // attachment.image?.withTintColor(UIColor.secondaryLabel)
        attachment.image = attachment.image?.withTintColor(UIColor.secondaryLabel)
        let attachmentString = NSAttributedString(attachment: attachment)
        let myString = NSMutableAttributedString(string:" photo")
        // myString.append(attachmentString)
        myString.insert(attachmentString, at: 0)
        //label.attributedText = myString
        return myString
    }
    
    
}

extension CollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("%%%%%%%%%%%%%%%")
        return conversations.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ConversationCell
        let chat = conversations[indexPath.row]
        let otherUser = chat.users[chat.otherUserIndex!]
        // let conversation = conversations[indexPath.row]
        cell.backgroundColor = .systemBackground
        cell.checkBox.isCheckBoxChecked = !tapped
        cell.checkBox.setBackground()
        cell.title.text = otherUser.username
        if chat.lastMessage?.message != ""{
            cell.message.text = chat.lastMessage?.message
        }else{
            cell.message.attributedText = photo()
        }
        
        let dateFormatter = DateFormatter()
        //        dateFormatter.dateFormat = "dd/MM/YY hh:mm:a"
        dateFormatter.dateFormat = "hh:mm:a"
        
        if chat.lastMessage == nil {
            cell.time.isHidden = true
        } else {
            cell.time.isHidden = false
            cell.time.text = dateFormatter.string(from: chat.lastMessage!.time)
        }
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(otherUser.uid)") { image in
            cell.image.image = image
        }
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        //let user = conversations[indexPath.row]
        let vc = ChatViewController()
        //  vc.title = user.username
        vc.currentUser = currentUser
        vc.chat = conversations[indexPath.row]
        vc.navigationItem.largeTitleDisplayMode = .never
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
        // showChatController(forUser: user)
        let vc = ChatViewController()
        vc.chat = chat
        //vc.otherUser = otherUser
        vc.hidesBottomBarWhenPushed = true;
        navigationController?.pushViewController(vc, animated: true)
    }
}
