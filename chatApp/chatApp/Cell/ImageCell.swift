//
//  ImageCell.swift
//  chatApp
//
//  Created by Panchami Shenoy on 03/12/21.
//


import UIKit
import FirebaseAuth

class ImageCell: UITableViewCell {
    var leftConstraint: NSLayoutConstraint!
    var rightConstraint: NSLayoutConstraint!
    
    var message: MessageModel? {
        didSet {
            configureImageCell()
        }
    }
    var messageContainer : UIView = {
        let view = UIView()
        view.layer.cornerRadius = 10
        return view
    }()
    
    var MessageImage: UIImageView = {
        let image = UIImageView()
        image.widthAnchor.constraint(equalToConstant: 200).isActive = true
        image.heightAnchor.constraint(equalToConstant: 200).isActive = true
        image.layer.cornerRadius = 20
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.translatesAutoresizingMaskIntoConstraints = false
        image.image = UIImage(systemName: "camera.fill")
        return image
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
        messageContainer.addSubview( MessageImage)
        messageContainer.addSubview(time)
        
        messageContainer.translatesAutoresizingMaskIntoConstraints = false
        time.translatesAutoresizingMaskIntoConstraints = false
        
        messageContainer.layer.cornerRadius = 10
        
        leftConstraint = messageContainer.leftAnchor.constraint(equalTo: leftAnchor, constant: 5)
        rightConstraint = messageContainer.rightAnchor.constraint(equalTo: rightAnchor, constant: -5)
        
        NSLayoutConstraint.activate([
            messageContainer.widthAnchor.constraint(equalTo:  MessageImage.widthAnchor, constant: 20),
            messageContainer.topAnchor.constraint(equalTo: topAnchor, constant: 5),
            messageContainer.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5),

            MessageImage.centerXAnchor.constraint(equalTo: messageContainer.centerXAnchor),
            MessageImage.topAnchor.constraint(equalTo: messageContainer.topAnchor, constant: 10),
            
            time.rightAnchor.constraint(equalTo: messageContainer.rightAnchor),
            time.topAnchor.constraint(equalTo:  MessageImage.bottomAnchor, constant: 5),
            time.bottomAnchor.constraint(equalTo: messageContainer.bottomAnchor, constant: -10),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
   
   
    
    func configureImageCell() {
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "hh:mm:a"
        time.text = dateFormatter.string(from: message!.time)
        StorageManager.shared.downloadImageWithPath(path: message!.imagePath!, completion: { image in
            DispatchQueue.main.async {
                self.MessageImage.image = image
            }
        })
        
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
