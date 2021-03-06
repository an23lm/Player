//
//  MainWindow.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa

class MainWindow: NSWindowController {

    override func windowDidLoad() {
        super.windowDidLoad()
    
        // Implement this method to handle any initialization after your window controller's window has been loaded from its nib file.
        
    }
    
    func loadWindowWithPositionIndex(_ index: Int) {
        if let window = window, let screen = window.screen {
            let offsetFromLeftOfScreen: CGFloat = 40
            let offsetFromTopOfScreen: CGFloat = CGFloat(30 + ((window.frame.height + 10) * CGFloat(index)))
            let screenRect = screen.visibleFrame
            let newOriginY = screenRect.maxY - window.frame.height - offsetFromTopOfScreen
            let newOriginX = screenRect.maxX - window.frame.width - offsetFromLeftOfScreen
            window.setFrameOrigin(NSPoint(x: newOriginX, y: newOriginY))
            
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.floatingWindow)))
            window.level = NSWindow.Level(rawValue: Int(CGWindowLevelForKey(.maximumWindow)))
        }
    }

}

class MainScreenWindow: NSWindow {
    
}
