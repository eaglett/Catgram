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
    static let defaultImageRef = Storage.storage().reference().child("images/default_user_profile_image.png")
    
    public var imageRef = Array<StorageReference>()
    public var imageDict = Dictionary<Int, UIImage>()
    
    public var userImageRef = Array<StorageReference>()
    public var userImageDict = Dictionary<Int, UIImage>()
    
    public func uploadPicture(with data: Data, fileName: String, type: String, completion: @escaping (Result<String, Error>) -> Void) {
        //set up upload path
        var path: String
        switch type {
        case "PROFILE":
            path = "profileImages"
        default:
            path = "images"
        }
        //uploads picture to firebase, returns completion with download URL
        storage.child("\(path)/\(fileName)").putData(data, metadata: nil, completion: {metadata, error in
            print("35")
            guard error == nil else {
                //failed
                print("Failed to upload picture")
                completion(.failure(StorageErrors.failedToUpload))
                return
            }
            
            self.storage.child("\(path)/\(fileName)").downloadURL(completion: {url, error in
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
        print("54")
    }
    
    public func generateImageName() -> String {
        let formatedEmail = formatEmail(email: LoginSession.session.user.email)
        
        let imageNumber = LoginSession.session.user.lastImage + 1
        LoginSession.session.user.lastImage = imageNumber
        DatabaseManager.shared.updateLastImage(email: LoginSession.session.user.email, imageNumber: imageNumber)
        
        let imageName = formatedEmail + "#" + String(format: "%04d", imageNumber)
        return imageName
    }
    
    public func generateProfileImageName() -> String {
        let formatedEmail = formatEmail(email: LoginSession.session.user.email)
        let imageName = formatedEmail + "_profile_image"
        return imageName
    }
    
    public func getUserProfileImage(email: String, completion: @escaping (UIImage) -> ()) {
        let formatedEmail = formatEmail(email: email)
        
        let imageName = formatedEmail + "_profile_image"
        let imageRef = storage.child("profileImages/" + imageName)
        
        var image : UIImage = UIImage()
        imageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                //download default
                let defaultImageRef =  self.storage.child("profileImages/default_user_profile_image.png")
                
                defaultImageRef.getData(maxSize: 1 * 1024 * 1024) { data, error in
                    if let error = error {
                        print("profile image cannot be accessed right now")
                    } else {
                        image = UIImage(data: data!)!
                        completion(image)
                    }
                }
            } else {
                //our user has a profile image
                image = UIImage(data: data!)!
                completion(image)
            }
        }
    }
    
    public func getCatImageReferences(nbOfImages: Int, completion: @escaping () -> ()) {
        self.imageRef = Array<StorageReference>()
        storage.child("images").listAll() { (result, error) in
            if let error = error {
              print("Cannot list images at the moment. Try again later. Error: ", error)
            }

            var nbArray = Array<Int>()
            while nbArray.count <= nbOfImages {
                let randInt = Int.random(in: 0..<result.items.count)
                if !nbArray.contains(randInt) {
                    nbArray.append(randInt)
                }
            }
            for i in 0..<nbArray.count {
                // Get random images - references
                self.imageRef.append(self.storage.child("images/" + result.items[ nbArray[i] ].name))

            }
            completion()
        }
    }
    
    public func getCatImages(completion: @escaping () -> ()) {
        self.imageDict = Dictionary<Int, UIImage>()
        let group = DispatchGroup()

        for i in 0..<imageRef.count{
            group.enter()

            imageRef[i].getData(maxSize: 1 * 1024 * 1024) { data, error in
         
                if let error = error {
                    print("Cannot access the image right now. Try again later. Error: ", error)
                } else {
                    let image = UIImage(data: data!)
                    //add to dict as key is index and image is the value
                    self.imageDict[i] = image!
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    public func getUserImageReferences(user: String, completion: @escaping () -> ()) {
        userImageRef = Array<StorageReference>()
        storage.child("images").listAll() { (result, error) in
            if let error = error {
              print("Cannot list images at the moment. Try again later. Error: ", error)
            }
            let formatedEmail = self.formatEmail(email: user)
            for item in result.items{
                if item.name.contains(formatedEmail){
                    self.userImageRef.append(self.storage.child("images/" + item.name))
                }
            }
            completion()
        }
    }
    
    public func getUserImages(completion: @escaping () -> ()) {
        userImageDict = Dictionary<Int, UIImage>()
        let group = DispatchGroup()
        for i in 0..<userImageRef.count{
            group.enter()

            userImageRef[i].getData(maxSize: 1 * 1024 * 1024) { data, error in
         
                if let error = error {
                    print("Cannot access the image right now. Try again later. Error: ", error)
                } else {
                    let image = UIImage(data: data!)
                    //add to dict as key is index and image is the value
                    self.userImageDict[i] = image!
                    group.leave()
                }
            }
        }
        group.notify(queue: .main) {
            completion()
        }
    }
    
    public func getImageByName(imageName: String, completion: @escaping (UIImage) -> ()){
        storage.child("images/\(imageName)").getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let error = error {
                print("Cannot access the image right now. Try again later. Error: ", error)
            } else {
                let image = UIImage(data: data!)
                completion(image!)
            }
        }
    }
    
    public func deleteImageByName(imageName: String, completion: @escaping () -> ()){
        storage.child("images/\(imageName)").delete(){error in
            if let error = error {
                print("Cannot be deleted at this moment, error: ", error)
            } else {
                print("Image deleted from storage.")
                completion()
            }
        }
    }
    
    func formatEmail(email: String) -> String{
        //convert email to right format
        let emailArray = email.components(separatedBy: CharacterSet(charactersIn: "@._-"))
        let formatedEmail = emailArray.joined(separator: "_")
        return formatedEmail
    }
    
    public enum StorageErrors: Error {
        case failedToUpload
        case failedToGetDownloadUrl
    }
}
