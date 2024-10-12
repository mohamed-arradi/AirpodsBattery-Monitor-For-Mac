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
import WidgetKit

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
        
        NSAppleEventManager
                .shared()
                .setEventHandler(
                    self,
                    andSelector: #selector(handleURL(event:reply:)),
                    forEventClass: AEEventClass(kInternetEventClass),
                    andEventID: AEEventID(kAEGetURL)
                )
        
      //  ScriptsHandler.default.askPermissionsForUser()
    }
    
    @objc func handleURL(event: NSAppleEventDescriptor, reply: NSAppleEventDescriptor) {
        if let path = event.paramDescriptor(forKeyword: keyDirectObject)?.stringValue?.removingPercentEncoding {

            if path.contains("//connect") || path.contains("//disconnect") {
                let airpodsViewModel = AirPodsBatteryViewModel()
                
                let leftP =  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.left.rawValue) as? CGFloat
                let rightP = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.right.rawValue) as? CGFloat
                
                var isConnected = false
                
                if let left = leftP,
                      let right = rightP, left > 0.0 && right > 0.0 {
                    isConnected = true
                }
                if isConnected && path.contains("//connect") {
                    return
                }
                
                if !isConnected && path.contains("//disconnect") {
                    return
                }
                
                AirPodsBatteryViewModel().toogleCurrentBluetoothDevice()
                WidgetCenter.shared.reloadAllTimelines()
            }
        }
    }
}


