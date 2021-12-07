
# AirPods Battery Monitor For MAC OS ! [![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)

Airpods Mac OS App which show you the battery percentage of your airpods and Airpods Pro from the status bar or the associated widget

### IMPORTANT INFORMATION ###

# Monterey Support has been added ONLY for Airpods Pro All Gens and Airpods Classic #
## Monterey support per default all 3rd Party Bluetooth headsets. Battery informations are not available with how the software is currently built on. ##
**Transparency Mode has been unfortunately disactivated for Monterey users util this feature can be fixed**

### Status Bar on Mac OS (OSX 11+) ###

A small Mac OS App that allow you to see easily your AirPods Battery (Case/ Left / Right) in real-time !. It is a shortcut to remove the long and painful access from the Bluetooth Tab that Mac OS X provide.

![Image of AirPods Battery Monitor](/images/airpods-connected-min.jpg)

### Widgets (Airpods / Airpods Pro / Airpods Max) ###

This App also support widgets ! 

![Image of AirPods Widget](/images/Airpods-Max-Pro-Widget.png)

## HOW TO DOWNLOAD IT ?

### Download Link ###

Just download the latest version here: https://github.com/mohamed-arradi/AirpodsBattery-Monitor-For-Mac/releases

### Instal Via Homebrew ###

WIP

## Why this App can be useful to you ? ##

On Mac OS, in order to get the battery information from your AirPods you need to Select your bluetooth device and then navigate to the Battery Mode. Now this time is over ! Just an Eye look to the Top and done !
This is why I build this tiny mac status bar app.

## Want to Help Adding your LG, Samsung, Huawei Ear Pods ? Please follow that Guide below ##

Guide Link: [Issue 27](https://github.com/mohamed-arradi/AirpodsBattery-Monitor-For-Mac/issues/27)

## Change Log  ##

**V2.2.1**

- Add Mac OS Monterey Support for Airpods Pro / Airpods Classic. (Airpods Max not officially compatible yet)

**V2.1.0**

- Add Airpods Max compatibility.
- Stability Improvements.
- Handle multiple devices connected at the same time (Taking the very top first one connected thought to display battery).
- Update Widget for Airpods Max
- M1 Support

### Not on the Mac App Store ? Why ? ###

- Sandbox is not activated in order to beneficiate from the scripting tool permissions. This software is using AppleScript and Bash Script. Those scripts can be found in the Resources folder : https://github.com/mohamed-arradi/AirpodsBattery-Monitor-For-Mac/tree/master/AirpodsPro%20Battery/AirpodsPro%20Battery/Resources.

Therefore this App cannot be allowed on the Mac App Store due to the necessary temporary exceptions required to make this working.

### THEY TALK ABOUT IT ###
-  Ifun.de https://www.ifun.de/airpods-battery-monitor-akkuanzeige-fuer-die-mac-menueleiste-173617/
- (Japanese Youtube Video Demo) https://www.youtube.com/watch?v=F8lBL62iYD4 
- (German Blog - xgadget.de) https://www.xgadget.de/app-software/freeware-airpods-battery-monitor/
- (German Online Article - Mobiflip.de) https://www.mobiflip.de/shortnews/airpods-battery-monitor-fuer-macos/
- (Japanese Blog) https://applech2.com/archives/20191227-airpods-battery-monitor-app-for-mac-os.html
- (English Software Online News - Mac Softpedia) https://mac.softpedia.com/get/Utilities/AirPods-Battery-Monitor.shtml
- ( German Article - giga.de) https://www.giga.de/news/airpods-diese-mac-app-ist-die-perfekte-ergaenzung-zu-den-apple-kopfhoerern/
- (German Article - itopnews.de) https://www.itopnews.de/2020/01/airpods-battery-monitor-mac-app-zeigt-airpods-akkustand-bequem-an/
- (English Blog - AppsForMyPC) http://www.appsformypc.com/2020/01/airpods-battery-monitor-for-mac/
- (German Article - WorldUnion.info) https://worldunion.info/diese-mac-app-ist-die-perfekte-ergaenzung-zu-den-apple-kopfhoerern/
-  (PC6.com) http://www.pc6.com/mac/734552.html
-  MacZ.com https://www.macz.com/mac/4255.html

### CONTRIBUTING ###

- To contribute, nothing has been easier ! Fork it and make a PR !

### REMAINING TO DO ###

- Activate Desktop Notification when battery is low. (it is developed but not yet activated, require some testing effort)
- Add TouchBar App in order to see the battery from the touch bar
- Make it Generic in order to detect battery from Sony WF 1000xm3, etc..
- Support more languages.

### DEPENDANCIES ###

- **TransparencyCore** -> https://github.com/insidegui/NoiseBuddy (developed by Guilherme Rambo).
- **LoginServiceKit** -> https://github.com/Clipy/LoginServiceKit.

### Thanks ###

- Special thanks to patrickbdev (https://github.com/patrickbdev) for lending me his Airpods Max, without who the V2.1.0 would never have been out ! 

### Image Credits - Attribution ###

- Airpods Case Widget made from <a href="https://icon54.com/" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a>
- Airpods widget icon made from FreePik https://www.freepik.com
- Airpod Case by Joel Wisneski from the Noun Project
- AirPods case by Mathijs Boogaert from the Noun Project
- Connected Airpods Icon made by Vincent Le Moign. Link -> https://icon-icons.com/fr/icone/airpods/110461#32
- Not connected Airpods Icon made by Vincent Le Moign. Link ->  https://icon-icons.com/fr/icone/airpods-pas-connect%C3%A9/110456#32
- HeadSet icon made by <div><a href="https://www.flaticon.com/authors/monkik" title="monkik">monkik</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>. Link -> https://www.flaticon.com/free-icon/music_2503535?term=headset&related_id=2503535
- Airpods Case Made by <div><a href="https://icon54.com/" title="Pixel perfect">Pixel perfect</a> from <a href="https://www.flaticon.com/" title="Flaticon">www.flaticon.com</a></div>

### LICENCE ###

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

### DONATE ###

You like it ? help supporting this app by giving me **Coffee** in order for me to keep coding

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CK4Y594T6K5LL)

### LEGAL ###

**AirPods, Touch Bar and Beats Solo Pro are trademarks of Apple Inc., registered in the U.S. and other countries. This app is not made by, affiliated with or endorsed by Apple.**

[![MacStadium](/images/macstadium.png)](https://www.macstadium.com/opensource-members)
