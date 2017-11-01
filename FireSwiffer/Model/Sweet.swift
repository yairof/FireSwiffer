//
//  Sweet.swift
//  FireSwiffer
//
//  Created by Yairo Fernandez on 10/17/17.
//  Copyright © 2017 Yairo Fernandez. All rights reserved.
//

import Foundation
import FirebaseDatabase

struct Sweet {
    let key:String!
    let content:String!
    let addedByUser:String!
    let itemRef:DatabaseReference?
    
    init (content:String, addedByUser:String, key:String = "") {
        self.content = content
        self.addedByUser = addedByUser
        self.key = key
        self.itemRef = nil
    }
    init (snapshot:DataSnapshot) {
        key = snapshot.key
        itemRef = snapshot.ref
        
        let value = snapshot.value! as? [String:AnyObject]
        if let sweetContent = value!["content"] as? String {
            content = sweetContent
        }else {
            content = ""
        }
        if let sweetUser = value!["addedByUser"] as? String {
            addedByUser = sweetUser
        }else {
            addedByUser = ""
        }
    }
    
    func toAnyObject() -> [String:AnyObject] {
        return ["content":content as AnyObject, "addedByUser":addedByUser as AnyObject]
    }
}

