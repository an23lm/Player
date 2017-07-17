//
//  ViewController.swift
//  Player
//
//  Created by Ansèlm Joseph on 10/07/2017.
//  Copyright © 2017 Ansèlm Joseph. All rights reserved.
//

import Cocoa
import AppleScriptObjC

class ViewController: NSViewController {
    
    @IBOutlet weak var albumArtImageView: NSImageView!
    @IBOutlet weak var songNameLabel: NSTextField!
    @IBOutlet weak var songArtistLabel: NSTextField!
    @IBOutlet weak var songAlbumLabel: NSTextField!
    @IBOutlet weak var visualEffectsView: NSVisualEffectView!
    @IBOutlet weak var scrollView: NSScrollViewWOI!
    @IBOutlet weak var contentView: NSView!
    @IBOutlet weak var statusLabel: NSTextField!
    @IBOutlet weak var pauseView: PauseView!
    @IBOutlet weak var applicationName: NSTextField!
    
    var appleScript: AppleScript! = nil
    
    var viewUpdateTimer = Timer()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.statusLabel.isHidden = true
        self.pauseView.isHidden = true
        
        //self.view.layer?.backgroundColor = NSColor.clear.cgColor
        visualEffectsView.material = .mediumLight
        visualEffectsView.blendingMode = .behindWindow
        visualEffectsView.state = .active
    }

    override func viewDidAppear() {
        super.viewDidAppear()
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()
        
        setUpWindow()
        
        self.scrollView.contentView.bounds.origin = NSPoint(x: 0, y: 0)
        self.scrollView.documentView?.frame = self.contentView.bounds
        
        let shadow = NSShadow()
        shadow.shadowBlurRadius = 10
        shadow.shadowColor = NSColor(calibratedWhite: 0.3, alpha: 1)
        shadow.shadowOffset = CGSize(width: -10, height: -10)
        
        self.albumArtImageView.wantsLayer = true
        self.albumArtImageView.shadow = shadow
        
        updateSongView()
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
    }
    
    func setUpWindow() {
        
        self.view.window!.level = Int(CGWindowLevelForKey(.floatingWindow))
        self.view.window!.level = Int(CGWindowLevelForKey(.maximumWindow))
        
        self.view.window?.titleVisibility = NSWindowTitleVisibility.hidden
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground  = true
        self.view.window?.standardWindowButton(NSWindowButton.closeButton)?.isHidden = true
        self.view.window?.standardWindowButton(NSWindowButton.miniaturizeButton)?.isHidden = true
        self.view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isHidden = true
    }
    
    func updatePauseView() {
        if CurrentMediaApplication.state != .paused {
            NSAnimationContext.runAnimationGroup({ (animation) in
                animation.duration = 0.3
                self.pauseView.animator().alphaValue = 0
            }, completionHandler: {
                self.pauseView.isHidden = true
            })
        }
        else {
            self.pauseView.alphaValue = 0
            self.pauseView.isHidden = false
            NSAnimationContext.runAnimationGroup({ (animation) in
                animation.duration = 0.3
                self.pauseView.animator().alphaValue = 1
            }, completionHandler: nil)
        }
    }
    
    func fadeOutLabels(compeletion: @escaping() -> ()) {
        NSAnimationContext.runAnimationGroup({ (animation) in
            animation.duration = 0.3
            self.songAlbumLabel.animator().alphaValue = 0
            self.albumArtImageView.animator().alphaValue = 0
            self.songArtistLabel.animator().alphaValue = 0
            self.songNameLabel.animator().alphaValue = 0
            self.applicationName.animator().alphaValue = 0
        }, completionHandler: {
            compeletion()
        })
    }
    
    func clearSongView() {
        fadeOutLabels {
            self.songAlbumLabel.stringValue = ""
            self.songArtistLabel.stringValue = ""
            self.songNameLabel.stringValue = ""
            self.applicationName.stringValue = ""
            self.albumArtImageView.image = NSImage()
        }
    }
    
    func fadeInLabels(completion: @escaping () -> Void) {
        NSAnimationContext.runAnimationGroup({ (animation) in
            animation.duration = 0.3
            self.songAlbumLabel.animator().alphaValue = 1
            self.albumArtImageView.animator().alphaValue = 1
            self.songArtistLabel.animator().alphaValue = 1
            self.songNameLabel.animator().alphaValue = 1
            self.applicationName.animator().alphaValue = 1
        }, completionHandler: {
            completion()
        })
    }
    
    var previousTrack: Track = Track(name: "", artist: "", album: "", albumArtwork: Data())
    var previousState: PlayerState = .unknown
    
    func updateSongView() {
        
        if previousState != CurrentMediaApplication.state {
            updatePauseView()
            previousState = CurrentMediaApplication.state
        }
        
        if previousTrack.name != CurrentMediaApplication.track.name  {
        
            previousTrack = CurrentMediaApplication.track
            
            var albumArtworkImage = NSImage(data: CurrentMediaApplication.track.albumArtwork)
            
            if CurrentMediaApplication.bundleIdentifier == .chrome {
                albumArtworkImage = NSImage(named: "YouTube-Icon.png")
            }
            
            self.albumArtImageView.imageScaling = .scaleProportionallyUpOrDown
            self.albumArtImageView.imageAlignment = .alignCenter
            
            fadeOutLabels {
                
                self.albumArtImageView.image = albumArtworkImage
                self.songNameLabel.stringValue = CurrentMediaApplication.track.name
                self.songArtistLabel.stringValue = CurrentMediaApplication.track.artist
                self.songAlbumLabel.stringValue = CurrentMediaApplication.track.album
                self.applicationName.stringValue = CurrentMediaApplication.name
            
                self.songNameLabel.sizeToFit()
                self.songAlbumLabel.sizeToFit()
                self.songArtistLabel.sizeToFit()
                self.applicationName.sizeToFit()
                
                self.scrollView.contentView.bounds.origin = NSPoint(x: 0, y: 0)
                
                self.fadeInLabels {
                    Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollNameLabel), userInfo: nil, repeats: false)
                }
            }
        
        }
        
    }
    
    func scrollNameLabel() {
        
        self.contentView.frame = songNameLabel.bounds
        self.scrollView.documentView?.frame = self.contentView.bounds
        
        if self.contentView.bounds.width > self.scrollView.bounds.width {
            
            let clipView: NSClipView = self.scrollView.contentView as NSClipView
            let oldOrigin = clipView.bounds.origin
            var newOrigin = oldOrigin
            newOrigin.x = self.contentView.bounds.width - self.scrollView.bounds.width
            
            NSAnimationContext.runAnimationGroup({ (animation) in
                animation.duration = 2
                animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                clipView.animator().setBoundsOrigin(newOrigin)
            }, completionHandler: {
                Void in
                NSAnimationContext.runAnimationGroup({ (animation1) in
                    animation1.duration = 2
                    animation1.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
                    clipView.animator().setBoundsOrigin(oldOrigin)
                }, completionHandler: nil)
            })
        }
    }
}

class NSScrollViewWOI: NSScrollView {
    override func scrollWheel(with event: NSEvent) {
        // leave override empty so that the view does not respond when scrolled.
    }
}
