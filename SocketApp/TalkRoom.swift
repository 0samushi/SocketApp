//
//  TalkRoom.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/21/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//


import Foundation

class TalkRoom : NSObject {
    var objectId = ""
    
    override init() {
        super.init()
    }
    
    init(pfObj: PFObject) {
        super.init()
        if let objectId = pfObj.objectId {
            self.objectId = objectId
        }
    }
}