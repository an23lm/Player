use framework "Foundation"
use framework "AppleScriptObjC"
use scripting additions

script YouTubeScriptObj
    property parent: class "NSObject"
    property ytTab: {}
    
    on isApplicationInForeground()
        if application "Google Chrome" is frontmost then
            return true
        end if
        return false
    end isApplicationInForeground
    
    on isYouTubeOpen()
        if application "Google Chrome" is running then
            tell application "Google Chrome"
                repeat with t in tabs of windows
                    tell t
                        if URL starts with "https://www.youtube.com/watch" then
                            return true
                        end if
                    end tell
                end repeat
            end tell
        end if
        return false
    end isYouTubeOpen
    
    on listYouTubeVideos()
        set ytTab to {}
        tell application "Google Chrome"
            repeat with w in windows
                repeat with t in tabs of w
                    tell t
                        if URL starts with "https://www.youtube.com/watch" then
                            copy t to the end of ytTab
                        end if
                    end tell
                end repeat
            end repeat
        end tell
        return ytTab
    end listYouTubeVideos
    
    on playPauseVideo:t
        set videoState to videoState(t)
        if videoState = "Playing" then
            pauseVideo(t)
            else if videoState = "Paused" then
            playVideo(t)
        end if
    end playPauseVideo
    
    on pauseVideo:t
        tell application "Google Chrome"
            execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
        end tell
    end pauseVideo
    
    on playVideo:t
        tell application "Google Chrome"
            execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
        end tell
    end playVideo
    
    on videoState:t
        tell application "Google Chrome"
            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
            if playerState = "Pause" then
                return "Playing"
            else if playerState = "Play" then
                return "Paused"
            else
                return "Stopped"
            end if
        end tell
        return "Unknown"
    end videoState
    
    on isVideoTabActive:t
        if application "Google Chrome" is frontmost then
            tell application "Google Chrome"
                set c to count window
                if c is not equal to 0 then
                    if t = active tab of front window then
                        return true
                    end if
                end if
            end tell
        end if
        return false
    end isVideoTabActive
    
    on activeVideoTab()
        if application "Google Chrome" is frontmost then
            tell application "Google Chrome"
                set c to count window
                if c is not equal to 0 then
                    return active tab of front window
                end if
            end tell
        end if
        return null
    end activeVideoTab
    
    on titleOfTab:t
        tell application "Google Chrome"
            return title of t
        end tell
    end titleOfTab
    
    on debug:t
        log "testing"
        tell application "Google Chrome"
            
            log class of t
            log properties of t

            if class of t = class of tab then
                log true
            end if
        end tell
        log "--------"
    end debug
    
end script
