//
//  ChatViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//
import UIKit
class ChatViewController:UITableViewController{
    
    var messages: [MessageModel] = []
    let messageCell = "MessageCell"
    let imageCell = "ImageCell"
    var otherUser: User!
    var currentUser: User!
    var chatId: String?
    var chat:ChatModel!
    var scrolView:UIScrollView!
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        fetchMessages()
        view.backgroundColor = .systemBackground
    }
    override func viewDidAppear(_ animated: Bool) {
        
    }
    let messageTextField = CustomTextField(placeholder: "Type...", isPassword: false)
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 65)
        containerView.backgroundColor = .systemBackground
        
        let sendButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            button.tintColor = .systemIndigo
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = .systemBackground
            button.layer.borderColor = UIColor.systemGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 25
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            return button
        }()
        let imageButton: UIButton = {
            let imageButton = UIButton()
            imageButton.setImage(UIImage(systemName: "photo"), for: .normal)
            imageButton.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
            imageButton.tintColor = .systemIndigo
            imageButton.layer.borderColor = UIColor.systemGray.cgColor
            imageButton.translatesAutoresizingMaskIntoConstraints = false
            imageButton.backgroundColor = .systemBackground
            imageButton.layer.borderWidth = 1
            imageButton.layer.cornerRadius = 10
            imageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            imageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            return imageButton
        }()
        
        self.messageTextField.layer.cornerRadius = 20
        self.messageTextField.layer.borderColor = UIColor.systemGray.cgColor
        self.messageTextField.layer.borderWidth = 1
        self.messageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(self.messageTextField)
        containerView.addSubview(sendButton)
        containerView.addSubview(imageButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        
        imageButton.rightAnchor.constraint(equalTo: sendButton.leftAnchor,constant: -5).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        imageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        
        self.messageTextField.rightAnchor.constraint(equalTo: imageButton.leftAnchor, constant: -5).isActive = true
        self.messageTextField.leftAnchor.constraint(equalTo: containerView.leftAnchor,constant: 5).isActive = true
        self.messageTextField.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        self.messageTextField.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        return containerView
    }()
    override var inputAccessoryView: UIView? {
        get{
            
            return inputContainerView
        }
    }
    
    override var canBecomeFirstResponder : Bool {
        return true
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
        
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        //tableView.contentInset = UIEdgeInsets(top: 5, left: 0, bottom: 70 , right: 0)
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCell)
        tableView.register(ImageCell.self, forCellReuseIdentifier: imageCell)
    }
    
    @objc func sendPhoto(){
        presentPhotoActionSheet()
    }
    
    @objc func sendMessage(){
        if messageTextField.text != "" {
            let newMessage = MessageModel(sender: currentUser.uid, message: messageTextField.text!, time: Date(),imagePath:"")
            //chat?.messagesArray?.append(newMessage)
            messages.append(newMessage)
            chat?.lastMessage = newMessage
            DatabaseManager.shared.addMessage(chat: chat!, id: chatId!,messageContent:messages)
            
            messageTextField.text = ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    func  sendPhotoMessage(img:UIImage){
        let path = "MessageImages/\(NSUUID().uuidString)"
        let newMessage = MessageModel(sender: self.currentUser.uid, message: "", time: Date(),imagePath:path)
        messages.append(newMessage)
        chat.lastMessage = newMessage
        StorageManager.shared.uploadMeesageImage(image:img,path:path) { url in
            print("######################")
            print(url)
        }
        DatabaseManager.shared.addMessage(chat: self.chat!, id: self.chatId!, messageContent: self.messages)
        
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchMessages() {
        messages = []
        DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
            // print("Messages\(messages)")
            self.messages = messages
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
                // let indexPath = IndexPath(row: self.messages.count-1,section: 0)
                // self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                self.tableView.scrollToRow(at: [0, messages.count - 1], at: .bottom, animated: false)
                
            }
        }
    }
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return messages.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if messages[indexPath.row].imagePath == "" {
            let cell = tableView.dequeueReusableCell(withIdentifier: messageCell, for: indexPath) as! MessageCell
            cell.message = messages[indexPath.row]
            cell.backgroundColor = .systemBackground
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as! ImageCell
            cell.message = messages[indexPath.row]
            StorageManager.shared.downloadImageWithPath(path: messages[indexPath.row].imagePath!, completion: { image in
                DispatchQueue.main.async {
                    cell.MessageImage.image = image
                }
            })
            cell.backgroundColor = .systemBackground
            return cell
            
        }
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
    
}

extension ChatViewController:UIImagePickerControllerDelegate,UINavigationControllerDelegate{
    
    func presentPhotoActionSheet() {
        let actionSheet = UIAlertController(title: "Send Image", message: "How would like to select a picture", preferredStyle: .actionSheet)
        actionSheet.addAction(UIAlertAction(title: "Take Photo", style: .default, handler: { [weak self] _ in
            self?.presentCamera()
        }))
        actionSheet.addAction(UIAlertAction(title: "Choose Photo", style: .default, handler: { [weak self] _ in
            self?.presentPhotoLibrary()
        }))
        actionSheet.addAction(UIAlertAction(title: "Cancel", style: .default, handler:nil))
        present(actionSheet, animated: true, completion: nil)
    }
    func presentCamera(){
        let vc =  UIImagePickerController()
        vc.sourceType = .camera
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    func presentPhotoLibrary() {
        let vc =  UIImagePickerController()
        vc.sourceType = .photoLibrary
        vc.delegate = self
        vc.allowsEditing = true
        present(vc, animated: true, completion: nil)
    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true, completion: nil)
        
        guard let selectedImage = info[UIImagePickerController.InfoKey.editedImage] as? UIImage else {
            return
        }
        sendPhotoMessage(img:selectedImage)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    
}
