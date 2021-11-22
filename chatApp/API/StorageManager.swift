//
//  StorageManager.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import Foundation
import FirebaseStorage
final class StorageManager {
    
    static let shared = StorageManager()
    
    private let storage = Storage.storage().reference()
    
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
                }
            }
        }
    }
    
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
