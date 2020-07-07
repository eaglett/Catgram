//
//  LoginSession.swift
//  Cakegram
//
//  Created by Aneja Orlic on 20/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import Foundation
import UIKit
import FirebaseStorage

class LoginSession {
    static var session = LoginSession()
    var user: User
    var currentImage : UIImage
    var currentImageRef : StorageReference
    
    private init() {
        self.user = User()
        self.currentImage = UIImage()
        self.currentImageRef = StorageReference()
    }
    
    public func logout(){
        //reset user
        self.user = User()
        self.currentImage = UIImage()
        self.currentImageRef = StorageReference()
    }
    
}
