//
//  BundleIdentifierManager.swift
//  Player
//
//  Created by Ansèlm Joseph on 15/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Foundation

class BundleIdentifierManager {
    
    private static let appBundleIdentifier = Bundle.main.bundleIdentifier
    
    private static var defaultBundleIdentifier: MediaApplication = .iTunes
    
    private static var oldBundleIdentifier: MediaApplication = .iTunes
    
    private static var newBundleIdentifier: MediaApplication! = nil
    
    static var currentBundleID: MediaApplication {
        if newBundleIdentifier != nil {
            return newBundleIdentifier
        }
        return oldBundleIdentifier
    }
    
    static var defaultBundleID: MediaApplication {
        return defaultBundleIdentifier
    }
    
    static func `init`(withDefaultApplication applicationBID: MediaApplication) {
        BundleIdentifierManager.defaultBundleIdentifier = applicationBID
    }
    
    static func newApplication(withBundleIdentifier bundleIdentifier: String) {
        
        if bundleIdentifier == appBundleIdentifier {
            return
        }
        
        if newBundleIdentifier != nil && newBundleIdentifier.rawValue != bundleIdentifier {
//            print(bundleIdentifier)
            if newBundleIdentifier != oldBundleIdentifier {
                oldBundleIdentifier = newBundleIdentifier
            }
            newBundleIdentifier = MediaApplication(rawValue: bundleIdentifier)
        } else if newBundleIdentifier == nil {
//            print(bundleIdentifier)
            newBundleIdentifier = MediaApplication(rawValue: bundleIdentifier)
        }
    }

    static func stepBackBundle() {
        newBundleIdentifier = oldBundleIdentifier
        oldBundleIdentifier = defaultBundleIdentifier
    }
    
}
