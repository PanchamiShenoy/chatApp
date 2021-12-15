//
//  ConversationCell.swift
//  chatApp
//
//  Created by Panchami Shenoy on 18/11/21.
//

import UIKit

class ConversationCell: UICollectionViewCell {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
        
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    let title : UILabel = {
        let title = UILabel()
        title.textColor = color.username
        title.font = UIFont(name: "PTSans-Regular", size: 21)
        return title
    }()
    
    let message : UILabel = {
        let message = UILabel()
        message.text = "message"
        message.textColor = color.message
        message.font = UIFont(name: "PTSans-Regular", size: 18.54)
        return message
    }()
    
    let time : UILabel = {
        let time = UILabel()
        time.text = "3:30"
        time.textColor = color.time
        time.font =  UIFont(name: "PTSans-Bold", size: 12)
        return time
    }()
    
    let image :UIImageView = {
        let image = UIImageView()
        image.image = UIImage(systemName: "person.fill")
        image.backgroundColor = color.time
        image.tintColor = .white
        image.clipsToBounds = true
        image.contentMode = .scaleAspectFill
        image.layer.cornerRadius = 30
        return image
    }()
    
    let checkBox: Checkbox = {
        let checkBox = Checkbox(frame:CGRect(x: 0, y: 0, width: 30, height: 30))
        
        return checkBox
    }()
    
    @objc func didTapCheckBox(){
        print("ischcked")
        checkBox.setBackground()
    }
    
    func configure() {
        let gesture = UITapGestureRecognizer(target: self, action: #selector(didTapCheckBox))
        checkBox.addGestureRecognizer(gesture)
        
        addSubview(title)
        addSubview(message)
        addSubview(image)
        addSubview(time)
        addSubview(checkBox)
        
        time.translatesAutoresizingMaskIntoConstraints = false
        title.translatesAutoresizingMaskIntoConstraints = false
        message.translatesAutoresizingMaskIntoConstraints = false
        image.translatesAutoresizingMaskIntoConstraints = false
        checkBox.translatesAutoresizingMaskIntoConstraints = false
    }
    override func layoutSubviews() {
        
        checkBox.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive =  true
        checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        image.leadingAnchor.constraint(equalTo: checkBox.leadingAnchor,constant: 35).isActive = true
        image.widthAnchor.constraint(equalToConstant: 60).isActive = true
        image.heightAnchor.constraint(equalToConstant: 60).isActive = true
        
        title.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: image.rightAnchor,constant: 15).isActive = true
        
        message.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 5).isActive = true
        message.leftAnchor.constraint(equalTo: image.rightAnchor,constant: 15).isActive = true
        
        time.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        time.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -5).isActive = true
        
    }
}

