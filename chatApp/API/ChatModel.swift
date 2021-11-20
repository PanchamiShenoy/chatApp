//
//  Chat.swift
//  chatApp
//
//  Created by Panchami Shenoy on 20/11/21.
//

import Foundation
import Foundation

struct ChatModel {
    var users: [User]
    var lastMessage: MessageModel?
    var messagesArray: [MessageModel]?
    var otherUserIndex: Int?
    var chatId: String?
}
