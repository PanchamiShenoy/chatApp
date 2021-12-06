//
//  DatabaseManager.swift
//  chatApp
//
//  Created by Panchami Shenoy on 15/11/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
struct DatabaseManager {
    private let database = Database.database().reference()
    static let shared = DatabaseManager()
    let databaseDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        return formatter
    }()
    
    func fetchCurrentUser(uid: String, completion: @escaping(User) -> Void) {
        database.child("Users").child(uid).observe(.value) { snapshot in
            if let dictionary = snapshot.value as? [String: Any] {
                let email = dictionary["email"] as! String
                let username = dictionary["username"] as! String
                let profileURL = dictionary["profileURL"] as! String
                let uid = dictionary["uid"] as! String
                
                let user = User(username: username, email: email, profileURL: profileURL, uid: uid)
                print(user)
                completion(user)
            }
        }
    }
    
    
    func fetchAllUsers(uid: String, completion: @escaping([User]) -> Void) {
        var users = [User]()
        
        database.child("Users").observe(.value) { snapshot in
            if let result = snapshot.value as? [String: Any] {
                for userid in result.keys {
                    if userid == uid {
                        continue
                    }
                    let userData = result[userid] as! [String: Any]
                    
                    let email = userData["email"] as! String
                    let username = userData["username"] as! String
                    let uid = userData["uid"] as! String
                    let profileURL = userData["profileURL"] as! String
                    let user = User(username: username, email: email, profileURL: profileURL, uid: uid)
                    users.append(user)
                }
                completion(users)
            }
        }
        
    }
    
    public func onLogout() ->Bool{
        
        do {
            try Auth.auth().signOut()
            return true
        }catch{
            return false
        }
    }
    func addUser(user: User) {
        database.child("Users").child(user.uid).setValue(user.dictionary)
    }
//    func addMessage(chat: ChatModel, id: String,messageContent:[MessageModel]) {
//
//        var currentChat = chat
//
//        let dateString = databaseDateFormatter.string(from: currentChat.lastMessage!.time)
//        currentChat.lastMessage?.timeInString = dateString
//
//        let lastMessageDictionary = currentChat.lastMessage?.dictionary
//        var messagesDictionary: [[String: Any]] = []
//
//        for var message in messageContent {
//            let dateString = databaseDateFormatter.string(from: message.time)
//            message.timeInString = dateString
//            messagesDictionary.append(message.dictionary)
//        }
//        let finalDictionary = ["lastMessage": lastMessageDictionary!,
//                               "messagesArray": messagesDictionary] as [String : Any]
//        database.child("Chats").child(id).updateChildValues(finalDictionary)
//    }
    
    func addMessage(lastMessage: MessageModel, id: String) {
           
           var lastMessageItem = lastMessage
           
           let dateString = databaseDateFormatter.string(from: lastMessageItem.time)
           lastMessageItem.timeInString = dateString
           
           let lastMessageDictionary = lastMessageItem.dictionary
           let finalDictionary = ["lastMessage": lastMessageDictionary]
           
           database.child("Chats").child(id).updateChildValues(finalDictionary)
           database.child("Chats").child(id).child("messages").childByAutoId().setValue(lastMessageDictionary)
       }
    
    func fetchMessages(chatId: String, completion: @escaping([MessageModel]) -> Void) {
        database.child("Chats").child("\(chatId)/messages").observe(.value) { snapshot in
                   var resultArray: [MessageModel] = []
                   if let result = snapshot.value as? [String: [String: Any]] {
                       
                       let sortedKeyArray = result.keys.sorted()
                       for id in sortedKeyArray {
                           let message = result[id]!
                           let messageObject = createMessageObject(dictionary: message , id: id)
                           resultArray.append(messageObject)
                       }
                       completion(resultArray)
                   }
               }
    }
    
    func addChat(user1: User, user2: User, id: String) {
        var userDictionary: [[String: Any]] = []
        var chatDictionary: [String:Any]
        userDictionary.append(user1.dictionary)
        userDictionary.append(user2.dictionary)
        chatDictionary = ["users" : userDictionary,"isGroupChat": false]
        
        database.child("Chats").child(id).setValue(chatDictionary)
    }
    
    func addGroupChat(users: [User], id: String, isGroupChat: Bool, groupChatName: String?, groupChatProfilePath: String?){
        var userDictionary: [[String: Any]] = []
        for user in users {
            userDictionary.append(user.dictionary)
        }
        var chatDictionary:[String:Any]
        chatDictionary = ["users":userDictionary,
                          "isGroupChat": isGroupChat,
                          "groupChatName": groupChatName!,
                          "groupChatProfilePath": groupChatProfilePath!]
        database.child("Chats").child(id).setValue(chatDictionary)
    }
    
    func fetchChats(uid: String, completion: @escaping([ChatModel]) -> Void) {
        
        database.child("Chats").observe(.value) { snapshot in
            var chats = [ChatModel]()
            
            if let result = snapshot.value as? [String: [String: Any]] {
                //chat id is the key and chat cont.ent is the value
                for key in result.keys {
                    let value = result[key]!
                    var messagesArray: [MessageModel] = []
                    var lastMessage: MessageModel?
                    
                    let users = value["users"] as! [[String: Any]]
                    let lastMessageArray = value["lastMessage"] as? [String: Any]
                    let msgArray = value["messagesArray"] as? [[String: Any]]
                    let isGroupChat = value["isGroupChat"] as! Bool
                    //                    print(users)
                    if lastMessageArray != nil {
//                        for messageItem in msgArray! {
//                            let sender = messageItem["sender"] as! String
//                            let message = messageItem["message"] as! String
//                            let timeString = messageItem["time"] as! String
//
//                            let time = databaseDateFormatter.date(from: timeString)
//
//                            let currentMessage = MessageModel(sender: sender, message: message, time: time!)
//
//                            messagesArray.append(currentMessage)
//                        }
                        
                        let sender = lastMessageArray!["sender"] as! String
                        let message = lastMessageArray!["message"] as! String
                        let timeString = lastMessageArray!["time"] as! String
                        
                        let time = databaseDateFormatter.date(from: timeString)
                        
                        lastMessage = MessageModel(sender: sender, message:message, time: time!)
                        
                    } else {
                        messagesArray = []
                        lastMessage = nil
                    }
                    
                    //                    let user1 = users[0]
                    //                    let user2 = users[1]
                    var usersArray: [User] = []
                    var chat :ChatModel
                    for user in users {
                        let email = user["email"] as! String
                        let username = user["username"] as! String
                        let uid = user["uid"] as! String
                        let profileURL = user["profileURL"] as! String
                        let userModel =  User(username: username, email: email, profileURL: profileURL, uid: uid)
                        usersArray.append(userModel)
                    }
                    if isGroupChat {
                        let groupChatName = value["groupChatName"] as! String
                        let groupChatProfilePath = value["groupChatProfilePath"] as! String
                        
                        chat = ChatModel(users: usersArray, lastMessage: lastMessage, messagesArray: [],chatId: key, isGroupChat: isGroupChat, groupChatName: groupChatName, groupChatProfilePath: groupChatProfilePath)
                        
                    } else {
                        var otherUserIndex: Int
                        if usersArray[0].uid == uid {
                            otherUserIndex = 1
                        } else {
                            otherUserIndex = 0
                        }
                        
                        chat = ChatModel(users: usersArray, lastMessage: lastMessage, messagesArray: [],otherUserIndex:otherUserIndex, chatId: key, isGroupChat: isGroupChat)
                    }
                    
                    chats.append(chat)
                }
                print(chats)
                completion(chats)
            }
        }
    }
    func createMessageObject(dictionary: [String: Any], id: String) -> MessageModel {
            let sender = dictionary["sender"] as! String
            let content = dictionary["message"] as! String
            let timeString = dictionary["time"] as! String
            //let seen = dictionary["se"] as! Bool
            let imagePath = dictionary["imagePath"] as! String
            let time = databaseDateFormatter.date(from: timeString)
            
        return MessageModel(sender: sender, message: content, time: time!, timeInString: timeString, imagePath: imagePath)
        }
}




