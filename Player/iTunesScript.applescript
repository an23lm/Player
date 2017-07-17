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
        tell application "iTunes"
            try
                set currentArtist to album artist of current track
            on error
                return false
            end try
            return true
        end tell
    end isTrackAvailable
        
    on getCurrentlyPlayingTrack()
        tell application "iTunes"
        try
            set currentArtist to album artist of current track
            set currentAlbum to album of current track
            set currentTrack to name of current track
            set frontArtwork to front artwork of current track
            set albumArtwork to (raw data of frontArtwork)
            set currentTrack to (currentArtist, currentAlbum, currentTrack, albumArtwork)
            return currentTrack
            on error
            set fail to "failed"
            return (fail)
        end try
    end tell
    end getCurrentlyPlayingTrack

    on getPlayerState()
        tell application "iTunes"
            set playerState to player state
            if playerState = playerPause then
                return "Paused"
            else if playerState = playerPlay then
                return "Playing"
            else if playerState = playerStop then
                return "Stopped"
            end if
        end tell
        return "Unknown"
    end getPlayerState

    on getCurrentPlayerPosition()
        tell application "iTunes"
            set currentPosition to player position
            return currentPosition
        end tell
    end getCurrentPlayerPosition

    on playPauseiTunes()
        tell application "iTunes"
            playpause
        end tell
    end playPauseiTunes

    on forwardiTunes()
        tell application "iTunes"
            next track
            play
        end tell
    end nextiTunes

    on rewindiTunes()
        tell application "iTunes"
            set currentPosition to player position
            if currentPosition is less than 5.0 then
                previous track
                play
            else
                set player position to 0.0
                play
            end if
        end tell
    end rewindiTunes

end script
