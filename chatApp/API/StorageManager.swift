//
//  StorageManager.swift
//  chatApp
//
//  Created by Panchami Shenoy on 16/11/21.
//

import Foundation
import FirebaseStorage
import UIKit

final class StorageManager {
    
    static let shared = StorageManager()
    
    private let imageCache = NSCache<AnyObject,UIImage>()
    private let storage = Storage.storage().reference()
    
    
    func uploadImage(image: UIImage, uid: String, completion: @escaping(String) -> Void) {
        
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
    
    func uploadMeesageImage(image: UIImage, path: String, completion: @escaping(String) -> Void) {
        
        let storage = Storage.storage().reference()
        
        guard let imageData = image.jpegData(compressionQuality: 0.4) else { return }
        
        storage.child(path).putData(imageData, metadata: nil) { _, error in
            guard error == nil else { return }
            
            storage.child(path).downloadURL { url, error in
                guard let url = url, error == nil else {
                    return
                }
                
                let urlString = url.absoluteString
                completion(urlString)
            }
        }
    }
    
    
    
    func downloadImageWithPath(path: String, completion: @escaping(UIImage) -> Void) {
        if let cachedImage = self.imageCache.object(forKey: path as AnyObject){
            completion(cachedImage)
            return
        }
        let storage = Storage.storage()
        let result = storage.reference(withPath: path)
        result.getData(maxSize: 1 * 1024 * 1024) { data, error in
            guard error == nil else { return }
            if let data = data {
                
                let resultImage: UIImage! = UIImage(data: data)
                self.imageCache.setObject(resultImage, forKey: path as AnyObject)
                completion(resultImage)
            }
        }
    }
    
}
