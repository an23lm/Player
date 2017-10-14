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
    var mainWindowController: MainWindow! = nil
    var mainWindow: NSWindow! = nil
    
    var isWindowVisible: Bool = false
    var isWindowTransitioning: Bool = false
    var didReciveInput: Bool = false
    
    let duration = 0.5
    
    let statusItem = NSStatusBar.system.statusItem(withLength: -1)
    
    var appleScript: AppleScript! = nil
    
    override init() {
        super.init()
        
        UserDefaults.standard.register(defaults: [kMediaKeyUsingBundleIdentifiersDefaultsKey: SPMediaKeyTap.defaultMediaKeyUserBundleIdentifiers()])
        
    }
    
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        // Insert code here to initialize your application
        
        storyboard = NSStoryboard(name: NSStoryboard.Name(rawValue: "Main"), bundle: nil)
        statusItem.title = "♮"
        
//        BundleIdentifierManager.init(withDefaultApplication: .iTunes)
        
//        ScriptLoader.load()
//        appleScript = ScriptLoader.init()
        
//        CurrentMediaApplication.init(withAppleScript: appleScript)
        
        let menu = NSMenu()
        menu.addItem(NSMenuItem(title: "Quit Player", action: #selector(terminateApplication(_:)), keyEquivalent: "q"))
        statusItem.menu = menu
        
        NotificationCenter.default.addObserver(self, selector: #selector(iTunesTrackChanged(_:)), name: NSNotification.Name.iTunesTrackChanged, object: nil)
        
        let keyTap = SPMediaKeyTap(delegate: self)
        if SPMediaKeyTap.usesGlobalMediaKeyTap() {
            keyTap?.startWatchingMediaKeys()
        } else {
            NSLog("Monitoring Disabled")
        }
        
//        print(Script.shared.youTube.script.isYouTubeOpen().boolValue)
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
        
        NotificationCenter.default.removeObserver(self)
    }
    
    @objc func terminateApplication(_ sender: Notification) {
        NSApplication.shared.terminate(self)
    }
    
    // MARK: - Notifications
    @objc private func iTunesTrackChanged(_ sender: Notification) {
        print("something")
        self.showView()
    }
    
    // MARK: - SPMediaKeys Functions
    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        
        if (state) {
            self.handleMediaKey(event: key)
            self.showView()
        }
    }
    
    func handleMediaKey(event: Int32) {
        
        print(BundleIdentifierManager.shared.currentBundleID)
        switch BundleIdentifierManager.shared.currentBundleID {
            
        case .iTunes:
            
            switch event {
                
            case NX_KEYTYPE_PLAY:
                ITunes.shared.playPause()
                let queue = DispatchQueue(label: "com.an23lm.queue1")
                queue.async {
                    if YouTube.shared.isAvailable {
                        if YouTube.shared.state == .playing {
                            YouTube.shared.pauseAll()
                        }
                    }
                }
            
            case NX_KEYTYPE_FAST:
                ITunes.shared.forward()
            
            case NX_KEYTYPE_REWIND:
                ITunes.shared.rewind()
                
            default: break
            }
            
        case .chrome:
            
            switch event {
                
            case NX_KEYTYPE_PLAY:
                YouTube.shared.playPause()
                let queue = DispatchQueue(label: "com.an23lm.queue1")
                queue.async {
                    YouTube.shared.pauseAllExceptActive()
                    if ITunes.shared.state == .playing {
                        ITunes.shared.playPause()
                    }
                }
            
            case NX_KEYTYPE_FAST: break
            case NX_KEYTYPE_REWIND: break
            default: break
            }
            
        default:
            BundleIdentifierManager.shared.stepBackBundle()
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
            mediaKeyEvent(key: Int32(keyCode), state: keyState, keyRepeat: Bool(truncating: NSNumber(integerLiteral: keyRepeat)))
        }
    }
    
    override func setLatestBundleIdentifier(_ bundleIdentifier: String!) {
//        print("Set new bundle id")
        BundleIdentifierManager.shared.newApplication(withBundleIdentifier: bundleIdentifier)
    
    }
    
    override func showView() {
        
        if !isWindowVisible {
            
            mainWindowController = (storyboard.instantiateController(withIdentifier: NSStoryboard.SceneIdentifier(rawValue: "MainWindow")) as! NSWindowController) as! MainWindow
            mainWindow = mainWindowController.window! as! MainScreenWindow
            mainWindowController.loadWindowWithPositionIndex(0)
            mainWindow.backgroundColor = NSColor.clear
            mainWindow.alphaValue = 0
            
            let initialViewController = mainWindow.contentViewController as! ViewController
            initialViewController.appleScript = self.appleScript
            
//            Timer.scheduledTimer(timeInterval: 0.2, target: initialViewController, selector: #selector(initialViewController.updateSongView), userInfo: nil, repeats: false)
            
            mainWindow.makeKeyAndOrderFront(nil)
            
            mainWindow.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
            mainWindow.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
            
            mainWindow.collectionBehavior = [NSWindow.CollectionBehavior.canJoinAllSpaces, NSWindow.CollectionBehavior.transient]
            mainWindow.animationBehavior = .default
            
            NSApplication.shared.activate(ignoringOtherApps: true)
            
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
    
    @objc func removeView() {
        
        isWindowTransitioning = true
        
        NSAnimationContext.runAnimationGroup({ (context) -> Void in
            context.duration = duration
            mainWindow.animator().alphaValue = 0
        }) {
            self.mainWindowController.close()
            self.isWindowVisible = false
            self.isWindowTransitioning = false
            if self.didReciveInput {
                self.showView()
                self.didReciveInput = false
            }
        }
    }
}
