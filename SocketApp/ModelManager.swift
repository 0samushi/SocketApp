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
    let talkRoomsModel = TalkRoomsModel()
    
    var messagesModelDict = [String: MessagesModel]()
    
    func getMessagesModel(room: TalkRoom) -> MessagesModel {
        if let model = messagesModelDict[room.objectId] {
            return model
        }
        let model = MessagesModel(room)
        messagesModelDict[room.objectId] = model
        return model
    }
}