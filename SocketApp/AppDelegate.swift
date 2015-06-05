//
//  AppDelegate.swift
//  SocketApp
//
//  Created by 加藤直人 on 4/16/15.
//  Copyright (c) 2015 加藤直人. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(application: UIApplication, didFinishLaunchingWithOptions launchOptions: [NSObject: AnyObject]?) -> Bool {
        
        //Parse初期設定
        Parse.enableLocalDatastore()
        Parse.setApplicationId("fyX90Ae2lTFgrIobD4DfJpSY1eYQVNgqoGX9l6Bv",
            clientKey: "QuKquXLAPqB1RpHYW8ntuPA8lZK1mOynLuVT7RG0")
        
        
        return true
    }

    func applicationWillResignActive(application: UIApplication) {
        println("willResignActive")
    }

    func applicationDidEnterBackground(application: UIApplication) {
        println("didEnterBackground")
    }

    func applicationWillEnterForeground(application: UIApplication) {
        println("willEnterForeground")
    }

    func applicationDidBecomeActive(application: UIApplication) {
        println("didBecomeActive")
    }

    func applicationWillTerminate(application: UIApplication) {
        println("willTerminate")
    }


}

