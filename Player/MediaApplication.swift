//
//  YouTube.swift
//  Player
//
//  Created by Ansèlm Joseph on 15/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa

enum MediaApplication: String {
    case iTunes = "com.apple.iTunes"
    case spotify = "com.spotify.client"
    case chrome = "com.google.Chrome"
}

enum PlayerState: String {
    case playing = "Playing"
    case paused = "Paused"
    case stopped = "Stopped"
    case unknown = "Unknown"
}

class Track {
    var name: String
    var artist: String
    var album: String
    var albumArtwork: Data
    
    init(name: String, artist: String, album: String, albumArtwork: Data) {
        self.name = name
        self.album = album
        self.artist = artist
        self.albumArtwork = albumArtwork
    }
}

class CurrentMediaApplication {
    
    private static var script: AppleScript! = nil
    
    static var bundleIdentifier: MediaApplication {
        return BundleIdentifierManager.currentBundleID
    }
    
    static var name: String {
        switch bundleIdentifier {
        case .iTunes:
            return "iTunes"
        case .chrome:
            return "Google Chrome"
        default:
            return "Unknown"
        }
    }
    
    static var track: Track {
        switch bundleIdentifier {
        case .iTunes:
            let trackName = iTunes.currentTrack!.name
            let album = iTunes.currentTrack!.album
            let artist = iTunes.currentTrack!.artist
            let artwork = iTunes.currentTrack!.albumArtwork
            return Track(name: trackName, artist: album, album: artist, albumArtwork: artwork)
            
        case .chrome:
            var trackName: String = ""
            if YouTube.activeVideoTitle != nil {
                trackName = YouTube.activeVideoTitle!
            }
            else if YouTube.recentVideoTitle != nil {
                trackName = YouTube.recentVideoTitle
            }
            else {
                trackName = "YouTube title unavailable"
            }
            
            return Track(name: trackName, artist: "", album: "", albumArtwork: Data())
            
        default:
            return Track(name: "", artist: "", album: "", albumArtwork: Data())
        }
    }
    
    static var state: PlayerState {
        switch bundleIdentifier {
        case .iTunes:
            return iTunes.state
            
        case .chrome:
            return YouTube.state
            
        default:
            return .unknown
        }
    }
    
    static func `init`(withAppleScript appleScript: AppleScript) {
        CurrentMediaApplication.script = appleScript
        YouTube.init(withAppleScript: appleScript)
        iTunes.init(withAppleScript: appleScript)
    }
}

class YouTube {
    
    static var script: AppleScriptYouTubeProtocol! = nil
    static var videoList: [String] = []
    static var recentVideoTitle: String! = nil
    
    static var activeVideoTitle: String? {
        if isAvailable {
            let activeTitle = YouTube.script.activeVideoTab()
            if activeTitle != "Unknown" {
                return activeTitle as String
            }
        }
        return nil
    }
    
    static var activeVideoTitleIndex: Int? {
        if let at = activeVideoTitle {
            return YouTube.videoList.index(of: at)
        }
        return nil
    }
    
    static var recentVideoTitleIndex: Int? {
        if isAvailable {
            if let at = recentVideoTitle {
                return YouTube.videoList.index(of: at)
            }
        }
        return nil
    }
    
    static var isAvailable: Bool {
        if YouTube.script.isYouTubeOpen() {
            return true
        }
        return false
    }
    
    static func `init`(withAppleScript appleScript: AppleScript) {
        YouTube.script = appleScript.youTubeScript
    }
    
    static func playPause() -> Bool {
        
        if !isAvailable {
            return false
        }
        
        update()
        
        var title: NSAppleEventDescriptor! = nil
        
        if let at = activeVideoTitle {
            title = NSAppleEventDescriptor(string: at)
        }
        else if let rt = recentVideoTitle {
            title = NSAppleEventDescriptor(string: rt)
        }
        else if videoList.count == 1 {
            title = NSAppleEventDescriptor(string: videoList[0])
        }
        
        if let t = title {
            let result = YouTube.script.playPauseVideo(t)
            return result
        }
        
        return false
    }
    
    static func pauseAll() {
        if !isAvailable {
            return
        }
        
        update()
        
        for videoTitle in videoList {
            let title = NSAppleEventDescriptor(string: videoTitle)
            let _ = YouTube.script.pauseVideo(title)
        }
    }
    
    static func pauseAllExceptActive() {
        if !isAvailable {
            return
        }
        
        update()
        
        if let active = activeVideoTitle {
            for videoTitle in videoList {
                if videoTitle != active {
                    let title = NSAppleEventDescriptor(string: videoTitle)
                    let _ = YouTube.script.pauseVideo(title)
                }
            }
        }
    }
    
    static func update() {
        YouTube.videoList = YouTube.script.listYouTubeVideos() as! [String]
        if let title = YouTube.activeVideoTitle {
            YouTube.recentVideoTitle = title
        }
    }
    
    static var state: PlayerState {
        
        if !YouTube.isAvailable {
            return .unknown
        }
        
        update()
        
        var title: NSAppleEventDescriptor! = nil
        
        if let at = activeVideoTitle {
            title = NSAppleEventDescriptor(string: at)
        }
        else if let rt = recentVideoTitle {
            title = NSAppleEventDescriptor(string: rt)
        }
        else if videoList.count == 1 {
            title = NSAppleEventDescriptor(string: videoList[0])
        }
        
        if let t = title {
            switch YouTube.script.videoState(t) as String {
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
        
        return .unknown
    }
    
}

class iTunes {
    
    static var script: AppleScriptiTunesProtocol! = nil
    
    static var isOpen: Bool {
        return iTunes.script.isApplicationRunning()
    }
    
    static var isTrackAvailable: Bool {
        return iTunes.script.isTrackAvailable()
    }
    
    static var state: PlayerState {
        switch iTunes.script.getPlayerState() as String {
        case "Playing":
            return .playing
            
        case "Paused":
            return .paused
            
        case "Stopped":
            return .stopped
            
        default:
            return .unknown
        }
    }
    
    static var currentTrack: Track? {
        let currentTrack = iTunes.script.getCurrentlyPlayingTrack() 
        if currentTrack[0] as! String == "failed" {
            return nil
        }
        let name = currentTrack[2] as! String
        let artist = currentTrack[0] as! String
        let album = currentTrack[1] as! String
        let awData = (currentTrack[3] as! NSAppleEventDescriptor).data
        return Track(name: name, artist: artist, album: album, albumArtwork: awData)
    }
    
    static var position: String {
        return iTunes.script.getCurrentPlayerPosition() as String
    }
    
    static func `init`(withAppleScript appleScript: AppleScript) {
        iTunes.script = appleScript.iTunesScript
    }
    
    static func playPause() {
        if isOpen {
            iTunes.script.playPauseiTunes()
        }
    }
    
    static func forward() {
        iTunes.script.forwardiTunes()
    }
    
    static func rewind() {
        iTunes.script.rewindiTunes()
    }
    
}
