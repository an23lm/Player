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
    func isApplicationRunning() -> Bool
    func isTrackAvailable() -> Bool
    func getPlayerState() -> NSString
    func getCurrentlyPlayingTrack() -> NSArray
    func getCurrentPlayerPosition() -> NSString
}

class ScriptLoader {
    static func load() {
        Bundle.main.loadAppleScriptObjectiveCScripts()
    }
    static func initITunesScript() -> AnyObject {
        let scriptObj: AnyClass? = NSClassFromString("iTunesScriptObj")
        let obj = scriptObj!.alloc()
        return obj as AnyObject
    }
}
