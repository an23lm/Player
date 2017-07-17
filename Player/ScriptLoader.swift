//
//  ScriptLoader.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Foundation
import AppleScriptObjC

@objc(NSObject) protocol AppleScriptProtocol {
    var iTunesScript: AppleScriptiTunesProtocol { get set }
    var youTubeScript: AppleScriptYouTubeProtocol { get set }
}

class AppleScript: AppleScriptProtocol {
    var iTunesScript: AppleScriptiTunesProtocol
    var youTubeScript: AppleScriptYouTubeProtocol
    
    init(withiTunesScript iTunes: AnyObject, YouTubeScript youTube: AnyObject) {
        self.iTunesScript = iTunes as! AppleScriptiTunesProtocol
        self.youTubeScript = youTube as! AppleScriptYouTubeProtocol
    }
}

@objc(NSObject) protocol AppleScriptiTunesProtocol {
    func isApplicationRunning() -> Bool
    func isTrackAvailable() -> Bool
    func getPlayerState() -> NSString
    func getCurrentlyPlayingTrack() -> NSArray
    func getCurrentPlayerPosition() -> NSString
    func playPauseiTunes()
    func forwardiTunes()
    func rewindiTunes()
}

@objc(NSObject) protocol AppleScriptYouTubeProtocol {
    var recentTabIndex: NSAppleEventDescriptor { get set }
    func isYouTubeOpen() -> Bool
    func listYouTubeVideos() -> NSArray
    func videoState(_: NSAppleEventDescriptor) -> NSString
    func playPauseVideo(_: NSAppleEventDescriptor) -> Bool
    func playVideo(_: NSAppleEventDescriptor) -> Bool
    func pauseVideo(_: NSAppleEventDescriptor) -> Bool
    func isVideoTabActive(_: NSAppleEventDescriptor) -> Bool
    func activeVideoTab() -> NSString
    func debug() -> NSArray
}

class ScriptLoader {
    static func load() {
        Bundle.main.loadAppleScriptObjectiveCScripts()
    }
    static func `init`() -> AppleScript {
        let iTunesScript = initiTunesScript()
        let youTubeScript = initYouTubeScript()
        
        let scriptObj: AppleScript = AppleScript(withiTunesScript: iTunesScript, YouTubeScript: youTubeScript)
        
        return scriptObj
    }
    static func initiTunesScript() -> AnyObject {
        let scriptObj: AnyClass? = NSClassFromString("iTunesScriptObj")
        let obj = scriptObj!.alloc()
        return obj as AnyObject
    }
    static func initYouTubeScript() -> AnyObject {
        let scriptObj: AnyClass? = NSClassFromString("YouTubeScriptObj")
        let obj = scriptObj!.alloc()
        return obj as AnyObject
    }
}
