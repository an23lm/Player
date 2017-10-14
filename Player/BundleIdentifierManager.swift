//
//  BundleIdentifierManager.swift
//  Player
//
//  Created by Ansèlm Joseph on 15/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Foundation

class BundleIdentifierManager {
    
    static var shared = BundleIdentifierManager()
    
    private let appBundleIdentifier = Bundle.main.bundleIdentifier
    
    private var defaultBundleIdentifier: MediaApplication = .iTunes
    
    private var oldBundleIdentifier: MediaApplication = .iTunes
    
    private var newBundleIdentifier: MediaApplication! = nil
    
    var currentBundleID: MediaApplication {
        if newBundleIdentifier != nil {
            return newBundleIdentifier
        }
        return oldBundleIdentifier
    }
    
    var defaultBundleID: MediaApplication {
        return defaultBundleIdentifier
    }
    
    func newApplication(withBundleIdentifier bundleIdentifier: String) {
        
        if bundleIdentifier == appBundleIdentifier {
            return
        }
        
        if newBundleIdentifier != nil && newBundleIdentifier.rawValue != bundleIdentifier {
//            print(bundleIdentifier)
            if newBundleIdentifier != oldBundleIdentifier {
                oldBundleIdentifier = newBundleIdentifier
            }
            newBundleIdentifier = MediaApplication(rawValue: bundleIdentifier)
            
            performBundleSpecificTasks()
        }
        else if newBundleIdentifier == nil {
//            print(bundleIdentifier)
            newBundleIdentifier = MediaApplication(rawValue: bundleIdentifier)
            
            performBundleSpecificTasks()
        }
    }

    func stepBackBundle() {
        newBundleIdentifier = oldBundleIdentifier
        oldBundleIdentifier = defaultBundleIdentifier
    }
    
    private var youTubeUpdateTimer: Timer! = nil
    
    func performBundleSpecificTasks() {
        switch currentBundleID {
        case .chrome:
            youTubeUpdateTimer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { (timer) in
                YouTube.shared.update()
            })
        default:
            youTubeUpdateTimer.invalidate()
        }
    }
    
}
