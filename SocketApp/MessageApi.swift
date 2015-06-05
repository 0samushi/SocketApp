//
//  MessageApi.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/22/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class MessageApi {
    let room: TalkRoom!
    
    init(_ room: TalkRoom) {
        self.room = room
    }
    
    
    func fetch() -> [Message] {
        var messages = [Message]()
        var params = [NSObject: AnyObject]()
        params["roomId"] = self.room.objectId
        if let results: AnyObject? = PFCloud.callFunction("fetchMessages", withParameters: params) {
            for obj in results as! [PFObject] {
                messages.append(Message(pfObj: obj))
            }
        }
        return messages
    }
    
    func add(text:String) -> Message? {
        var params = [NSObject: AnyObject]()
        params["roomId"] = self.room.objectId
        params["text"] = text
        if let result: AnyObject? = PFCloud.callFunction("addMessage", withParameters: params) {
            return Message(pfObj: result as! PFObject)
        }
        return nil
    }
}





