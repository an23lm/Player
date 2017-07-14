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
    
    @IBOutlet weak var window: NSWindow!
    
    var showTimer: Timer = Timer()
    let time = 5.0
    var storyboard: NSStoryboard! = nil
    var mainWindowController: NSWindowController! = nil
    var mainWindow: NSWindow! = nil
    
    var isWindowVisible: Bool = false
    var isWindowTransitioning: Bool = false
    var didReciveInput: Bool = false
    
    let duration = 0.5
    
    
    
    let statusItem = NSStatusBar.system().statusItem(withLength: -1)
    
    override init() {
        super.init()
        
        UserDefaults.standard.register(defaults: [kMediaKeyUsingBundleIdentifiersDefaultsKey: SPMediaKeyTap.defaultMediaKeyUserBundleIdentifiers()])
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        storyboard = NSStoryboard(name: "Main", bundle: nil)
        statusItem.title = "§"
        
        ScriptLoader.load()
        
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit Quotes", action: Selector("terminate:"), keyEquivalent: "q"))
        statusItem.menu = menu
        
        
        let keyTap = SPMediaKeyTap(delegate: self)
        if SPMediaKeyTap.usesGlobalMediaKeyTap() {
            keyTap?.startWatchingMediaKeys()
        } else {
            NSLog("Monitoring Disabled")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        if (state) {
            switch(key) {
            case NX_KEYTYPE_PLAY:
                print("Play")
                self.perform(#selector(self.showView))
                break
            case NX_KEYTYPE_FAST:
                print("Next")
                self.perform(#selector(self.showView))
                break
            case NX_KEYTYPE_REWIND:
                print("Prev")
                self.perform(#selector(self.showView))
                break
            default:
                break
            }
        }
    }
    
    override func mediaKeyTap(_ event: NSEvent!) {
        assert(event.type == .systemDefined && event.subtype.rawValue == 8, "Unexpected NSEvent in mediaKeyTap:receivedMediaKeyEvent:")
        if (event.type == .systemDefined && event.subtype.rawValue == 8) {
            let keyCode = ((event.data1 & 0xFFFF0000) >> 16)
            let keyFlags = (event.data1 & 0x0000FFFF)
            // Get the key state. 0xA is KeyDown, OxB is KeyUp
            let keyState = (((keyFlags & 0xFF00) >> 8)) == 0xA
            let keyRepeat = (keyFlags & 0x1)
            mediaKeyEvent(key: Int32(keyCode), state: keyState, keyRepeat: Bool(NSNumber(integerLiteral: keyRepeat)))
        }
    }
    
    func showView() {
        
        print("Add View")
        
        if !isWindowVisible {
            
            mainWindowController = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
            mainWindow = mainWindowController.window!
            mainWindow.backgroundColor = NSColor.clear
            mainWindow.alphaValue = 0
            
            mainWindow.collectionBehavior = .canJoinAllSpaces
            mainWindow.animationBehavior = .none
            let mainVC = mainWindow.contentViewController as! ViewController
            Timer.scheduledTimer(timeInterval: 0.2, target: mainVC, selector: #selector(mainVC.updateSongView), userInfo: nil, repeats: false)
        
            mainWindow.orderFront(nil)
            
            let contentView = mainWindow.contentView!
            contentView.wantsLayer = true
            contentView.layer!.masksToBounds = true
            contentView.layer!.backgroundColor = NSColor.windowBackgroundColor.cgColor
            contentView.layer!.cornerRadius = 6.0
            
            NSAnimationContext.runAnimationGroup({ (context) -> Void in
                context.duration = duration
                mainWindow.animator().alphaValue = 1
            }, completionHandler: nil)
            
            isWindowVisible = true
        }
        
        else {
            let mainVC = mainWindow.contentViewController as! ViewController
            Timer.scheduledTimer(timeInterval: 0.3, target: mainVC, selector: #selector(mainVC.updateSongView), userInfo: nil, repeats: false)
        }
        
        if isWindowTransitioning {
            self.didReciveInput = true
        }
        
        showTimer.invalidate()
        showTimer = Timer.scheduledTimer(timeInterval: time, target: self, selector: #selector(AppDelegate.removeView), userInfo: nil, repeats: false)
    }
    
    func removeView() {
        print("remove view")
        
        isWindowTransitioning = true
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = duration
            mainWindow.animator().alphaValue = 0
        }, completionHandler: ({
            Void in
            self.mainWindowController.close()
            self.isWindowVisible = false
            self.isWindowTransitioning = false
            if self.didReciveInput {
                self.showView()
                self.didReciveInput = false
            }
        }))
    }
}
