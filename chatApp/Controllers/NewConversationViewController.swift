//
//  NewConversationViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import UIKit

//class NewConversationViewController: UIViewController {
//
//    private var users = [[String:String]]()
//    private var results = [[String:String]]()
//    private var hasFetched = false
//
//    private let searchBar :UISearchBar = {
//       let searchBar = UISearchBar()
//        searchBar.placeholder = "Search for users"
//        return searchBar
//    }()
//
//    private let tableView:UITableView = {
//        let table = UITableView()
//        table.isHidden =  true
//        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
//        return table
//    }()
//
//    let noResultLabel:UILabel = {
//        let label = UILabel()
//        label.text = "no results"
//        label.textAlignment = .center
//        label.textColor = .label
//        label.font = .systemFont(ofSize: 21, weight: .medium)
//        label.isHidden = true
//        return label
//    }()
//
//    override func viewDidLoad() {
//        super.viewDidLoad()
//        view.addSubview(tableView)
//        view.addSubview(noResultLabel)
//       // searchBar.becomeFirstResponder()
//       // DatabaseManager.shared.getAllUsers { Result<[[String : String]], Error> in
//
//        //}
//        searchBar.delegate = self
//        tableView.delegate = self
//        tableView.dataSource = self
//        view.backgroundColor = .white
//        navigationController?.navigationBar.topItem?.titleView = searchBar
//        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel", style: .done,target: self,action: #selector(dismissNewConversation))
//    }
//
//    @objc func dismissNewConversation(){
//        dismiss(animated: true, completion: nil)
//    }
//
//    override func viewDidLayoutSubviews() {
//        tableView.frame = view.bounds
//        noResultLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.height-200)/2, width: view.frame.width/2, height: 200)
//    }
//
//}
//extension NewConversationViewController:UITableViewDelegate,UITableViewDataSource{
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return results.count
//    }
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
//        cell.textLabel?.text = results[indexPath.row]["name"]
//        return cell
//    }
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        tableView.deselectRow(at: indexPath, animated: true)
//
//    }
//}
//extension NewConversationViewController :UISearchBarDelegate {
//    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
//        guard let text = searchBar.text,!text.replacingOccurrences(of: " ", with: "").isEmpty else {
//            //print("\n\n ooooooooooooooo")
//            return
//        }
//        results.removeAll()
//        searchBar.resignFirstResponder()
//        self.searchUsers(query:text)
//    }
//    func searchUsers(query:String) {
//        print("\n\n searching")
//        if hasFetched {
//            filterUsers(term: query)
//        }else{
//            //print("\n\n&&&&&&&&&&&&&&&&&&&&&&")
//            DatabaseManager.shared.getAllUsers(completion: { [weak self] result in
//                switch result {
//                case .success(let userCollection):
//                    self?.hasFetched = true
//                    self?.users = userCollection
//                    self?.filterUsers(term: query)
//                   // print("\n\n***********************")
//                case .failure(let error):
//                    print("failed to get users")
//                }
//            })
//        }
//    }
//
//    func filterUsers(term:String) {
//        guard hasFetched else {
//            return
//        }
//        var results:[[String:String]] = self.users.filter({
//            guard let name = $0["name"]?.lowercased() else {
//                return false
//            }
//            return name.hasPrefix(term.lowercased())
//        })
//        self.results = results
//        updateUI()
//    }
//
//    func updateUI(){
//        if results.isEmpty {
//            self.tableView.isHidden = true
//            self.noResultLabel.isHidden = false
//        }else{
//            self.tableView.isHidden = false
//            self.noResultLabel.isHidden = true
//        }
//        self.tableView.reloadData()
//    }
//}
import UIKit
import FirebaseAuth
class NewConversationViewController:UIViewController,UICollectionViewDelegate{
let cellIdentifier = "userCell"
    
    var users: [UserData] = []
    var currentUser: UserData?
    var collectionView: UICollectionView!
    var uid :String = FirebaseAuth.Auth.auth().currentUser!.uid
    override func viewDidLoad() {
        super.viewDidLoad()
        //configureNavigationBar()
        configureCollectionView()
        configureUI()
        fetchAllUser()
        
    }
    
    func configureUI() {
        view.backgroundColor = .white
        navigationItem.title = "Select User"
        navigationItem.backButtonTitle = ""
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.compose, target: self, action: #selector(handleSearch))

        //navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:, style: .plain, target: self, action: #selector(handleSearch))
        
        //navigationItem.rightBarButtonItems = [search]
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
            DispatchQueue.main.async {
                self.collectionView.reloadData()
            }
        }
    }
    
    @objc func handleSearch() {
        
    }
}

extension NewConversationViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return users.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: cellIdentifier, for: indexPath) as! ConversationCell
        
        let user = users[indexPath.row]
        
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
       // let selectedUser = users[indexPath.row]
      //  let users: [UserData] = [currentUser!, selectedUser]
        
       // let id = "\(currentUser!.uid)_\(selectedUser.uid)"
        
       // NetworkManager.shared.addChat(user1: currentUser!, user2: selectedUser, id: id)
        let chat = ChatViewController()
        //chat.chat = Chats(users: users, lastMessage: nil, messages: [], otherUser: 1)
        
        navigationController?.pushViewController(chat, animated: true)
        
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
