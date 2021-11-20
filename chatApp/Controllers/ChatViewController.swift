//
//  ChatViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import UIKit
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
        fetchChats()
        view.backgroundColor = .systemBackground
        configure()
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(sender:)), name: UIResponder.keyboardWillShowNotification, object: nil);

        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillHide(sender:)), name: UIResponder.keyboardWillHideNotification, object: nil);

    }
    override func viewDidAppear(_ animated: Bool) {
    
    }
    func configureTableView() {
        
            tableView.separatorStyle = .none
            tableView.register(MessageCell.self, forCellReuseIdentifier: cellIdentifier)
        }
    
    let textField1 = CustomTextField(placeholder: "Type...", isPassword: false)
    let sendButton:UIButton = {
       let sendButton = UIButton()
        sendButton.backgroundColor = .systemIndigo
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        
        //sendButton.layer.cornerRadius = 50
        //sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return sendButton
    }()
  
    
    let Button:UIButton = {
       let sendButton = UIButton()
        sendButton.backgroundColor = .systemIndigo
        sendButton.setTitle("Send", for: .normal)
        sendButton.setTitleColor(.white, for: .normal)
        sendButton.addTarget(self, action: #selector(sendChat), for: .touchUpInside)
        
        //sendButton.layer.cornerRadius = 50
        //sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        return sendButton
    }()
  
    
    @objc func sendChat(){
        
        if textField1.text != "" {
                   let newMessage = MessageModel(sender: currentUser.uid, message: textField1.text!, time: Date(), seen: false)
                   chat?.messagesArray?.append(newMessage)
            chat?.lastMessage = newMessage
                   DatabaseManager.shared.addMessage(chat: chat!, id: chatId!)
                   
                   textField1.text = ""

                   DispatchQueue.main.async {
                       self.tableView.reloadData()
       //                self.collectionView.reloadData()
                   }
               }
        
    }
    
    @objc func keyboardWillShow(sender: NSNotification) {
         self.view.frame.origin.y = -260 // Move view 150 points upward
    }

    @objc func keyboardWillHide(sender: NSNotification) {
         self.view.frame.origin.y = 0 // Move view to original position
    }
    
    func fetchChats() {
            messages = []
            DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
                print("Messages\(messages)")
                self.messages = messages
                
                DispatchQueue.main.async {
                    self.tableView.reloadData()
                }
            }
        }
    
    func configure() {
        chatId = "\(chat.users[0].uid)_\(chat.users[1].uid)"
       // view.addSubview(Button)
        Button.translatesAutoresizingMaskIntoConstraints = false
        //let newMessage = MessageModel(sender: currentUser.uid, message:"hellooo", time: Date(), seen: false)
       // messages.append(newMessage
view.addSubview(textField1)
            view.addSubview(sendButton)
             textField1.translatesAutoresizingMaskIntoConstraints = false
        sendButton.translatesAutoresizingMaskIntoConstraints = false
        //        textField1.leftAnchor.constraint(equalTo: view.leftAnchor,constant: 2).isActive = true
        //        textField1.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -150).isActive = true
        //        textField1.widthAnchor.constraint(equalToConstant: (view.frame.width*3)/4).isActive = true
        //        textField1.heightAnchor.constraint(equalToConstant: 30).isActive = true
        //
        //       sendButton.leftAnchor.constraint(equalTo:textField1.rightAnchor).isActive = true
        //        sendButton.bottomAnchor.constraint(equalTo: view.bottomAnchor,constant: -150).isActive = true
        //        sendButton.widthAnchor.constraint(equalToConstant: (view.frame.width)/4).isActive = true
        //        sendButton.heightAnchor.constraint(equalToConstant: 30).isActive = true
        NSLayoutConstraint.activate([
            textField1.leftAnchor.constraint(equalTo: view.leftAnchor, constant: 5),
                  textField1.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                  textField1.heightAnchor.constraint(equalToConstant: 50),
                  textField1.widthAnchor.constraint(equalTo: view.widthAnchor, constant: -70),
                  sendButton.rightAnchor.constraint(equalTo: view.rightAnchor, constant: -5),
                  sendButton.heightAnchor.constraint(equalToConstant: 50),
                  sendButton.widthAnchor.constraint(equalToConstant: 50),
                  sendButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: 0),
                  textField1.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5)
        ])
       
        
        
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            return messages.count
        }
        
        override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath) as! MessageCell
            
            let messageItem = messages[indexPath.row]
            cell.message = messageItem
            cell.backgroundColor = .red
//            cell.senderUid = messageItem.sender
//            cell.currentUid = NetworkManager.shared.getUID()
//            cell.message.text = messageItem.message
//            cell.backgroundColor = ColorConstants.customWhite
//            cell.checkSender()
//
//            let dateFormatter = DateFormatter()
//            dateFormatter.dateFormat = "hh:mm:a"
//
//            cell.time.text = dateFormatter.string(from: messageItem.time)
            return cell
        }
        
        override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
        }

}
