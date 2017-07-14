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
    
    var iTunesScript: AppleScriptProtocol! = nil
    
    var viewUpdateTimer = Timer()
    
    var isTrackAvailable: Bool {
        return iTunesScript.isTrackAvailable()
    }
    
    var isiTunesAvailable: Bool {
        return iTunesScript.isApplicationRunning()
    }
    
    var currentPlayerState: String = "" {
        didSet {
            print("set")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    
        self.statusLabel.isHidden = true
        self.pauseView.isHidden = true
        
        iTunesScript = ScriptLoader.initITunesScript() as! AppleScriptProtocol
        
        //self.view.layer?.backgroundColor = NSColor.clear.cgColor
        visualEffectsView.material = .mediumLight
        visualEffectsView.blendingMode = .behindWindow
        visualEffectsView.state = .active
        
        self.view.window?.level = Int(CGWindowLevelForKey(.floatingWindow))
        self.view.window?.level = Int(CGWindowLevelForKey(.maximumWindow))
        
        self.view.window?.titleVisibility = NSWindowTitleVisibility.hidden
        self.view.window?.titlebarAppearsTransparent = true
        self.view.window?.isMovableByWindowBackground  = true
        self.view.window?.standardWindowButton(NSWindowButton.closeButton)?.isHidden = true
        self.view.window?.standardWindowButton(NSWindowButton.miniaturizeButton)?.isHidden = true
        self.view.window?.standardWindowButton(NSWindowButton.zoomButton)?.isHidden = true
    }

    override func viewDidAppear() {
        super.viewDidAppear()
        
    }
    
    override func viewWillAppear() {
        super.viewWillAppear()

        let shadow = NSShadow()
        shadow.shadowBlurRadius = 10
        shadow.shadowColor = NSColor(calibratedWhite: 0.3, alpha: 1)
        shadow.shadowOffset = CGSize(width: -10, height: -10)
        
        self.albumArtImageView.wantsLayer = true
        self.albumArtImageView.shadow = shadow
        
    }
    
    override func viewDidDisappear() {
        super.viewDidDisappear()
        
    }
    
    func setStatusBar() {
        
        print("status")
        print(isiTunesAvailable)
        
        if !isiTunesAvailable {
            statusLabel.stringValue = "iTunes Closed"
        } else {
            let newState = iTunesScript.getPlayerState() as String
            print(currentPlayerState)
            print(newState)
            if currentPlayerState != newState {
                currentPlayerState = newState
            } else {
                return
            }
            
            let status = currentPlayerState
            print(status)
            if status == "paused" || status == "stopped" {
                self.pauseView.alphaValue = 0
                self.pauseView.isHidden = false
                NSAnimationContext.runAnimationGroup({ (animation) in
                    animation.duration = 0.3
                    self.pauseView.animator().alphaValue = 1
                }, completionHandler: nil)
            } else {
                NSAnimationContext.runAnimationGroup({ (animation) in
                    animation.duration = 0.3
                    self.pauseView.animator().alphaValue = 0
                }, completionHandler: { 
                    self.pauseView.isHidden = true
                })
            }
            
            statusLabel.stringValue = status.capitalized
        }
        
        if self.statusLabel.isHidden {
            
            fadeOutLabels(completion: {})
            
            statusLabel.alphaValue = 0
            statusLabel.isHidden = false
            
            NSAnimationContext.runAnimationGroup({ (animaton) in
                animaton.duration = 0.3
                self.statusLabel.animator().alphaValue = 1
            }, completionHandler:  {
                
                NSAnimationContext.runAnimationGroup({ (animation) in
                    animation.duration = 0.3
                    self.statusLabel.animator().alphaValue = 0
                }, completionHandler: { 
                    self.statusLabel.isHidden = true
                    self.fadeInLabels(completion: {})
                })
            })
        }
    }
    
    func fadeOutLabels(completion: @escaping() -> ()) {
        NSAnimationContext.runAnimationGroup({ (animation) in
            animation.duration = 0.3
            self.songAlbumLabel.animator().alphaValue = 0
            self.albumArtImageView.animator().alphaValue = 0
            self.songArtistLabel.animator().alphaValue = 0
            self.songNameLabel.animator().alphaValue = 0
        }, completionHandler: {
            print("comp")
            completion()
        })
    }
    
    func clearSongView() {
        fadeOutLabels {
            self.songAlbumLabel.stringValue = ""
            self.songArtistLabel.stringValue = ""
            self.songNameLabel.stringValue = ""
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
        }, completionHandler: {
            completion()
        })
    }
    
    func updateSongView() {
        
        if !isiTunesAvailable {
            print("iTunes unavailable")
            clearSongView()
            setStatusBar()
            return
        }
        
        let currentSong = iTunesScript.getCurrentlyPlayingTrack()
        
        if currentSong[0] as! String == "failed" {
            print("Track unavailable")
            clearSongView()
            setStatusBar()
            return
        }
        
        setStatusBar()
        
        if currentSong[2] as! String == songNameLabel.stringValue &&
            currentSong[0] as! String == songArtistLabel.stringValue &&
            currentSong[1] as! String == songAlbumLabel.stringValue {
            return
        }
        
        print("Song: ", currentSong[2])
        
        let appleEvent = currentSong[3] as! NSAppleEventDescriptor
        let image = NSImage(data: appleEvent.data)
        
        self.albumArtImageView.imageScaling = .scaleProportionallyUpOrDown
        self.albumArtImageView.imageAlignment = .alignCenter
        
        fadeOutLabels {
            
            self.albumArtImageView.image = image
            self.songNameLabel.stringValue = currentSong[2] as! String
            self.songArtistLabel.stringValue = currentSong[0] as! String
            self.songAlbumLabel.stringValue = currentSong[1] as! String
        
            self.songNameLabel.sizeToFit()
            self.songAlbumLabel.sizeToFit()
            self.songArtistLabel.sizeToFit()
            self.scrollView.contentView.bounds.origin = NSPoint(x: 0, y: 0)
            
            self.fadeInLabels {
                Timer.scheduledTimer(timeInterval: 0.1, target: self, selector: #selector(self.scrollNameLabel), userInfo: nil, repeats: false)
            }
        }
        
    }
    
    func scrollNameLabel() {
        print("scroll label")
        self.contentView.frame = songNameLabel.bounds
        self.scrollView.documentView?.frame = self.contentView.bounds
        
        if self.contentView.bounds.width > self.scrollView.bounds.width {
            
            let clipView: NSClipView = self.scrollView.contentView as NSClipView
            let oldOrigin = clipView.bounds.origin
            var newOrigin = oldOrigin
            print(oldOrigin)
            print(newOrigin)
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
        
    }
}
