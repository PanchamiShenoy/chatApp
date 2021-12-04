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
        textColor = .label
        isSecureTextEntry = isPassword
        self.placeholder = placeholder
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    /*
     // Only override draw() if you perform custom drawing.
     // An empty implementation adversely affects performance during animation.
     override func draw(_ rect: CGRect) {
     // Drawing code
     }
     */
    
}
