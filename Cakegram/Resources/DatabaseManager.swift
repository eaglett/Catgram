//
//  DatabaseManager.swift
//  Cakegram
//
//  Created by Aneja Orlic on 23/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import Foundation
import FirebaseFirestore

//final class cannot be inherited or overridden
final class DatabaseManager {
    
    static let shared = DatabaseManager()
    private let db = Firestore.firestore()
    
    public func addUser(username: String, email: String, phone: String) -> String {
        var result = ""
        db.collection("users").document(email).setData([
            "username": username,
            "email": email,
            "phone": phone,
            "lastImage": 0
        ]) { err in
            if let err = err {
                result = "Error adding document: \(err)"
            } else {
                result = "Document added"
            }
        }
        return result
    }
    
    public func getUser(email: String, completion: @escaping (User) -> ()){
        let docRef = db.collection("users").document(email)
        var user = User()
        
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                user.username = document.data()?["username"] as! String
                user.email = email
                user.phone = document.data()?["phone"] as! String
                user.lastImage = document.data()?["lastImage"] as! Int
                completion(user)
            }
        }
    }
    
    public func updateUser(username: String, phone: String){
        let docRef = db.collection("users").document(LoginSession.session.user.email)
        
        //works even if only 1 field was changed
        docRef.updateData([
            "username": username != "" ? username : LoginSession.session.user.username,
            "phone": phone != "" ? phone : LoginSession.session.user.phone
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document successfully updated")
            }
        }
    }
    
    public func updateLastImage(email: String, imageNumber: Int) -> Bool {
        let docRef = db.collection("users").document(email)
        var updated = false
        docRef.updateData([
            "lastImage": imageNumber
        ]) { err in
            if let err = err {
                updated = false
            } else {
                updated = true
            }
        }
        return updated
    }
    
    public func addImage(name: String){
        db.collection("images").document(name).setData([
            "username": LoginSession.session.user.username,
            "email": LoginSession.session.user.email,
            "likes": Array<String>()
        ]){ err in
            if let err = err {
                print("Error adding document: \(err)")
            } else {
                print("Document added")
            }
        }
    }
    
    public func getImage(name: String, completion: @escaping (Image) -> ()){
        let docRef = db.collection("images").document(name)
        var image = Image()
        
        docRef.getDocument{ (document, error) in
            if let document = document, document.exists {
                let dataDescription = document.data().map(String.init(describing:)) ?? "nil"
                
                image.name = name
                image.username = document.data()!["username"] as! String
                image.email = document.data()?["email"] as! String
                image.likes = document.data()?["likes"] as! Array<String>
                
                completion(image)
            } else {
                print("Document doesn't exist.")
            }
        }
    }
    
    public func updateImage(image: Image){
        let docRef = db.collection("images").document(image.name)
        
        docRef.updateData([
            "likes": image.likes
        ]) { err in
            if let err = err {
                print("Error updating document: \(err)")
            } else {
                print("Document updated")
            }
        }
        
    }
    
    public func deleteImage(imageName: String){
        let docRef = db.collection("images").document(imageName)
        
        docRef.delete(){ err in
           if let err = err {
               print("Error removing document: \(err)")
           } else {
               print("Document successfully removed!")
           }
        }
    }
        
    
}
