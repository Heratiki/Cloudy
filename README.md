# Cloudy [![Build Status](https://app.bitrise.io/app/49fce2359d6d6a84/status.svg?token=TBrG_oLSXY9A8UfySh1Y9w&branch=develop)](https://app.bitrise.io/app/49fce2359d6d6a84)

[![Cloudy Server](https://img.shields.io/discord/591914197219016707.svg?label=Discord&logo=Discord&colorB=7289da&style=for-the-badge)](https://discord.gg/9sgTxFx)

A cloud gaming ready browser for iOS.

![](Media/cloudy.gif)

# Features

## Supported Features

- Right now opens stadia path automatically on first startup
- Supports Bluetooth gaming controllers
- Fullscreen support
- The following shortcuts in the address bar (just type in the following alias in order to get to the desired platform)
  - `stadia` -> opens stadia
  - `gfn` -> opens geforce now 
  - `boost` -> opens boosteroid
- If you want to go crazy, you can specify your custom user agent
- Reset all cookies and caches

## Features in development

- Fixing broken axis controls on geforce now
- Touch controls to imitate the mouse
- Keyboard input
- Virtual controller

## Trello development board

Feel free to discuss features, bugs and other improvement requests on the public Trello board.
> https://trello.com/b/A2Z965Sf

# Support the development

 Patreon             |  Paypal
:-------------------------:|:-------------------------:
[![patreon](Media/becomePatreon.png)](https://www.patreon.com/cloudyApp)  |  [![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donate_LG.gif)](https://paypal.me/pools/c/8tKK9M8XUi)

# Ways to get the app on your device

## 1. Build it your own

Here is a quick guide on how to build the app on your own.

### Prerequisites
An Intel-based Mac running macOS Catalina 10.15.4 or later & Version 12.1 (12A7403) (no other version yet supported)

1. Install XCode https://apps.apple.com/de/app/xcode/id497799835?mt=12
2. Install Cocoapods https://cocoapods.org/
3. Download (or clone) Cloudy source code repostiory (visit https://github.com/mlostekk/Cloudy then look for a green `Code` button, hit it and select `Download ZIP`)
4. Unzip the archive
5. Install pods via `pod install`
6. Doubleclick `Cloudy.xcworkspace`, XCode 12.1 should open
7. Connect iOS device to your Mac, let it some time to be recognized
8. Select your device in XCode [`1`]
9. Go to `Cloudy` [`2`], select `Signing & Capabilities` [`3`]
10. Select your name inside `Team` [`4`] and change the `Bundle Identifier`[`4`] to something / whatever you like `com.your.favorite.villian`
11. Press run [`5`] and wait until it pops up on your device
12. Have a lot of fun streaming games on iOS

![](Media/xcode.png)

## 2. Sideload an unsigned IPA

### Windows

1. Make sure you have the downloadable binary version of iTunes and iCloud installed on your PC. Do NOT install the version of iTunes from the Windows 10 App Store.
2. Download AltServer (requires Windows 10) here: https://altstore.io/
3. After installing AltServer, plug your phone into your PC and move the .IPA file onto your phone using iTunes to save it somewhere you can navigate to in the Files app. 
4. Open AltServer, and it will open in the hidden icon tray located on the right side of your taskbar (the button that looks like an up arrow, beside the volume speaker.) and click the AltServer icon (looks like a diamond).
5. Making sure your phone is plugged in, install AltStore to your phone through this menu. You will have to login to your iTunes account.
6. Once you login to your iTunes account and click through any remaining dialog boxes, AltStore will be installed on your phone. LEAVE ALTSERVER RUNNING! AltServer signs the apps remotely, and will do it whenever it sees your device on the network, so make sure that it stays running so you can continue to use your apps without issue.
7. Open AltStore on your phone, and navigate to the “My Apps” tab. 
8. Press the “+” button in the top left corner of the screen.
9. Navigate to the IPA file you dragged into the Files through iTunes, and click on it to install it.

### Mac

1. Download AltServer (for mac macOS 10.14.4+) here: https://altstore.io/
2. After installing AltServer, plug your phone into your Mac. Once your phone is connected, you can click the AltServer on your status bar (diamond shaped icon) -> install AltStore -> choose your device ->enter your iTunes account info (to assign AltSotre). 
3. After install AltStore, the app will show up in your iDevice. You will need to “activate” the app by going to setting->General->Device Management->to allow the app with iTunes account you put in the previous step (3)
4. Now you can run AltStore on your iDevice.
5. Open AltStore on your phone, and navigate to the “My Apps” tab.
6. Press the “+” button in the top left corner of the screen.
7. Navigate to the Cloudy.IPA file you dragged into the Files through iTunes, and click on it to install it.
8. You will need to leave ALTSERVER RUNNING (on your mac) for sideloading any apps or resign them before expiration! 
9. If you are tired of connecting iDevice to Mac every time, you can do this remotely by check “Synch this iphone/ipad over wifi” in iTunes. Then install the mail-plugin on your mac by clicking AltServer icon -> install mail plugin. Make sure that your mac and the iDevice are running under the same wifi network (ethernet won’t work unfortunately) 
10. AltServer signs the apps remotely, and will do it whenever it sees your device on the network, so make sure that it stays running so you can continue to use your apps without issue.