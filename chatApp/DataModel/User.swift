//
//  User.swift
//  chatApp
//
//  Created by Panchami Shenoy on 21/11/21.
//

import Foundation

struct User: Codable {
    
    var username: String
    var email: String
    var profileURL: String
    var uid: String
    
    var dictionary: [String: Any] {
        return [
            "username": username,
            "email": email,
            "profileURL": profileURL,
            "uid": uid
        ]
    }
}

