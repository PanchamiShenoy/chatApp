//
//  StorageManager.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import Foundation
import FirebaseStorage
//import SwiftUI
final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
    public typealias UploadPictureCompletion = (Result<String,Error>) ->Void
    
    public func uploadProfilePicture(data:Data,fileName:String,completion:@escaping UploadPictureCompletion) {
        
        storage.child("images/\(fileName)").putData(data,metadata: nil,completion: { metadata ,error in
            guard error == nil else {
                print("failed to upload data to firebase ")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url,error in
                guard let url = url else {
                    print("failed to dowload url")
                    completion(.failure(StorageErrors.failedToGetDownloadURL))
                    return
                }
                
                let urlString = url.absoluteString
                print("download url returned:\(urlString)")
                completion(.success(urlString))
                
            })
            
        })
        
        
    }
    struct ImageUploader {
        static func uploadImage(image: UIImage, uid: String, completion: @escaping(String) -> Void) {
            
            let storage = Storage.storage().reference()
            
            guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
            
            storage.child("Profile").child(uid).putData(imageData, metadata: nil) { _, error in
                guard error == nil else { return }
                
                storage.child("Profile").child(uid).downloadURL { url, error in
                    guard let url = url, error == nil else {
                        return
                    }
                    
                    let urlString = url.absoluteString
                    
                    print("Download URL: \(urlString)")
                    completion(urlString)
    //                UserDefaults.standard.set(urlString, forKey: "url")
                }
            }
        }
    }
    
    public enum StorageErrors:Error {
        case failedToUpload
        case failedToGetDownloadURL
    }
    
//    public func downloadURL(path:String, completion:@escaping (Result<URL,Error>)->Void){
//        let reference = storage.child("")
//
//        reference.downloadURL { url, error in
//            guard let url = url ,error == nil else {
//                completion(.failure(StorageErrors.failedToGetDownloadURL))
//                return
//            }
//            print(url)
//            completion(.success(url))
//        }
//    }
    func downloadImageWithPath(path: String, completion: @escaping(UIImage) -> Void) {
        let storage = Storage.storage()
        let result = storage.reference(withPath: path)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
          guard error == nil else { return }
          if let data = data {
            let resultImage: UIImage! = UIImage(data: data)
            completion(resultImage)
          }
        }
      }

}
