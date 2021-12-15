//
//  NewConversationViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.

import UIKit
import FirebaseAuth
import NotificationCenter

class NewConversationViewController:UIViewController,UICollectionViewDelegate{
    
    let cellIdentifier = "userCell"
    var conversations:[ChatModel] = []
    var currentUser: User?
    weak var delegate: NewMessageControllerdelegate?
    var searching:Bool = false
    private var users = [User]()
    private var results = [User]()
    private var hasFetched = false
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    let searchController = UISearchController(searchResultsController: nil)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureCollectionView()
        configureUI()
        configureSearchBar()
        fetchAllUser()
        DatabaseManager.shared.fetchCurrentUser(uid:uid) { currentUser in
            self.currentUser = currentUser
        }
    }
    
    @objc func searchContact(){
        self.navigationItem.searchController?.searchBar.isHidden = false
        self.navigationItem.searchController = searchController
    }
    
    @objc func dismissNewConversation(){
        dismiss(animated: true, completion: nil)
    }
    
    @objc func onClose(){
        dismiss(animated: true)
    }
    
    let noResultLabel:UILabel = {
        let label = UILabel()
        label.text = "no results"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = true
        return label
    }()
    
    func configureUI() {
        view.addSubview(noResultLabel)
        noResultLabel.translatesAutoresizingMaskIntoConstraints = false
        noResultLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
        noResultLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
        noResultLabel.textColor = color.white
        
        view.backgroundColor = color.background
        
        navigationItem.title = "Select Contact"
       
        let app = UINavigationBarAppearance()
        app.backgroundColor = color.navBarBackground
        let textAttributes = [NSAttributedString.Key.foregroundColor:UIColor(red: 0.616, green: 0.647, blue: 0.675, alpha: 1)]
        app.titleTextAttributes = textAttributes
        self.navigationController?.navigationBar.scrollEdgeAppearance = app
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: UIImage(systemName:"arrow.left" ), style: .plain, target: self, action: #selector(onClose))
        navigationItem.leftBarButtonItem?.tintColor = color.navItem
        let searchIcon = UIBarButtonItem(barButtonSystemItem: .search, target:self, action:#selector(searchContact) )
        navigationItem.rightBarButtonItems = [searchIcon]
        navigationItem.rightBarButtonItem?.tintColor = color.navItem
        
    }
    
    func configureSearchBar(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.searchBar.tintColor = color.white
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
    }
    
    func configureCollectionView() {
        collectionView = UICollectionView(frame: view.bounds, collectionViewLayout: UICollectionViewFlowLayout())
        view.addSubview(collectionView)
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = color.background
        collectionView.register(ConversationCell.self, forCellWithReuseIdentifier: cellIdentifier)
    }
    
    func fetchAllUser() {
        DatabaseManager.shared.fetchAllUsers(uid: uid) { users in
            self.users = users
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
}

extension NewConversationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = searching ? results.count : users.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ConversationCell
        
        let user = searching ? results[indexPath.row] : users[indexPath.row]
        cell.message.text = user.username
        cell.time.isHidden = true
        cell.checkBox.isHidden =  true
        let uid = user.uid
        
        StorageManager.shared.downloadImageWithPath(path: "Profile/\(uid)") { image in
            cell.image.image = image
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        let selectedUser = searching ? results[indexPath.row] : users[indexPath.row]
        let id = "\(currentUser!.uid)_\(selectedUser.uid)"
        let chatVC = ChatViewController()
        for chat in conversations {
            if chat.isGroupChat {
                continue
            }
            var currentChat = chat
            let uid1 = chat.users[0].uid
            let uid2 = chat.users[1].uid
            if uid1 == currentUser!.uid && uid2 == selectedUser.uid || uid1 == selectedUser.uid && uid2 == currentUser!.uid {
                print("Already Chated")
                currentChat.otherUserIndex = uid1 == currentUser!.uid ? 1 : 0
                delegate?.controller(self, wantsToStartChatWith: currentChat)
                return
            }
        }
        print("New Chat")
        let userList :[User] = [currentUser!,selectedUser]
        DatabaseManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        var chat = ChatModel(users:userList, lastMessage: nil, messagesArray: [], otherUserIndex: 1,chatId: id,isGroupChat:false)
        delegate?.controller(self, wantsToStartChatWith: chat)
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

extension NewConversationViewController:UISearchResultsUpdating,UISearchBarDelegate{
    func updateSearchResults(for searchController: UISearchController) {
        let count = searchController.searchBar.text?.count
        let searchText = searchController.searchBar.text!
        if !searchText.isEmpty {
            searching = true
            results.removeAll()
            results = users.filter({$0.username.prefix(count!).lowercased() == searchText.lowercased()})
        }
        else{
            searching = false
            noResultLabel.isHidden = true
            results = users
        }
        if results.isEmpty {
            noResultLabel.isHidden = false
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        results = users
        noResultLabel.isHidden = true
        self.navigationItem.searchController?.searchBar.isHidden = true
        collectionView.reloadData()
    }
    
}

protocol NewMessageControllerdelegate: AnyObject {
    func controller(_ controller: NewConversationViewController, wantsToStartChatWith chat: ChatModel)
}
