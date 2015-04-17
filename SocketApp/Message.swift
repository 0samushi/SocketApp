//
//  Message.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/17/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class Message: NSObject {
    var text = ""
    
    
    override init(){}
    
    init(_ text:String) {
        self.text = text
    }
}