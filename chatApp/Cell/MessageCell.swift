//
//  MessageCell.swift
//  chatApp
//
//  Created by Panchami Shenoy on 20/11/21.
//

import UIKit
import FirebaseAuth
import MessageKit
class MessageCell: UITableViewCell {
    var leftConstraint : NSLayoutConstraint?
    var rightConstraint :NSLayoutConstraint?
    let uid = Auth.auth().currentUser?.uid
    var message : MessageModel? {
        didSet{
            if message!.imagePath! == "" {
                configureMessageCell()
            } else {
                configureImageCell()
            }
        }
    }
    let messageContent :UILabel = {
        let message = UILabel()
        message.textColor = .white
        message.numberOfLines = 0
        //message.backgroundColor = .systemIndigo
        message.translatesAutoresizingMaskIntoConstraints =  false
        return message
    }()
    
    let time: UILabel = {
        let time = UILabel()
        time.textColor = .secondarySystemBackground
        time.font = UIFont.systemFont(ofSize: 12)
        time.adjustsFontSizeToFitWidth = true
        time.translatesAutoresizingMaskIntoConstraints =  false
        return time
    }()
    
    let messageContainer :UIView = {
        let messageConatiner = UIView()
        messageConatiner.backgroundColor = .systemIndigo
        messageConatiner.layer.cornerRadius = 10
        messageConatiner.translatesAutoresizingMaskIntoConstraints = false
        return messageConatiner
    }()
    
    var chatImage: UIImageView = {
        let image = UIImageView()
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "photo.fill")
        return image
    }()
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    func configureImageCell() {
        leftConstraint =  messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 10)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -10)
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: message!.time)
        StorageManager.shared.downloadImageWithPath(path: message!.imagePath!, completion: { image in
            DispatchQueue.main.async {
                self.chatImage.image = image
            }
        })
        messageContainer.willRemoveSubview(messageContent)
        //messageContainer.layer.cornerRadius = 10
        addSubview(messageContainer)
        messageContainer.addSubview(chatImage)
        messageContainer.addSubview(time)
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        chatImage.translatesAutoresizingMaskIntoConstraints = false
        if message!.sender == uid  {
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            
            messageContainer.backgroundColor = .systemIndigo
        }
        else{
            rightConstraint?.isActive = false
            leftConstraint?.isActive =  true
            messageContainer.backgroundColor = .secondaryLabel
        }
        NSLayoutConstraint.activate([
            messageContainer.widthAnchor.constraint(equalTo: chatImage.widthAnchor,constant: 20),
            messageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            
            chatImage.centerXAnchor.constraint(equalTo: messageContainer.centerXAnchor),
            chatImage.topAnchor.constraint(equalTo: messageContainer.topAnchor,constant: 10),
            
            time.rightAnchor.constraint(equalTo: messageContainer.rightAnchor),
            time.topAnchor.constraint(equalTo: chatImage.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -10),
        ])
    }
    func configureMessageCell(){
        leftConstraint =  messageContainer.leftAnchor.constraint(equalTo: leftAnchor,constant: 10)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant: -10)
        
        addSubview(messageContainer)
        messageContent.text = message?.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: message!.time)
        messageContainer.addSubview(messageContent)
        messageContainer.addSubview(time)
        messageContainer.willRemoveSubview(chatImage)
        if message!.sender == uid  {
            leftConstraint?.isActive =  false
            rightConstraint?.isActive = true
            messageContainer.backgroundColor = .systemIndigo
        }
        else{
            rightConstraint?.isActive = false
            leftConstraint?.isActive =  true
            messageContainer.backgroundColor = .secondaryLabel
        }
        
        NSLayoutConstraint.activate([
            messageContent.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            messageContainer.widthAnchor.constraint(equalTo: messageContent.widthAnchor, constant: 60),
            messageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
            //messageContainer.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            messageContent.leftAnchor.constraint(equalTo:  messageContainer.leftAnchor, constant: 10),
            messageContent.topAnchor.constraint(equalTo:  messageContainer.topAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo:  messageContainer.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: messageContent.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo:  messageContainer.bottomAnchor, constant: -10),
            
        ])
        
        
    }
}
