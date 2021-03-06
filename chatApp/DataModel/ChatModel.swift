//
//  Chat.swift
//  chatApp
//
//  Created by Panchami Shenoy on 20/11/21.
//

import Foundation
struct ChatModel{
    var users: [User]
    var lastMessage: MessageModel?
    var messagesArray: [MessageModel]?
    var otherUserIndex: Int?
    var chatId: String?
    var isGroupChat: Bool
    var groupChatName: String?
    var groupChatProfilePath: String?
}

