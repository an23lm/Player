//
//  AppDelegate.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa
import AppleScriptObjC

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
    
    var appleScript: AppleScript! = nil
    
    override init() {
        super.init()
        
        UserDefaults.standard.register(defaults: [kMediaKeyUsingBundleIdentifiersDefaultsKey: SPMediaKeyTap.defaultMediaKeyUserBundleIdentifiers()])
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        storyboard = NSStoryboard(name: "Main", bundle: nil)
        statusItem.title = "♮"
        
        BundleIdentifierManager.init(withDefaultApplication: .iTunes)
        
        ScriptLoader.load()
        appleScript = ScriptLoader.init()
        
        CurrentMediaApplication.init(withAppleScript: appleScript)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit Player", action: Selector("terminate:"), keyEquivalent: "q"))
        statusItem.menu = menu
        
        let keyTap = SPMediaKeyTap(delegate: self)
        if SPMediaKeyTap.usesGlobalMediaKeyTap() {
            keyTap?.startWatchingMediaKeys()
        } else {
//            NSLog("Monitoring Disabled")
        }
        
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        
        if (state) {
            self.handleMediaKey(event: key)
            self.showView()
        }
    }
    
    func handleMediaKey(event: Int32) {
        
        switch BundleIdentifierManager.currentBundleID {
            
        case .iTunes:
            
            switch event {
                
            case NX_KEYTYPE_PLAY:
                iTunes.playPause()
                let queue = DispatchQueue(label: "com.an23lm.queue1")
                queue.async {
                    if YouTube.isAvailable {
                        if YouTube.state == .playing {
                            YouTube.pauseAll()
                        }
                    }
                }
            
            case NX_KEYTYPE_FAST:
                iTunes.forward()
            
            case NX_KEYTYPE_REWIND:
                iTunes.rewind()
                
            default: break
            }
            
        case .chrome:
            
            switch event {
                
            case NX_KEYTYPE_PLAY:
                
                if YouTube.playPause() == false {
                    BundleIdentifierManager.stepBackBundle()
                    handleMediaKey(event: event)
                } else {
                    let queue = DispatchQueue(label: "com.an23lm.queue1")
                    queue.async {
                        YouTube.pauseAllExceptActive()
                        if iTunes.state == .playing {
                            iTunes.playPause()
                        }
                    }
                }
            
            case NX_KEYTYPE_FAST: break
            case NX_KEYTYPE_REWIND: break
            default: break
            }
            
        default:
            BundleIdentifierManager.stepBackBundle()
            handleMediaKey(event: event)
            break
            
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
    
    override func setLatestBundleIdentifier(_ bundleIdentifier: String!) {
//        print("Set new bundle id")
        BundleIdentifierManager.newApplication(withBundleIdentifier: bundleIdentifier)
        if bundleIdentifier == "com.google.Chrome" {
            YouTube.update()
        }
    }
    
    override func showView() {
        
        if !isWindowVisible {
            
            mainWindowController = storyboard.instantiateController(withIdentifier: "MainWindow") as! NSWindowController
            mainWindow = mainWindowController.window! as! MainScreenWindow
            mainWindow.backgroundColor = NSColor.clear
            mainWindow.alphaValue = 0
            
            let initialViewController = mainWindow.contentViewController as! ViewController
            initialViewController.appleScript = self.appleScript
            
            //Timer.scheduledTimer(timeInterval: 0.2, target: initialViewController, selector: #selector(initialViewController.updateSongView), userInfo: nil, repeats: false)
            
            mainWindow.makeKeyAndOrderFront(nil)
            
            mainWindow.level = Int(CGWindowLevelForKey(.floatingWindow))
            mainWindow.level = Int(CGWindowLevelForKey(.maximumWindow))
            
            mainWindow.collectionBehavior = [.canJoinAllSpaces, .transient]
            mainWindow.animationBehavior = .default
            
            NSApplication.shared().activate(ignoringOtherApps: true)
            
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
