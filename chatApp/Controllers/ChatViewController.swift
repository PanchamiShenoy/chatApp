//
//  ChatViewController.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//
import UIKit
import FirebaseAuth
class ChatViewController:UITableViewController{
    
    var messages: [MessageModel] = []
    let messageCell = "MessageCell"
    let imageCell = "ImageCell"
    var otherUser: User!
    var currentUser: User!
    var uid = Auth.auth().currentUser?.uid
    var chat:ChatModel!
    var scrolView:UIScrollView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configure()
        configureTableView()
        fetchMessages()
        view.backgroundColor = color.background
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    @objc func sendPhoto(){
        presentPhotoActionSheet()
    }
    
    @objc func sendMessage(){
        if messageTextField.text != "" {
            let newMessage = MessageModel(sender: currentUser.uid, message: messageTextField.text!, time: Date(),imagePath:"")
            DatabaseManager.shared.addMessage(lastMessage: newMessage, id: chat.chatId!)
            
            messageTextField.text = ""
            
            DispatchQueue.main.async {
                self.tableView.reloadData()
            }
        }
        
    }
    
    let messageTextField = CustomTextField(placeholder: "Type a Message", isPassword: false)
    lazy var inputContainerView: UIView = {
        let containerView = UIView()
        containerView.frame = CGRect(x: 0, y: 0, width: view.frame.width, height: 65)
        containerView.backgroundColor = color.background
        
        let sendButton: UIButton = {
            let button = UIButton()
            button.setImage(UIImage(systemName: "paperplane.fill"), for: .normal)
            button.addTarget(self, action: #selector(sendMessage), for: .touchUpInside)
            button.tintColor = UIColor(red: 0.98, green: 1, blue: 0.969, alpha: 1)
            button.translatesAutoresizingMaskIntoConstraints = false
            button.backgroundColor = UIColor(red: 0.008, green: 0.686, blue: 0.612, alpha: 1)
            button.layer.borderColor = UIColor.systemGray.cgColor
            button.layer.borderWidth = 1
            button.layer.cornerRadius = 25
            button.heightAnchor.constraint(equalToConstant: 50).isActive = true
            button.widthAnchor.constraint(equalToConstant: 50).isActive = true
            return button
        }()
        let imageButton: UIButton = {
            let imageButton = UIButton()
            imageButton.setImage(UIImage(systemName: "camera.fill"), for: .normal)
            imageButton.addTarget(self, action: #selector(sendPhoto), for: .touchUpInside)
            imageButton.tintColor = color.time
            imageButton.translatesAutoresizingMaskIntoConstraints = false
            imageButton.backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
            imageButton.layer.cornerRadius = 25
            imageButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
            imageButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
            return imageButton
        }()
        
        self.messageTextField.layer.cornerRadius = 20
        self.messageTextField.backgroundColor = UIColor(red: 0.176, green: 0.22, blue: 0.243, alpha: 1)
        self.messageTextField.layer.borderColor = UIColor.systemGray.cgColor
        //self.messageTextField.layer.borderWidth =
        self.messageTextField.translatesAutoresizingMaskIntoConstraints = false
        
        containerView.addSubview(self.messageTextField)
        containerView.addSubview(sendButton)
        messageTextField.addSubview(imageButton)
        sendButton.rightAnchor.constraint(equalTo: containerView.rightAnchor,constant: -5).isActive = true
        sendButton.heightAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.widthAnchor.constraint(equalToConstant: 50).isActive = true
        sendButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        
        imageButton.rightAnchor.constraint(equalTo: messageTextField.rightAnchor,constant: -5).isActive = true
        imageButton.heightAnchor.constraint(equalToConstant: 70).isActive = true
        imageButton.widthAnchor.constraint(equalToConstant: 70).isActive = true
        imageButton.bottomAnchor.constraint(equalTo: containerView.bottomAnchor, constant: -8).isActive = true
        
        self.messageTextField.rightAnchor.constraint(equalTo: sendButton.leftAnchor, constant: -5).isActive = true
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
        var name:String
        navigationController?.navigationBar.tintColor = color.white
        navigationItem.backBarButtonItem = UIBarButtonItem(
            title: "", style: .plain, target: nil, action: nil)
        
        DatabaseManager.shared.fetchCurrentUser(uid: uid!) { user in
            self.currentUser = user
        }
        if chat.isGroupChat {
            name = chat.groupChatName!
        } else {
            if chat.users[0].uid == uid {
                name = chat.users[1].username
            } else {
                name = chat.users[0].username
            }
        }
        navigationItem.title = name
        
    }
    
    func configureTableView() {
        tableView.separatorStyle = .none
        tableView.backgroundColor = color.background
        tableView.register(MessageCell.self, forCellReuseIdentifier: messageCell)
        tableView.register(ImageCell.self, forCellReuseIdentifier: imageCell)
    }
    
    func  sendPhotoMessage(img:UIImage){
        let path = "MessageImages/\(NSUUID().uuidString)"
        let newMessage = MessageModel(sender: self.currentUser.uid, message: "", time: Date(),imagePath:path)
        StorageManager.shared.uploadMeesageImage(image:img,path:path) { url in
            print(url)
        }
        DatabaseManager.shared.addMessage(lastMessage: newMessage, id: chat.chatId!)
        DispatchQueue.main.async {
            self.tableView.reloadData()
        }
    }
    
    func fetchMessages() {
        messages = []
        DatabaseManager.shared.fetchMessages(chatId: chat.chatId!) { messages in
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
            if chat.isGroupChat {
                cell.usersList = chat.users
            }
            cell.backgroundColor = color.background
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: imageCell, for: indexPath) as! ImageCell
            cell.message = messages[indexPath.row]
            if chat.isGroupChat {
                cell.usersList = chat.users
            }
            StorageManager.shared.downloadImageWithPath(path: messages[indexPath.row].imagePath!, completion: { image in
                DispatchQueue.main.async {
                    cell.MessageImage.image = image
                }
            })
            cell.backgroundColor = color.background
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
