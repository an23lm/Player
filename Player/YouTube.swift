//
//  YouTube.swift
//  Player
//
//  Created by Ansèlm Joseph on 14/10/17.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Foundation

class YouTube {
    
    unowned static var shared: YouTube = Script.shared.youTube
    
    var script: AppleScriptYouTubeProtocol! = nil
    var videoList: [NSAppleEventDescriptor] = []
    
    var activeVideoIndex: NSAppleEventDescriptor? {
        guard let activeIndex = self.script.activeVideoTab() else {
            return nil
        }
        return activeIndex
    }
    
    var recentVideoIndex: NSAppleEventDescriptor? = nil
    
    var isAvailable: Bool {
        return self.script.isYouTubeOpen().boolValue
    }
    
    init(withAppleScript appleScript: AppleScriptYouTubeProtocol) {
        self.script = appleScript
    }
    
    func playPause() {
        
        guard isAvailable else {
            return
        }
        
        if (activeVideoIndex != nil) {
            self.script.playPauseVideo(activeVideoIndex!)
        }
        else if recentVideoIndex != nil {
            self.script.playPauseVideo(recentVideoIndex!)
        }
    }
    
    func pauseAll() {
        
        guard isAvailable else {
            return
        }
        
        for videoTitle in videoList {
            let _ = self.script.pauseVideo(videoTitle)
        }
    }
    
    func pauseAllExceptActive() {
        
        guard isAvailable else {
            return
        }
        
        guard let activeTab = activeVideoIndex else {
            return
        }
        
        for tab in videoList {
            if activeTab != tab {
                self.script.pauseVideo(tab)
            }
        }
    }
    
    func update() {
        
        if self.script.isApplicationInForeground() {
            self.videoList = YouTube.shared.script.listYouTubeVideos() as! [NSAppleEventDescriptor]
            
            if let tab = self.activeVideoIndex {
                YouTube.shared.recentVideoIndex = tab
                
                if self.state == .playing {
                    self.pauseAllExceptActive()
                    
                    if ITunes.shared.state == .playing {
                        ITunes.shared.playPause()
                    }
                }
            }
        }
    }
    
    var state: PlayerState {
    
        print(script)
        print("Is youtube open")
        print(self.script.isYouTubeOpen())
        
        if self.isAvailable == false {
            return .unknown
        }
        
        var title: NSAppleEventDescriptor! = nil
        
        if (activeVideoIndex != nil) {
            title = activeVideoIndex!
        }
        else if (recentVideoIndex != nil) {
            title = recentVideoIndex!
        }
        
        script.debug(title.data as NSData)
        print(title)
        
        switch self.script.videoState(title!) as String {
        case "Paused":
            return .paused
            
        case "Playing":
            return .playing
            
        case "Stopped":
            return .stopped
            
        default:
            return .unknown
        }
        
    }
    
    var title: String {
        if self.activeVideoIndex != nil {
            return self.script.titleOfTab(activeVideoIndex!).stringValue!
        }
        else if self.recentVideoIndex != nil {
            return self.script.titleOfTab(recentVideoIndex!).stringValue!
        }
        else {
            return "YouTube title unavailable"
        }
    }
}
