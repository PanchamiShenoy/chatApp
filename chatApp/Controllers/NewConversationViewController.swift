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
    
    var searching:Bool = false
    private var users = [User]()
    private var results = [User]()
    private var hasFetched = false
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    let searchController = UISearchController(searchResultsController: nil)
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
        configureCollectionView()
        configureUI()
        configureSearchBar()
        fetchAllUser()
        
    }
    
    func setupKeyboardObservers() {
       // NSNotificationC
    }
    
    func configureUI() {
        view.addSubview(noResultLabel)
        view.backgroundColor = .white
        navigationItem.title = "Select User"
        navigationItem.backButtonTitle = ""
    }
    
    func configureSearchBar(){
        searchController.loadViewIfNeeded()
        searchController.searchResultsUpdater = self
        searchController.searchBar.delegate = self
        searchController.obscuresBackgroundDuringPresentation = false
        searchController.searchBar.enablesReturnKeyAutomatically = false
        searchController.searchBar.returnKeyType = UIReturnKeyType.done
        self.navigationItem.searchController = searchController
        self.navigationItem.hidesSearchBarWhenScrolling = false
        definesPresentationContext = true
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
}

extension NewConversationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        let count = searching ? results.count : users.count
        return count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ConversationCell
        
        let user = searching ? results[indexPath.row] : users[indexPath.row]
        
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
        let selectedUser = searching ? results[indexPath.row] : users[indexPath.row]
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
            results = users
        }
        collectionView.reloadData()
    }
    
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        searching = false
        results = users
        collectionView.reloadData()
    }
    
}
