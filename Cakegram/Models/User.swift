//
//  User.swift
//  Cakegram
//
//  Created by Aneja Orlic on 23/06/2020.
//  Copyright © 2020 Aneja Orlic. All rights reserved.
//

import Foundation

class User {
    
    var username: String
    var email: String
    var phone: String
    var lastImage: Int
    
    init() {
        self.username = ""
        self.email = ""
        self.phone = ""
        self.lastImage = 0
    }
    
    init(username: String, email: String, phone: String, lastImage: Int) {
        self.username = username
        self.email = email
        self.phone = phone
        self.lastImage = lastImage
    }
}
