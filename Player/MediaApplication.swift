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
    
    static var shared: CurrentMediaApplication = CurrentMediaApplication(withAppleScript: Script.shared.appleScript)
    
    private var script: AppleScript! = nil
    
    var bundleIdentifier: MediaApplication {
        return BundleIdentifierManager.shared.currentBundleID
    }
    
    var name: String {
        switch bundleIdentifier {
        case .iTunes:
            return "iTunes"
        case .chrome:
            return "Google Chrome"
        default:
            return "Unknown"
        }
    }
    
    var track: Track {
        switch bundleIdentifier {
        case .iTunes:
            let trackName = ITunes.shared.currentTrack!.name
            let album = ITunes.shared.currentTrack!.album
            let artist = ITunes.shared.currentTrack!.artist
            let artwork = ITunes.shared.currentTrack!.albumArtwork
            return Track(name: trackName, artist: album, album: artist, albumArtwork: artwork)
            
        case .chrome:
            return Track(name: YouTube.shared.title, artist: "", album: "", albumArtwork: Data())
            
        default:
            return Track(name: "", artist: "", album: "", albumArtwork: Data())
        }
    }
    
    var state: PlayerState {
        switch bundleIdentifier {
        case .iTunes:
            return ITunes.shared.state
            
        case .chrome:
            return YouTube.shared.state
            
        default:
            return .unknown
        }
    }
    
    init (withAppleScript appleScript: AppleScript) {
        self.script = appleScript
//        YouTube.init(withAppleScript: appleScript)
//        iTunes.init(withAppleScript: appleScript)
    }
}
