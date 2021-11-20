//
//  MessageCell.swift
//  chatApp
//
//  Created by Panchami Shenoy on 20/11/21.
//

import UIKit

class MessageCell: UITableViewCell {
    var message : MessageModel? {
        didSet{
            configure()
        }
    }
    let messageContent :UILabel = {
       let message = UILabel()
        message.textColor = .label
        //message.backgroundColor = .systemIndigo
        message.translatesAutoresizingMaskIntoConstraints =  false
        return message
    }()
    
    let time: UILabel = {
        let time = UILabel()
        time.textColor = .quaternaryLabel
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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    func configure(){
        
        addSubview(messageContainer)
        messageContent.text = message?.message
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: message!.time)
        messageContainer.addSubview(messageContent)
        messageContainer.addSubview(time)
       
        NSLayoutConstraint.activate([
            messageContainer.widthAnchor.constraint(equalToConstant: 250),
            messageContainer.rightAnchor.constraint(equalTo:rightAnchor,constant:-10),
            messageContainer.topAnchor.constraint(equalTo:topAnchor,constant: 10),
            messageContainer.bottomAnchor.constraint(equalTo:bottomAnchor,constant: -10),
            
            messageContent.leftAnchor.constraint(equalTo:messageContainer.leftAnchor,constant: 10),
            messageContent.topAnchor.constraint(equalTo:messageContainer.topAnchor,constant: 10),
            messageContent.bottomAnchor.constraint(equalTo:messageContainer.bottomAnchor,constant: -10),
            
            time.rightAnchor.constraint(equalTo:messageContainer.rightAnchor,constant: -10),
            time.centerYAnchor.constraint(equalTo:messageContainer.centerYAnchor),
            
            messageContent.rightAnchor.constraint(equalTo:time.leftAnchor,constant:-10),
        ])
        
        
    }
}
