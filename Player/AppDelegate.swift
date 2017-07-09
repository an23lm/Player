//
//  AppDelegate.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    var showTimer: Timer = Timer()
    let time = 1.0
    
    override init() {
        super.init()
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        NSApplication.shared().windows.last!.close()
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }

    func showView() {
        print("Show view")
        NSApplication.shared().windows.last!.makeKeyAndOrderFront(nil)
        NSApplication.shared().activate(ignoringOtherApps: true)
        showTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(AppDelegate.removeView), userInfo: nil, repeats: false)
    
    }
    
    func removeView() {
        print("remove view")
        NSApplication.shared().windows.last!.close()
    }
}

