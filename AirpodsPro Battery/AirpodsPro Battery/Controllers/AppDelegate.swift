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
            
        let isExistLoginItem = LoginServiceKit.isExistLoginItems()
        let preferenceLogin: Bool? = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.SystemData.startupSystemAllowed.rawValue) as? Bool
        
        if !isExistLoginItem && preferenceLogin == nil {
            LoginServiceKit.addLoginItems()
            PrefsPersistanceManager().savePreferences(key: PreferenceKey.SystemData.startupSystemAllowed.rawValue, value: true)
        } else if !isExistLoginItem,
                  let pref = preferenceLogin,
                  pref {
            LoginServiceKit.addLoginItems()
        }
    }
}


