use framework "Foundation"
use scripting additions

script YouTubeScriptObj
    property parent: class "NSObject"
    property listVideos: {}
    
    on isYouTubeOpen()
        if application "Google Chrome" is running then
            tell application "Google Chrome"
                repeat with t in tabs of windows
                    tell t
                        if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                            return true
                        end if
                    end tell
                end repeat
            end tell
        end if
        return false
    end isYouTubeOpen
    
    on listYouTubeVideos()
        set listVideos to {}
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to title of t
                        copy titleCurrentVideo to the end of listVideos
                    end if
                end tell
            end repeat
        end tell
        return listVideos
    end listYouTubeVideos
    
    on playPauseVideo:videoTitle
        set videoState to videoState_(videoTitle)
        if videoState = "Playing" then
            pauseVideo_(videoTitle)
            else if videoState = "Paused" then
            playVideo_(videoTitle)
        end if
    end playPauseVideo:
    
    on videoState:videoTitle
        set videoTitle to videoTitle as string
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to title of t
                        if titleCurrentVideo = videoTitle then
                            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
                            if playerState = "Pause" then
                                return "Playing"
                                else if playerState = "Play" then
                                return "Paused"
                                else
                                return "Stopped"
                            end if
                        end if
                    end if
                end tell
            end repeat
        end tell
        return "Unknown"
    end videoState:
    
    on pauseVideo:videoTitle
        set videoTitle to videoTitle as string
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to title of t
                        if titleCurrentVideo = videoTitle then
                            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
                            if playerState = "Pause" then
                                execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
                                return true
                            end if
                        end if
                    end if
                end tell
            end repeat
        end tell
        return false
    end pauseVideo:
    
    on playVideo:videoTitle
        set videoTitle to videoTitle as string
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to title of t
                        if titleCurrentVideo = videoTitle then
                            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
                            if playerState = "Play" then
                                execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
                                return true
                            end if
                        end if
                    end if
                end tell
            end repeat
        end tell
        return false
    end playVideo:
    
    on isVideoTabActive:videoTitle
        set videoTitle to videoTitle as string
        tell application "System Events" to set frontApp to name of first process whose frontmost is true
        if frontApp = "Google Chrome" then
            tell application "Google Chrome"
                set currentTabTitle to title of active tab of front window
                if currentTabTitle = videoTitle then
                    return true
                end if
            end tell
        end if
        return false
    end isVideoTabActive:
    
    on activeVideoTab()
        tell application "System Events" to set frontApp to name of first process whose frontmost is true
        if frontApp = "Google Chrome" then
            tell application "Google Chrome"
                set currentTabTitle to title of active tab of front window
                if listVideos contains currentTabTitle then
                    return currentTabTitle
                end if
            end tell
        end if
        return "Unknown"
    end activeVideoTab
    
    on debug()
        set x to recentTabIndex as integer
        return x
    end debug
    
end script
