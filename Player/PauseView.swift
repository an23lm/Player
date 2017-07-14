//
//  PauseView.swift
//  Player
//
//  Created by Ansèlm Joseph on 11/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa

@IBDesignable
class PauseView: NSView {

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)

        // Drawing code here.
        
        let width = self.frame.width
        let height = self.frame.height
        
        let center = CGPoint(x: width/2, y: height/2)
        
        let lineWidth = width / 4
        let lineHeight = height - 4
        
        let rect1 = NSRect(x: center.x - lineWidth - lineWidth/3, y: center.y - lineHeight/2, width: lineWidth, height: lineHeight)
        let path1 = NSBezierPath(roundedRect: rect1, xRadius: 2, yRadius: 2)
        NSColor.black.setFill()
        
        let rect2 = NSRect(x: center.x + lineWidth/3, y: center.y - lineHeight/2, width: lineWidth, height: lineHeight)
        let path2 = NSBezierPath(roundedRect: rect2, xRadius: 2, yRadius: 2)
        NSColor.black.setFill()
        
        path1.fill()
        path2.fill()
        
    }
    
}
