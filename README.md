![AppIcon-AirPodsBattery-Monitor](/images/appIcon.png)
# AirPods Battery Monitor For MAC OS ! [![Swift 5.0](https://img.shields.io/badge/Swift-5.0-orange.svg?style=flat)](https://swift.org/)

Airpods Mac OS App which show you the battery percentage of your airpods and Airpods Pro.

![Image of AirPods Battery Monitor](/images/airpods-connected-min.png)

A small Mac OS App that allow you to see easily your AirPods Battery (Case/ Left / Right) in real-time ! 

It is a shortcut to remove the long and painful access from the Bluetooth Tab that Mac OS X provide.

## HOW TO DOWNLOAD IT ?

**Direct Download Link**

Just download the latest version here: 

[![AirPods Battery Monitor Release](/images/downloadbutton.png)](https://github.com/mohamed-arradi/AirpodsBattery-Monitor-For-Mac/tree/master/releases)

**Via Homebrew**

Work in progress.. It need to be more popular

## Why this App can be useful to you ?

On Mac OS, in order to get the battery information from your AirPods you need to Select your bluetooth device and then navigate to the Battery Mode. Now this time is over ! Just an Eye look to the Top and done !

This is why I build this tiny mac status bar app.

### DEMO 

![Demo-AirpodsBatteryMonitor](images/AirpodsBatteryMonitor-Demo.gif)

### REMAINING TO DO

- Add Notifications for Battery under 10%, etc 
- Add TouchBar App in order to see the battery from the touch bar
- Make it Generic in order to detect battery from Sony WF 1000xm3, etc..
- Support multiple languages

### CHANGELOG (Latest)

**1.0.12**

- Fixed Memory Leaks that was happening time to times and freeze the software.

**1.0.11**

- AirPods Name was not getting properly update
- Add Mac OS 13 compatibility

**1.0.10**

* AirPods names was not updated properly. A notification mechanism has been fired in case of new AirPods addition.

**1.0.9**

* Battery level was not refreshing properly and obliged the user to refresh manually.  This is now fixed

**1.0.8**

* New Feature: Launch when MacOS Starts. 
* Add French language support

### DEPENDANCIES

**LoginServiceKit** -> https://github.com/Clipy/LoginServiceKit. It allows to run when MacOS Start.

### Why it is not on the App Store ?

This is a MacOSX App build with xCode using Swift 5.0 and Sandbox Not activated in order to beneficiate from the bash permission.

This App cannot be allowed right now on the Mac App Store due to the necessary temporary exceptions required. (Except if you manage to bribe some Apple Reviewers which I did not succeeded yet :))

### THEY TALK ABOUT IT

- (German Blog - xgadget.de) https://www.xgadget.de/app-software/freeware-airpods-battery-monitor/
- (Japanese Blog) https://applech2.com/archives/20191227-airpods-battery-monitor-app-for-mac-os.html
- (English Software Online News - Mac Softpedia) https://mac.softpedia.com/get/Utilities/AirPods-Battery-Monitor.shtml
- ( German Article - giga.de) https://www.giga.de/news/airpods-diese-mac-app-ist-die-perfekte-ergaenzung-zu-den-apple-kopfhoerern/
- (German Article - itopnews.de) https://www.itopnews.de/2020/01/airpods-battery-monitor-mac-app-zeigt-airpods-akkustand-bequem-an/
- (English Blog - AppsForMyPC) http://www.appsformypc.com/2020/01/airpods-battery-monitor-for-mac/
- (German Article - WorldUnion.info) https://worldunion.info/diese-mac-app-ist-die-perfekte-ergaenzung-zu-den-apple-kopfhoerern/

### CONTRIBUTING

If you want to contribute to improve it, it will be with pleasure !

### Image Credits

- Airpod Case by Joel Wisneski from the Noun Project

- AirPods case by Mathijs Boogaert from the Noun Project

- https://icon-icons.com/fr/icone/airpods/110461#32

- https://icon-icons.com/fr/icone/airpods-pas-connect%C3%A9/110456#32

### LICENCE

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

### SUPPORT

You like it ? help supporting this app by giving me **Coffee** in order for me to keep coding

[![paypal](https://www.paypalobjects.com/en_US/i/btn/btn_donateCC_LG.gif)](https://www.paypal.com/cgi-bin/webscr?cmd=_s-xclick&hosted_button_id=CK4Y594T6K5LL)
