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
    func isApplicationInForeground() -> Bool
    func isYouTubeOpen() -> NSNumber
    func listYouTubeVideos() -> NSArray
    func videoState(_: NSAppleEventDescriptor) -> NSString
    func playPauseVideo(_: NSAppleEventDescriptor)
    func playVideo(_: NSAppleEventDescriptor)
    func pauseVideo(_: NSAppleEventDescriptor)
    func isVideoTabActive(_: NSAppleEventDescriptor) -> Bool
    func activeVideoTab() -> NSAppleEventDescriptor?
    func titleOfTab(_: NSAppleEventDescriptor) -> NSAppleEventDescriptor
    func debug(_: NSData)
}

class Script {
    
    static var shared = Script()
    
    private func load() {
        Bundle.main.loadAppleScriptObjectiveCScripts()
    }
    
    var iTunes: ITunes! = nil
    var youTube: YouTube! = nil
    
    var appleScript: AppleScript! = nil
    
    private func setup() {
        self.load()
        
        let iTunesScript = initiTunesScript()
        let youTubeScript = initYouTubeScript()
        
        let scriptObj: AppleScript = AppleScript(withiTunesScript: iTunesScript, YouTubeScript: youTubeScript)
        
        self.appleScript = scriptObj
        self.iTunes = ITunes(withAppleScript: scriptObj.iTunesScript)
        self.youTube = YouTube(withAppleScript: scriptObj.youTubeScript)
    }
    
    init() {
        setup()
    }
    
    private func initiTunesScript() -> AnyObject {
        let scriptObj: AnyClass? = NSClassFromString("iTunesScriptObj")
        let obj = scriptObj!.alloc()
        return obj as AnyObject
    }
    
    private func initYouTubeScript() -> AnyObject {
        let scriptObj: AnyClass? = NSClassFromString("YouTubeScriptObj")
        let obj = scriptObj!.alloc()
        return obj as AnyObject
    }
}
