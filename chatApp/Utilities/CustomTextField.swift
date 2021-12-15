//
//  CustomTextField.swift
//  chatApp
//
//  Created by Panchami Shenoy on 13/11/21.
//


import UIKit

class CustomTextField: UITextField {
    
    init(placeholder: String,isPassword:Bool) {
        super.init(frame: .zero)
        font = UIFont.systemFont(ofSize: 16)
        textColor = color.white
        isSecureTextEntry = isPassword
        self.attributedPlaceholder =
        NSAttributedString(string:placeholder, attributes: [NSAttributedString.Key.foregroundColor:UIColor(red: 0.439, green: 0.475, blue: 0.502, alpha: 1)])
        CustomTextField.appearance().tintColor = color.green
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
