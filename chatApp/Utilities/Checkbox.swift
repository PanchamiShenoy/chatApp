//
//  Checkbox.swift
//  chatApp
//
//  Created by Panchami Shenoy on 18/11/21.
//

import Foundation
import UIKit
class Checkbox:UIView{
    var isCheckBoxChecked :Bool = false
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.layer.borderWidth = 1
        self.layer.borderColor = UIColor.quaternaryLabel.cgColor
        self.layer.cornerRadius = frame.size.width/2
        self.backgroundColor = UIColor.white
    }
    
    required init?(coder: NSCoder) {
            fatalError("init(coder:) has not been implemented")
    }
    func setBackground(){
        isCheckBoxChecked = !isCheckBoxChecked
        if isCheckBoxChecked{
            //layer.borderColor = UIColor.blue.cgColor
            backgroundColor = UIColor.quaternaryLabel
        }else{
            layer.borderColor = UIColor.white.cgColor
            backgroundColor = UIColor.systemBackground
        }
    }
    
}
