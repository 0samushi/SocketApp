//
//  TalkRoomViewController.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/21/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import UIKit

class TalkRoomViewController: UIViewController {
    //-------------------------------
    // プロパティ
    //-------------------------------
    @IBOutlet weak var tableView: UITableView!
    let model = ModelManager.sharedInstance.talkRoomsModel
    @IBOutlet weak var indicator: UIActivityIndicatorView!

    //-------------------------------
    // ライフサイクル
    //-------------------------------
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.hidden = true
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear")
        super.viewWillAppear(animated)
        model.addObserver(self, forKeyPath: "rooms", options: NSKeyValueObservingOptions.New, context: nil)
        refreshViews()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("viewWillDisappear")
        super.viewWillDisappear(animated)
        model.removeObserver(self, forKeyPath: "rooms")
    }
    
    //-------------------------------
    // UI
    //-------------------------------
    func refreshViews() {
        if model.rooms == nil {
            model.fetch()
            return
        }
        
        tableView.hidden = false
        indicator.hidden = true
        tableView.reloadData()
    }
    
    //-------------------------------
    // オブザーバ
    //-------------------------------
    override func observeValueForKeyPath(keyPath: String, ofObject object: AnyObject, change: [NSObject : AnyObject], context: UnsafeMutablePointer<Void>) {
        if keyPath == "rooms" {
            refreshViews()
        }
    }
    
    //-------------------------------
    // タップアクション
    //-------------------------------
    @IBAction func didTapAdd(sender: AnyObject) {
        model.add()
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "TalkRoomSegue" {
            let vc = segue.destinationViewController as! MessagesViewController
            if let indexPath = self.tableView.indexPathForSelectedRow() {
                let room = model.rooms[indexPath.row]
                vc.room = room
            }
        }
    }
}


/*---------------------------------------------------*/
// # Mark - UITableViewDataSource & UITableViewDelegate
/*---------------------------------------------------*/
extension TalkRoomViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCellWithIdentifier("TalkRoomCell") as! UITableViewCell
        let room = model.rooms[indexPath.row]
        cell.textLabel!.text = room.objectId
        return cell
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return (model.rooms != nil) ? model.rooms.count : 0
    }
}








