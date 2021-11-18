
import Foundation

import Foundation
import UIKit
import FirebaseAuth
import SwiftUI

class cv:UIViewController {

    private let tableView :UITableView = {
       let table = UITableView()
        table.isHidden = true
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()

    private let noConversationLabel : UILabel = {
       let label = UILabel()
        label.text = "No Conversation"
        label.textAlignment = .center
        label.textColor = .label
        label.font = .systemFont(ofSize: 21,weight:.medium)
        label.isHidden = true
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        navigationItem.titleView?.backgroundColor = .systemIndigo
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
        tabBarItem.badgeColor = .systemIndigo

        view.backgroundColor = .systemBackground

        //configure()
    }
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        isLoggedIn()
    }

    @objc func didTapComposeButton() {
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
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
            configure()

        }
    }

    override func viewDidLayoutSubviews() {
        tableView.frame = view.bounds
    }

    func configure(){
        view.addSubview(tableView)
        setUpTableView()
        fetchConversation()
    }

    func fetchConversation(){
        tableView.isHidden = false
    }

    func setUpTableView(){
        tableView.delegate = self
        tableView.dataSource = self
    }
}

extension cv:UITableViewDelegate,UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }


    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell",for: indexPath)
        cell.textLabel?.text = "panchami"
        cell.accessoryType = .disclosureIndicator
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let vc = ChatViewController()
        vc.title = "panchami"
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }


}
