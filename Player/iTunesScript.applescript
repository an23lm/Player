script iTunesScriptObj
    property parent: class "NSObject"
    property playerPause : «constant ****kPSp»
    property playerPlay : «constant ****kPSP»
    property playerStop : «constant ****kPSS»
    
    on isApplicationRunning()
        if application "iTunes" is running then return true
        return false
    end isApplicationRunning
    
    on isTrackAvailable()
        if application "iTunes" is running then tell application "iTunes"
            try
                set currentArtist to album artist of current track
            on error
                return false
            end try
            return true
        end tell
    end isTrackAvailable
        
    on getCurrentlyPlayingTrack()
        if application "iTunes" is running then tell application "iTunes"
        try
            set currentArtist to album artist of current track
            set currentAlbum to album of current track
            set currentTrack to name of current track
            set frontArtwork to front artwork of current track
            set albumArtwork to (raw data of frontArtwork)
            set currentTrack to {currentArtist, currentAlbum, currentTrack, albumArtwork}
            return currentTrack
            on error
            set fail to "failed"
            return {fail}
        end try
    end tell
    end getCurrentlyPlayingTrack

    on getPlayerState()
        if application "iTunes" is running then tell application "iTunes"
            set playerState to player state
            if playerState = playerPause then
                return "paused"
            else if playerState = playerPlay then
                return "playing"
            else if playerState = playerStop then
                return "stopped"
            end if
        end tell
    end getPlayerState

    on getCurrentPlayerPosition()
        if application "iTunes" is running then tell application "iTunes"
            set currentPosition to player position
            return currentPosition
        end tell
    end getCurrentPlayerPosition
end script
