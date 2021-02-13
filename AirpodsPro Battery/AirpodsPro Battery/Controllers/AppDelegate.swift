//
//  AppDelegate.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Cocoa
import UserNotifications
import LoginServiceKit

@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {

    func applicationDidFinishLaunching(_ aNotification: Notification) {
      
        if #available(OSX 10.12.1, *) {
           NSApplication.shared.isAutomaticCustomizeTouchBarMenuItemEnabled = true
         }
                
//        if LoginServiceKit.isExistLoginItems(at: Bundle.main.bundlePath) == false {
//            LoginServiceKit.addLoginItems(at: Bundle.main.bundlePath)
//        }
    }
}


