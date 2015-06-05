//
//  MessagesModel.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/17/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import Foundation

class MessagesModel: NSObject {
    
    //-----------------------------
    // プロパティ
    //-----------------------------
    var messages:[Message]!
    var room: TalkRoom!
    
    
    //-----------------------------
    // 初期化
    //-----------------------------
    override init() {
        super.init()
    }
    
    init(_ room:TalkRoom) {
        super.init()
        self.room = room
    }
    
    
    //-----------------------------
    // ロジック
    //-----------------------------
    func fetch() {
        //非同期で実行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            let api = MessageApi(self.room)
            var results = api.fetch()
            self.onRespondData(results)
        }
    }
    
    func addMessage(text: String) {
        if messages == nil {
            return
        }
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            println("addMessage")
            let api = MessageApi(self.room)
            if let msg = api.add(text) {
                println("apiの結果が帰ってきたよ")
                ModelManager.sharedInstance.talkRoomsModel.emitMessage(msg, roomId: self.room.objectId)
                self.onSucceededAddingMessage(msg)
            } else {
                println("apiの結果はnilでした")
            }
        }
    }
    
    func receiveMessage(message: Message) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            if self.messages == nil {
                let api = MessageApi(self.room)
                self.messages = api.fetch()
            }
            self.onSucceededAddingMessage(message)
        }
    }
    
    
    //-----------------------------
    // APIコールバック
    //-----------------------------
    func onRespondData(messages:[Message]) {
        //メインスレッドで実行
        dispatch_async(dispatch_get_main_queue()) {
            self.willChangeValueForKey("messages")
            self.messages = messages
            self.didChangeValueForKey("messages")
        }
    }
    
    func onSucceededAddingMessage(message:Message) {
        for m in messages {
            if m.objectId == message.objectId {
                return
            }
        }
        dispatch_async(dispatch_get_main_queue()) {
            self.willChangeValueForKey("messages")
            self.messages.append(message)
            self.didChangeValueForKey("messages")
        }
    }
    
    
}





