//
//  ModelManager.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/17/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class ModelManager {
    static let sharedInstance = ModelManager()
    private init(){}
    
    
    let messagesModel = MessagesModel()
}