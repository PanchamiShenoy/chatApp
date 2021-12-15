//
//  Message.swift
//  chatApp
//
//  Created by Panchami Shenoy on 20/11/21.
//

import Foundation

struct MessageModel {
    var sender: String
    var message: String
    var time: Date
    var timeInString: String?
    var imagePath:String?
    
    var dictionary: [String: Any] {
        return [
            "sender": sender,
            "message": message,
            "time": timeInString!,
            "imagePath":imagePath
        ]
    }
}
