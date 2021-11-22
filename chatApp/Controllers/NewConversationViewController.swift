//
//  NewConversationViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.

import UIKit
import FirebaseAuth
class NewConversationViewController:UIViewController,UICollectionViewDelegate{
let cellIdentifier = "userCell"
    var conversations:[ChatModel] = []
    private var users = [User]()
    private var results = [User]()
    private var hasFetched = false
    var currentUser: User?
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    private let searchBar :UISearchBar = {
       let searchBar = UISearchBar()
        searchBar.placeholder = "Search for users"
        return searchBar
    }()
    let noResultLabel:UILabel = {
        let label = UILabel()
        label.text = "no results"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureNavigationBar()
        searchBar.delegate = self
        configureCollectionView()
        configureUI()
        fetchAllUser()
        
    }
    
    func configureUI() {
        view.addSubview(noResultLabel)
        view.backgroundColor = .white
        navigationItem.title = "Select User"
        navigationItem.backButtonTitle = ""
       // navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.compose, target: self, action: #selector(handleSearch))
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done,target: self,action: #selector(dismissNewConversation))
        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:, style: .plain, target: self, action: #selector(handleSearch))
        
        //navigationItem.rightBarButtonItems = [search]
    }
    @objc func dismissNewConversation(){
        dismiss(animated: true, completion: nil)
    }
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func fetchAllUser() {
        DatabaseManager.shared.fetchAllUsers(uid: uid) { users in
            self.users = users
           // self.results = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    func filterUsers(term:String) {
        guard hasFetched else {
            return
        }
        print("@@@@@@@@@@@@@@")
        print(self.users)
        self.results = self.users.filter({$0.username.lowercased().contains(term.lowercased())
        })
        print(results)
        updateUI()
    }
    
    func updateUI(){
        if results.isEmpty {
            self.collectionView.isHidden = true
            self.noResultLabel.isHidden = false
        }else{
            self.collectionView.isHidden = false
            self.noResultLabel.isHidden = true
        }
        self.collectionView.reloadData()
    }
}

extension NewConversationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return results.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ConversationCell
        
        let user = results[indexPath.row]
        
            //cell.text = user.email
        cell.message.text = user.username
        cell.time.isHidden = true
        cell.checkBox.isHidden =  true
       // cell.selectButton.isHidden = true
        
        let uid = user.uid
        
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.image.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let selectedUser = results[indexPath.row]
               let users: [User] = [currentUser!, selectedUser]
               
               let id = "\(currentUser!.uid)_\(selectedUser.uid)"
               let chatVC = ChatViewController()
        for chat in conversations {
              var currentChat = chat
              let uid1 = chat.users[0].uid
              let uid2 = chat.users[1].uid
              if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                print("Already Chated")
                currentChat.otherUserIndex = uid1 == currentUser!.uid ? 1 : 0
                chatVC.chat = currentChat
                  chatVC.title = selectedUser.username
                navigationController?.pushViewController(chatVC, animated: true)
                return
              }
            }
        print("New Chat")
        DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        chatVC.chat = ChatModel(users: users, lastMessage: nil, messagesArray: [], otherUserIndex: 1,chatId: id)
        present(chatVC, animated: true, completion: nil)
           }
        
    }


extension NewConversationViewController: UICollectionViewDelegateFlowLayout {
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

extension NewConversationViewController :UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text,!text.replacingOccurrences(of: " ", with: "").isEmpty else {
            //print("\n\n ooooooooooooooo")
            return
        }
        print("***********************")
        results.removeAll()
        searchBar.resignFirstResponder()
        self.searchUsers(query:text)
    }
    func searchUsers(query:String) {
        print("\n\n searching")
        if hasFetched {
            filterUsers(term: query)
        }else{
            let uid = Auth.auth().currentUser?.uid
             DatabaseManager.shared.fetchAllUsers(uid: uid!) { users in
                 self.users = users
                 self.hasFetched = true
                 print(self.users)
                 self.filterUsers(term: query)
                 DispatchQueue.main.async {
                     self.collectionView.reloadData()
                 }
             }

        }
    }
    
   
}
