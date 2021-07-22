//
//  PreferenceSettings.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/07/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa
import LoginServiceKit

class PreferenceSettingsWindow: NSWindowController {
    
    @IBOutlet weak var startupLaunchSettingCheckbox: NSButton!
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("PreferenceSettingsWindow")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let preferenceLogin = LoginServiceKit.isExistLoginItems()
        startupLaunchSettingCheckbox.state = preferenceLogin ? NSControl.StateValue.on : NSControl.StateValue.off
    }
    
    
    @IBAction func toogleStartupLaunchSettings(sender: NSButton) {
        
        let toogleValue = sender.state == .on ? true : false
        
        PrefsPersistanceManager().savePreferences(key: PreferenceKey.SystemData.startupSystemAllowed.rawValue, value: toogleValue)
        
        let isExistLoginItem = LoginServiceKit.isExistLoginItems()
        
        if isExistLoginItem && !toogleValue {
            LoginServiceKit.removeLoginItems()
        } else {
            if !isExistLoginItem {
                LoginServiceKit.addLoginItems()
            }
        }
    }
}
