//
//  DatabaseManager.swift
//  chatApp
//
//  Created by Panchami Shenoy on 15/11/21.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth
final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()
    
    public func userExists( email:String,completion:@escaping((Bool)->Void)) {
        var safeEmail = email.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        database.child(safeEmail).observeSingleEvent(of: .value,with:{ snapshot in
            guard snapshot.value as? String != nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    public func insertUser(with user:ChatAppUser,completion:@escaping (Bool)->Void) {
        database.child(user.safeEmail).setValue([
            "first_name":user.firstName,
            "last_name":user.lastName
        ],withCompletionBlock: { error, _ in
            guard error == nil else {
                print("failed to write to database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: {snapshot in
                if var usersCollection = snapshot.value as? [[String:String]]{
                    let newElement = [
                        "name" :user.firstName + " " + user.lastName,
                        "email":user.safeEmail
                    ]
                    usersCollection.append(newElement)
                    self.database.child("users").setValue(usersCollection,withCompletionBlock: { error ,_ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                        
                    })
                    
                }else{
                    let newCollection : [[String:String]] = [
                        [
                            "name" :user.firstName + " " + user.lastName,
                            "email": user.safeEmail
                        ]
                    ]
                    self.database.child("users").setValue(newCollection,withCompletionBlock: { error ,_ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        completion(true)
                        
                    })
                }
            })
        })
    }
    
    public func getAllUsers(completion:@escaping(Result<[[String:String]],Error>)->Void){
        database.child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            print("\n\n",value)
            completion(.success(value))
        })
    }
    
    func fetchAllUsers(uid: String, completion: @escaping([UserData]) -> Void) {
           print("wdwewedwef")
           
           var users = [UserData]()
           
           database.child("Users").observe(.value) { snapshot in
               if let result = snapshot.value as? [String: Any] {
   //                print(result)
                   for userid in result.keys {
                       if userid == uid {
                           continue
                       }
                       let userData = result[userid] as! [String: Any]
                       
                       let email = userData["email"] as! String
                       let username = userData["username"] as! String
                       let uid = userData["uid"] as! String
                       let profileURL = userData["profileURL"] as! String
                       let user = UserData(username: username, email: email, profileURL: profileURL, uid: uid)
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
    static func safeEmail(emailAddress:String)->String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    public enum DatabaseError:Error {
        case failedToFetch
    }
    func addUser(user: UserData) {
            database.child("Users").child(user.uid).setValue(user.dictionary)
        }
}

struct UserData: Codable {

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

struct ChatAppUser {
    let firstName:String
    let lastName:String
    let emailAddress:String
    let uid:String
    var safeEmail:String {
        var safeEmail = emailAddress.replacingOccurrences(of: ".", with: "-")
        safeEmail = safeEmail.replacingOccurrences(of: "@", with: "-")
        return safeEmail
    }
    var profilePictureFileName :String {
        return "\(safeEmail)_profile_picture.png"
    }
   
   
}

