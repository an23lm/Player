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
        
        if let window = window, let screen = window.screen {
            let offsetFromLeftOfScreen: CGFloat = 40
            let offsetFromTopOfScreen: CGFloat = 30
            let screenRect = screen.visibleFrame
            let newOriginY = screenRect.maxY - window.frame.height - offsetFromTopOfScreen
            let newOriginX = screenRect.maxX - window.frame.width - offsetFromLeftOfScreen
            window.setFrameOrigin(NSPoint(x: newOriginX, y: newOriginY))
        }
        
    }

}
