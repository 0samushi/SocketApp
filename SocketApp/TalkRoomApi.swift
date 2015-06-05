//
//  TalkRoomApi.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/21/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class TalkRoomApi {
    
    func fetch() -> [TalkRoom] {
        var rooms = [TalkRoom]()
        if let result:AnyObject = PFCloud.callFunction("fetchRooms", withParameters: nil) {
            for obj in result as! [PFObject] {
                rooms.append(TalkRoom(pfObj: obj))
            }
        }
        return rooms
    }
    
    func addTalkRoom() -> TalkRoom? {
        if let result: AnyObject = PFCloud.callFunction("addTalkRoom", withParameters: nil) {
            if let roomObj = result as? PFObject {
                return TalkRoom(pfObj: roomObj)
            }
        }
        return nil
    }
}