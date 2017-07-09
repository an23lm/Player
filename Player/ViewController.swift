//
//  ViewController.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa

class ViewController: NSViewController {
    
    @IBOutlet weak var albumArtImageView: NSImageView!
    @IBOutlet weak var songNameLabel: NSTextField!
    @IBOutlet weak var songArtistLabel: NSTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
        self.view.window?.level = Int(CGWindowLevelForKey(.floatingWindow))
        self.view.window?.level = Int(CGWindowLevelForKey(.maximumWindow))
        
        self.view.window?.titleVisibility = NSWindowTitleVisibility.hidden
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground  = true
        self.view.window?.standardWindowButton(NSWindowButton.closeButton)?.isHidden = true
        self.view.window?.standardWindowButton(NSWindowButton.miniaturizeButton)?.isHidden = true
        self.view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isHidden = true
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        self.albumArtImageView.imageScaling = .scaleProportionallyUpOrDown
        self.albumArtImageView.imageAlignment = .alignCenter
        self.songNameLabel.stringValue = "Beliver"
        self.songArtistLabel.stringValue = "Imagine Dragons"
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }


}

