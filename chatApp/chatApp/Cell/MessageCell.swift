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
    
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    
    var message: MessageModel? {
        didSet {
            configureMessageCell()
        }
    }
    var messageContainer : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    
    var messageLabel: UILabel = {
        let label = UILabel()
        label.text = ""
        label.textColor = .white
        label.numberOfLines = 0
        label.textColor = .white
        label.textAlignment = .left
        return label
    }()
    let time: UILabel = {
        let time = UILabel()
        time.textColor = .secondarySystemBackground
        time.font = UIFont.systemFont(ofSize: 12)
        time.adjustsFontSizeToFitWidth = true
        time.translatesAutoresizingMaskIntoConstraints =  false
        return time
    }()
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        addSubview(messageContainer)
        messageContainer.addSubview(time)
        messageContainer.addSubview(messageLabel)
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        messageLabel.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        messageContainer.layer.cornerRadius = 10
        
        leftConstraint = messageContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        NSLayoutConstraint.activate([
            
            messageLabel.widthAnchor.constraint(lessThanOrEqualToConstant: 200),
            messageContainer.widthAnchor.constraint(equalTo: messageLabel.widthAnchor, constant: 60),
            messageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),
         
            messageLabel.leftAnchor.constraint(equalTo: messageContainer.leftAnchor, constant: 10),
            messageLabel.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo: messageContainer.rightAnchor, constant: -10),
            time.topAnchor.constraint(equalTo: messageLabel.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
    
    func configureMessageCell() {
        
        messageLabel.text = message!.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: message!.time)
        
        if message?.sender == Auth.auth().currentUser?.uid{
            leftConstraint.isActive = false
            rightConstraint.isActive = true
            messageContainer.backgroundColor = .systemIndigo
            
        } else {
            rightConstraint.isActive = false
            leftConstraint.isActive = true
            messageContainer.backgroundColor = .secondaryLabel
            
        }
    }
}
