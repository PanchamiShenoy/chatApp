//
//  CollectionViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 18/11/21.
//

import UIKit
import FirebaseAuth
//private let reuseIdentifier = "Cell"
class CollectionViewController: UIViewController,UICollectionViewDelegate{
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
   
           }
       }
    func configureNavigationBar() {
            view.backgroundColor = .white
            
            let appearance = UINavigationBarAppearance()
            appearance.configureWithOpaqueBackground()
            appearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
            appearance.backgroundColor = .systemBackground
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem:.compose, target: self, action: #selector(didTapButton))
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose, target: self, action: #selector(didTapComposeButton))
            navigationController?.navigationBar.standardAppearance = appearance
            navigationController?.navigationBar.compactAppearance = appearance
        navigationController?.navigationBar.scrollEdgeAppearance = appearance
}
    
    @objc func didTapButton() {
        tapped = !tapped
        collectionView.reloadData()
    }
    @objc func didTapComposeButton() {
        let vc = NewConversationViewController()
        let navVc = UINavigationController(rootViewController: vc)
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

}
//extension CollectionViewController:UICollectionViewDelegate{
    
//}

extension CollectionViewController:UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("%%%%%%%%%%%%%%%")
        return 5
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "Cell", for: indexPath) as! ConversationCell
        cell.backgroundColor = .systemBackground
        cell.checkBox.isCheckBoxChecked = !tapped
        cell.checkBox.setBackground()
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let vc = ChatViewController()
        vc.title = "panchami"
        vc.navigationItem.largeTitleDisplayMode = .never
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
