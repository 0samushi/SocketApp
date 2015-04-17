//
//  ViewController.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/16/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    //-------------------------------
    // プロパティ
    //-------------------------------
    @IBOutlet weak var messageBar: UIView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var bottomConstraint: NSLayoutConstraint!
    
    let messagesModel = ModelManager.sharedInstance.messagesModel
    
    //-------------------------------
    // ライフサイクル
    //-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.allowsSelection = false
        
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillShow:"), name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: Selector("keyboardWillHide:"), name: UIKeyboardWillHideNotification, object: nil)
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        messagesModel.addObserver(self, forKeyPath: "messages", options: NSKeyValueObservingOptions.New, context: nil)
        refreshView()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        messagesModel.removeObserver(self, forKeyPath: "messages")
    }
    
    
    //-------------------------------
    // UI
    //-------------------------------
    /** 表示更新 */
    func refreshView() {
        if messagesModel.messages == nil {
            messagesModel.fetch()
            return
        }
        
        tableView.reloadData()
        scrollToBottom()
    }
    
    /** オブザーバ */
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "messages" {
            refreshView()
        }
    }
    
    /** 一番下までスクロール */
    func scrollToBottom() {
        let offset = tableView.contentSize.height - (tableView.frame.size.height)
        if offset > 0 {
            tableView.setContentOffset(CGPointMake(0, offset), animated: true)
        }
        
    }
    
    
    //-------------------------------
    // キーボード表示ロジック
    //-------------------------------
    func keyboardWillShow(notification: NSNotification) {
        let info = notification.userInfo!
        let keyboardFrame: CGRect = (info[UIKeyboardFrameEndUserInfoKey] as! NSValue).CGRectValue()
        let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        self.bottomConstraint.constant = keyboardFrame.size.height
        
        UIView.animateWithDuration(duration!) { () -> Void in
            self.view.layoutIfNeeded()
        }
        
        self.scrollToBottom()
    }
    
    func keyboardWillHide(notification: NSNotification) {
        let info = notification.userInfo!
        let duration = info[UIKeyboardAnimationDurationUserInfoKey]?.doubleValue
        self.bottomConstraint.constant = 0
        
        UIView.animateWithDuration(duration!) { () -> Void in
            self.view.layoutIfNeeded()
        }
    }
    
    
    //-------------------------------
    // タップアクション
    //-------------------------------
    //送信ボタン押下
    @IBAction func didTapSend(sender: AnyObject) {
        if !textField.text.isEmpty {
            let msg = Message(textField.text)
            messagesModel.addMessage(msg)
            refreshView()
        }
        textField.text = ""
    }
    
    //テーブルビュー
    @IBAction func didTapTable(sender: AnyObject) {
        textField.resignFirstResponder()
    }
    
    
    
}


/*----------------------------------------------*/
// MARK: - UITableViewDataSource, UITableViewDelegate
/*----------------------------------------------*/
extension ViewController: UITableViewDataSource, UITableViewDelegate {
    //セル作成
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("MyCell") as! UITableViewCell
        
        if messagesModel.messages != nil {
            let message = messagesModel.messages[indexPath.row]
            cell.textLabel!.text = message.text
        }
        
        return cell
    }
    
    //行数
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (messagesModel.messages != nil) ? messagesModel.messages.count : 0
    }
}




