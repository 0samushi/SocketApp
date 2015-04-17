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
    
    //-----------------------------
    // ロジック
    //-----------------------------
    func fetch() {
        //非同期で実行
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0)) {
            var results = [Message]()
            results.append(Message("ほげ"))
            results.append(Message("ふが"))
            results.append(Message("ひげ"))
            results.append(Message("ほげ"))
            results.append(Message("ふが"))
            results.append(Message("ひげ"))
            results.append(Message("ほげ"))
            results.append(Message("ふが"))
            results.append(Message("ひげ"))
            self.onRespondData(results)
        }
    }
    
    func addMessage(message:Message) {
        if messages != nil {
            messages.append(message)
        }
    }
    
    func onRespondData(messages:[Message]) {
        //メインスレッドで実行
        dispatch_async(dispatch_get_main_queue()) {
            self.willChangeValueForKey("messages")
            self.messages = messages
            self.didChangeValueForKey("messages")
        }
    }
}