//
//  CustomImage.swift
//  chatApp
//
//  Created by Panchami Shenoy on 15/12/21.
//

import UIKit

class CustomImage: UIImageView {
    override init(frame: CGRect) {
        super.init(frame: .zero)
            image = UIImage(systemName: "person.fill")
            clipsToBounds = true
            contentMode = .scaleAspectFill
            backgroundColor = color.time
            tintColor = .white
            layer.cornerRadius = 50
            isUserInteractionEnabled = true
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    
}
