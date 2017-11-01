//
//  User.swift
//  FireSwiffer
//
//  Created by Yairo Fernandez on 10/17/17.
//  Copyright © 2017 Yairo Fernandez. All rights reserved.
//

import Foundation
import FirebaseAuth

struct Users {
    let uid:String
    let email:String
    
    init(userData:User) {
        uid = userData.uid
        
        if let mail = userData.providerData.first?.email {
            email = mail
        } else {
            email = ""
        }
    }
    init (uid:String, email:String) {
        self.uid = uid
        self.email = email
    }
}
