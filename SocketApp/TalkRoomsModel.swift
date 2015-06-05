//
//  TalkRoomsModel.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/21/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class TalkRoomsModel : NSObject {
    
    //---------------------------------
    // プロパティ
    //---------------------------------
    var rooms:[TalkRoom]!
    var socket = SocketIOClient(socketURL: "http://ec2-52-68-41-54.ap-northeast-1.compute.amazonaws.com:3000")
    
    //---------------------------------
    // 初期化
    //---------------------------------
    override init() {
        super.init()
        
        socket.on("connect") { data, act in
            println("ソケット接続完了")
        }
        
        socket.on("emit_from_server") {
            (data:NSArray?, act:AckEmitter?) in
            println("Nodeから受信！")
            if let dict = data?[0] as? NSDictionary {
                let text = dict.objectForKey("text") as! String
                let msgId = dict.objectForKey("msgId") as! String
                let roomId = dict.objectForKey("roomId") as! String
                println("\(roomId): \(text)")
                
                if let r = self.getRoom(roomId) {
                    let m = ModelManager.sharedInstance.getMessagesModel(r)
                    let msg = Message(objectId: msgId, text: text)
                    m.receiveMessage(msg)
                }
            }
        }
        socket.connect()
    }
    
    //---------------------------------
    // ロジック
    //---------------------------------
    func emitMessage(message:Message, roomId:String) {
        let myJson = [
            "text": message.text,
            "msgId": message.objectId,
            "roomId": roomId
        ]
        self.socket.emit("emit_from_ios", myJson)
    }
    
    func getRoom(roomId: String) -> TalkRoom? {
        for r in rooms {
            if r.objectId == roomId {
                return r
            }
        }
        return nil
    }
    
    func fetch() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let api = TalkRoomApi()
            let results = api.fetch()
            self.onRespondData(results)
        }
    }
    
    func add() {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), {
            let api = TalkRoomApi()
            if let result = api.addTalkRoom() {
                self.onSucceedAddRoom(result)
            }
        })
    }
    
    //---------------------------------
    // APIコールバック
    //---------------------------------
    func onRespondData(rooms: [TalkRoom]) {
        dispatch_async(dispatch_get_main_queue()) {
            self.willChangeValueForKey("rooms")
            self.rooms = rooms
            self.didChangeValueForKey("rooms")
        }
        
        for r in rooms {
            self.join(r)
        }
    }
    
    func onSucceedAddRoom(room: TalkRoom) {
        dispatch_async(dispatch_get_main_queue()) {
            self.willChangeValueForKey("rooms")
            self.rooms.append(room)
            self.didChangeValueForKey("rooms")
        }
        self.join(room)
    }
    
    func join(room: TalkRoom) {
        let myJson = [
            "room": room.objectId
        ]
        self.socket.emit("join_from_ios", myJson)
    }
    
}