//
//  MediaApplication.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa

class MediaApplication: NSApplication {
    override func sendEvent(_ event: NSEvent) {
        
        let shouldHandleEventLocally = !(SPMediaKeyTap.usesGlobalMediaKeyTap())
        
        if shouldHandleEventLocally && event.type == .systemDefined && event.subtype.rawValue == 8 {
            mediaKeyTap(keyTap: nil, receivedMediaKeyEvent: event)
        }
        super.sendEvent(event)
    }
    
    func mediaKeyEvent(key: Int32, state: Bool, keyRepeat: Bool) {
        // Only send events on KeyDown. Without this check, these events will happen twice
        if (state) {
            switch(key) {
            case NX_KEYTYPE_PLAY:
                print("Play")
                delegate!.perform(#selector(AppDelegate.showView))
                break
            case NX_KEYTYPE_FAST:
                print("Next")
                delegate!.perform(#selector(AppDelegate.showView))
                break
            case NX_KEYTYPE_REWIND:
                print("Prev")
                delegate!.perform(#selector(AppDelegate.showView))
                break
            default:
                break
            }
        }
    }
    
    func mediaKeyTap(keyTap: SPMediaKeyTap?, receivedMediaKeyEvent event: NSEvent) {
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

}

