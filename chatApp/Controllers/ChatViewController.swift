//
//  ChatViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//
import UIKit
class ChatViewController:UITableViewController {

    var messages: [MessageModel] = []
    let cellIdentifier = "chatCell"
    var otherUser: User!
    var currentUser: User!
    var chatId: String?
    var chat:ChatModel!
    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
        fetchMessages()
        view.backgroundColor = .systemBackground
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);
        
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
        lazy var inputContainerView:UIView = {
            let conatinerView = UIView()
            conatinerView.translatesAutoresizingMaskIntoConstraints = false
            conatinerView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            conatinerView.bottomAnchor.constraint(equalTo: view.bottomAnchor).isActive = true
            conatinerView.widthAnchor.constraint(equalTo: view.widthAnchor).isActive = true
            conatinerView.heightAnchor.constraint(equalToConstant:50).isActive = true
            view.addSubview(conatinerView)
            //conatinerView.backgroundColor = .red
            conatinerView.frame = CGRect(x: 0, y: 0, width: self.view.frame.width, height: 50)
            conatinerView.backgroundColor =  .gray
        let textField1 = CustomTextField(placeholder: "Type...", isPassword: false)
        let sendButton:UIButton = {
           let sendButton = UIButton()
            sendButton.backgroundColor = .systemIndigo
            sendButton.setTitle("Send", for: .normal)
            sendButton.setTitleColor(.white, for: .normal)
            sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)

            //sendButton.layer.cornerRadius = 50
            //sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
            return sendButton
        }()

        textField1.translatesAutoresizingMaskIntoConstraints = false
    sendButton.translatesAutoresizingMaskIntoConstraints = false
        //conatinerView.addSubview(textField1)
        conatinerView.addSubview(sendButton)
 NSLayoutConstraint.activate([
//     textField1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
//             textField1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//             textField1.heightAnchor.constraint(equalToConstant: 50),
//             textField1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
             sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
             sendButton.heightAnchor.constraint(equalToConstant: 50),
             sendButton.widthAnchor.constraint(equalToConstant: 50),
             sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//             textField1.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5)
 ])
            return conatinerView
        }()
        override var inputAccessoryView: UIView? {
            get{
//                let conatinerView = UIView()
//                conatinerView.backgroundColor = .red
//                conatinerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 50)
//                conatinerView.backgroundColor =  UIColor.red

                return inputContainerView
            }
        }
    
   
    
    
    override var canBecomeFirstResponder : Bool {
        return true
    }
    
    func configureTableView() {
        tableView.contentInset = UIEdgeInsets(top: 0, left: 0, bottom:50 , right: 0)
        tableView.separatorStyle = .none
        tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        
    }
    
//    let textField1 = CustomTextField(placeholder: "Type...", isPassword: false)
//    // textField1.backgroundColor = .white
//    let sendButton:UIButton = {
//        let sendButton = UIButton()
//        sendButton.backgroundColor = .systemIndigo
//        sendButton.setTitle("Send", for: .normal)
//        sendButton.setTitleColor(.white, for: .normal)
//        sendButton.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
//
//        //sendButton.layer.cornerRadius = 50
//        //sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
//        return sendButton
 //   }()
    
    
    @objc func sendMessage(){
        print("did tap")
//        if textField1.text != "" {
//            let newMessage = MessageModel(sender: currentUser.uid, message: textField1.text!, time: Date())
//            //chat?.messagesArray?.append(newMessage)
//            messages.append(newMessage)
//            chat?.lastMessage = newMessage
//            DatabaseManager.shared.addMessage(chat: chat!, id: chatId!,messageContent:messages)
//
//            textField1.text = ""
//
//            DispatchQueue.main.async {
//                self.tableView.reloadData()
//                //                self.collectionView.reloadData()
//            }
//        }
//
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
        self.view.frame.origin.y = -330 // Move view 150 points upward
    }
    
    @objc func keyboardWillHide(sender: NSNotification) {
        self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func fetchMessages() {
        messages = []
        DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            // print("Messages\(messages)")
            self.messages = messages
            
            DispatchQueue.main.async {
                
                self.tableView.reloadData()
            }
        }
    }
    
    func configure() {
        if chat.otherUserIndex == 0 {
            otherUser = chat.users[0]
            currentUser = chat.users[1]
        } else {
            otherUser = chat.users[1]
            currentUser = chat.users[0]
        }
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
        navigationItem.title = otherUser.username
        
       
        
        //
//        textField1.translatesAutoresizingMaskIntoConstraints = false
//        sendButton.translatesAutoresizingMaskIntoConstraints = false
//        view.addSubview(textField1)
//        view.addSubview(sendButton)
//        NSLayoutConstraint.activate([
//            textField1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
//            textField1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//            textField1.heightAnchor.constraint(equalToConstant: 50),
//            textField1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
//            sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
//            sendButton.heightAnchor.constraint(equalToConstant: 50),
//            sendButton.widthAnchor.constraint(equalToConstant: 50),
//            sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
//            textField1.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5)])
        
        
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageCell
        
        let messageItem = messages[indexPath.row]
        cell.message = messageItem
        // cell.backgroundColor = .red
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
