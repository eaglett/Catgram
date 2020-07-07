//
//  Image.swift
//  Cakegram
//
//  Created by Aneja Orlic on 27/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import Foundation

class Image {
    
    var name: String
    var username: String
    var email: String
    var likes: Array<String>
    
    public init() {
        name = String()
        username = String()
        email = String()
        likes = Array<String>()
    }
    
    func isImageLiked() -> Bool{
        return likes.contains(LoginSession.session.user.email)
    }
    
    func like(){
        likes.append(LoginSession.session.user.email)
        DatabaseManager.shared.updateImage(image: self)
    }
    
    func unlike(){
        if let index = likes.firstIndex(of: LoginSession.session.user.email){
            likes.remove(at: index)
            DatabaseManager.shared.updateImage(image: self)
        }
    }
    
}
