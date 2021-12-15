//
//  CustomContainer.swift
//  chatApp
//
//  Created by Panchami Shenoy on 13/11/21.
//
import UIKit
class CustomContainerView: UIView {
    
    
    init(image: UIImage, textField: UITextField) {
        super.init(frame: .zero)
        backgroundColor = color.background
        heightAnchor.constraint(equalToConstant: 50).isActive = true
        layer.borderColor = UIColor.gray.cgColor
        layer.borderWidth = 1
        layer.cornerRadius = 5
        
        let imageView = UIImageView()
        addSubview(imageView)
        imageView.image = image
        imageView.tintColor = color.green
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        imageView.leftAnchor.constraint(equalTo: leftAnchor, constant: 10).isActive = true
        imageView.widthAnchor.constraint(equalToConstant: 24).isActive = true
        imageView.heightAnchor.constraint(equalToConstant: 24).isActive = true
        
        
        addSubview(textField)
        
        textField.translatesAutoresizingMaskIntoConstraints = false
        textField.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        textField.leftAnchor.constraint(equalTo: imageView.rightAnchor,constant: 10).isActive = true
        textField.rightAnchor.constraint(equalTo: rightAnchor, constant: -10).isActive = true
        textField.heightAnchor.constraint(equalToConstant: 40).isActive = true
    }
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
