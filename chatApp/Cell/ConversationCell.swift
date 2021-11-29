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
        title.textColor = .label
       // title.backgroundColor = .systemPink
        return title
    }()
    
    let message : UILabel = {
        let message = UILabel()
        message.text = "message"
        message.textColor = .label
       // message.lineBreakMode = .byTruncatingTail
       // message.numberOfLines = 1
        //message.adjustsFontSizeToFitWidth = true
        //message.backgroundColor = .black
        return message
    }()
    
    let time : UILabel = {
        let time = UILabel()
        time.text = "3:30"
        time.textColor = .label
        //message.backgroundColor = .black
        return time
    }()

    
   let image :UIImageView = {
       let image = UIImageView()
      image.image = UIImage(systemName: "person.fill")
       image.clipsToBounds = true
       image.contentMode = .scaleAspectFill
       image.layer.cornerRadius = 25
       //image.backgroundColor = .red
        //let image = UIImageView(systemName: "folder.fill.badge.plus")
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
        print("@@@@@@@@@@@@@@@@@@@")
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
       // checkBox.leadingAnchor.constraint(equalTo:  self.leadingAnchor).isActive =  true
        checkBox.leadingAnchor.constraint(equalTo: self.leadingAnchor,constant: 8).isActive = true
        checkBox.heightAnchor.constraint(equalToConstant: 30).isActive = true
        checkBox.widthAnchor.constraint(equalToConstant: 30).isActive = true
        
        image.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
         //image.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
         image.leadingAnchor.constraint(equalTo: checkBox.leadingAnchor,constant: 35).isActive = true
         image.widthAnchor.constraint(equalToConstant: 50).isActive = true
         image.heightAnchor.constraint(equalToConstant: 50).isActive = true
        
        title.topAnchor.constraint(equalTo: self.topAnchor,constant: 10).isActive = true
        title.leftAnchor.constraint(equalTo: image.rightAnchor,constant: 15).isActive = true
        
        message.topAnchor.constraint(equalTo: title.bottomAnchor,constant: 5).isActive = true
        message.leftAnchor.constraint(equalTo: image.rightAnchor,constant: 15).isActive = true
        
        time.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        time.rightAnchor.constraint(equalTo: self.rightAnchor,constant: -5).isActive = true
        message.rightAnchor.constraint(equalTo:self.rightAnchor,constant: -80).isActive = true
    /*    let stack = UIStackView(arrangedSubviews: [title,message])
        stack.axis = .vertical
        stack.spacing = 4
        addSubview(stack)
        stack.translatesAutoresizingMaskIntoConstraints = false
        
       // stack.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        stack.leadingAnchor.constraint(equalTo: image.trailingAnchor,constant: 10).isActive = true
        stack.topAnchor.constraint(equalTo: contentView.topAnchor).isActive = true
        stack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor,constant: 10).isActive = true
        stack.bottomAnchor.constraint(equalTo: contentView.bottomAnchor,constant: -10).isActive = true
     */
    }
}

