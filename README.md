<style>
/** Thin */
@font-face {
  font-family: "San-Francisco-Thin";
  font-weight: 200;
  src: url("https://applesocial.s3.amazonaws.com/assets/styles/fonts/sanfrancisco/sanfranciscodisplay-thin-webfont.woff");
}

/** Regular */
@font-face {
  font-family: "San-Francisco-Regular";
  font-weight: 400;
  src: url("https://applesocial.s3.amazonaws.com/assets/styles/fonts/sanfrancisco/sanfranciscodisplay-regular-webfont.woff");
}

/** Medium **/
@font-face {
  font-family: "San-Francisco-Medium";
  font-weight: 500;
  src: url("https://applesocial.s3.amazonaws.com/assets/styles/fonts/sanfrancisco/sanfranciscodisplay-medium-webfont.woff");
}
</style>
<p align="center" style="font-family:San-Francisco-Thin;font-size:8em;">♮</p>
<p align="center" style="font-family:San-Francisco-Medium;font-size:4em;">Player</p>

&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;
![GitHub version](https://img.shields.io/badge/version-0.2b-yellowgreen.svg)
[![Build Status](https://travis-ci.org/anfederico/Clairvoyant.svg?branch=master)](https://travis-ci.org/anfederico/Clairvoyant)
[![License](https://img.shields.io/badge/license-MIT%20License-brightgreen.svg)](https://opensource.org/licenses/MIT)

<p align="center" style="font-family:San-Francisco-Thin;font-size:1.5em;">Player is a hub that controls all your favourite sources of music with just your Mac's media keys. 🎉</p>

<h3 style="font-family:San-Francisco-Medium;font-size:1.5em">About.</h3>

<p style="font-family:San-Francisco-Thin;">Player resides in your menu bar and has a sleak interface to display what you're listening to when the media keys of your Mac are clicked.</p>
<img src="player2.jpg" alt="Menu Bar"/>
<img src="player1.jpg" alt="Interface 1"/>

<p style="font-family:San-Francisco-Thin;">Player knows you don't want to listen to iTunes when you're watching a YouTube video, so it promptly pauses your iTunes and any other YouTube video that might be playing on other tabs.</p>

<p style="font-family:San-Francisco-Thin;">Player now supports <span style="font-family:San-Francisco-Regular;">iTunes</span> and <span style="font-family:San-Francisco-Regular;">YouTube</span> on Google Chrome! </p>
<p style="font-family:San-Francisco-Thin;">Player is in beta, so it is rough around the edges.</p>

<br/>
<h3 style="font-family:San-Francisco-Medium;font-size:1.5em;">Upcoming.</h3>
<ul>
<li style="font-family:San-Francisco-Thin;">Support for <span style="font-family:San-Francisco-Regular;"> Spotify </span> and <span style="font-family:San-Francisco-Regular;">YouTube on Safari</span> coming soon!</li>
<li style="font-family:San-Francisco-Thin;">Auto-pause all background music when YouTube video starts playing. Currently iTunes and other YouTube tabs will be paused on interacting with YouTube using media keys.</li>
</ul>
<br/>

<h3 style="font-family:San-Francisco-Medium;font-size:1.5em;">Moar deets!</h3>
<p style="font-family:San-Francisco-Thin;">Player uses Swift stable release 3.1.1 on Xcode 8.3.3.</p>
<p style="font-family:San-Francisco-Thin;">Player captures your Mac's hardware media keys when supported apps  are in foreground or when whitelisted apps aren't using your hardware media keys.
<br/>
To achieve this, Player uses <a href="https://github.com/nevyn/SPMediaKeyTap">SPMediaKeyTap</a>. An Objective-C framework to handle media key events.
</p>