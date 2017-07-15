script YouTubeScriptObj
    property parent: class "NSObject"
    
    on isApplicationRunning()
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
                        set titleCurrentVideo to execute t javascript "document.getElementsByTagName('title')[0].innerHTML;"
                        copy titleCurrentVideo to the end of listVideos
                    end if
                end tell
            end repeat
        end tell
        return listVideos
    end listYouTubeVideos
    
    on stateOfVideo(videoTitle)
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to execute t javascript "document.getElementsByTagName('title')[0].innerHTML;"
                        if titleCurrentVideo is equal to videoTitle then
                            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
                            if playerState is equal to "Pause" then
                                return "Playing"
                                else if playerState is equal to "Play" then
                                return "Paused"
                                else
                                return "Stopped"
                            end if
                        end if
                    end if
                end tell
            end repeat
        end tell
        return null
    end stateOfVideo
    
    on playPauseVideo(videoTitle)
        set videoState to stateOfVideo(videoTitle)
        if videoState is equal to "Playing" then
            pauseVideo(videoTitle)
            else if videoState is equal to "Paused" then
            playVideo(videoTitle)
        end if
    end playPauseVideo
    
    on pauseVideo(videoTitle)
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to execute t javascript "document.getElementsByTagName('title')[0].innerHTML;"
                        if titleCurrentVideo is equal to videoTitle then
                            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
                            if playerState is equal to "Pause" then
                                execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
                                return true
                            end if
                        end if
                    end if
                end tell
            end repeat
        end tell
        return false
    end pauseVideo
    
    on playVideo(videoTitle)
        tell application "Google Chrome"
            repeat with t in tabs of windows
                tell t
                    if URL starts with "https://www.youtube.com/watch" or URL starts with "http://www.youtube.com/watch" then
                        set titleCurrentVideo to execute t javascript "document.getElementsByTagName('title')[0].innerHTML;"
                        if titleCurrentVideo is equal to videoTitle then
                            set playerState to execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].getAttribute('aria-label')"
                            if playerState is equal to "Play" then
                                execute t javascript "document.getElementsByClassName('ytp-play-button ytp-button')[0].click();"
                                return true
                            end if
                        end if
                    end if
                end tell
            end repeat
        end tell
        return false
    end playVideo
    
    on isVideoTabActive(videoTitle)
        tell application "System Events" to set frontApp to name of first process whose frontmost is true
        if frontApp is equal to "Google Chrome" then
            tell application "Google Chrome"
                set currentTabTitle to title of active tab of front window
                if currentTabTitle is equal to videoTitle then
                    return true
                end if
            end tell
        end if
        return false
    end isVideoTabActive
    
    on activeVideoTab()
        set videoList to listYouTubeVideos()
        tell application "System Events" to set frontApp to name of first process whose frontmost is true
        if frontApp is equal to "Google Chrome" then
            tell application "Google Chrome"
                set currentTabTitle to title of active tab of front window
                if videoList contains currentTabTitle then
                    return currentTabTitle
                end if
            end tell
        end if
        return null
    end activeVideoTab
    
end script
