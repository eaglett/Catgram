//
//  StorageManager.swift
//  Cakegram
//
//  Created by Aneja Orlic on 22/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import Foundation
import FirebaseStorage

//final class cannot be inherited or overridden
final class StorageManager{
    static let shared = StorageManager()
    private let storage = Storage.storage().reference()
    
    public func uploadPicture(with data: Data, fileName: String, completion: @escaping (Result<String, Error>) -> Void) {
        //uploads picture to firebase, returns completion with download URL
        storage.child("images/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            guard error == nil else {
                //failed
                print("Failed to upload picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("images/\(fileName)").downloadURL(completion: {url, error in
                guard let url = url else {
                    print("Cannot get dowload URL")
                    completion(.failure(StorageErrors.failedToGetDownloadUrl))
                    return
                }
                let urlString = url.absoluteString
                print("dowload url: \(urlString)")
                completion(.success(urlString))
            })
        })
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
