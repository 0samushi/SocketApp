//
//  Message.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/17/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class Message: NSObject {
    let objectId: String
    let text: String
    
    init(objectId: String, text: String) {
        self.objectId = objectId
        self.text = text
    }
    
    init(pfObj: PFObject) {
        if let objectId = pfObj.objectId {
            self.objectId = objectId
        } else {
            self.objectId = ""
        }
        if let t = pfObj.valueForKey("text") as? String {
            self.text = t
        } else {
            self.text = ""
        }
        super.init()
    }
}