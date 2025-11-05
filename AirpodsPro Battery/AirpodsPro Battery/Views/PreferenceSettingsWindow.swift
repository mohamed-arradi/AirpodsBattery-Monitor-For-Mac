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
    @IBOutlet weak var airpodsHardwareMainSerial: NSTextField!
    @IBOutlet weak var airpodsHardwareLeftSerial: NSTextField!
    @IBOutlet weak var airpodsHardwareRightSerial: NSTextField!
    
    var preferenceManager: PrefsPersistanceManager?
    
    convenience init(preferenceManager: PrefsPersistanceManager = PrefsPersistanceManager()) {
        self.init()
        self.preferenceManager = preferenceManager
    }
    
    var mainSerialNumber: String {
        get {
            return  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.DeviceMetaData.mainSerialNumber.rawValue) as? String ?? ""
        }
    }
    
    var leftSerialNumber: String {
        get {
            return  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.DeviceMetaData.leftSerialNumber.rawValue) as? String ?? ""
        }
    }
    
    var rightSerialNumber: String {
        get {
            return  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.DeviceMetaData.rightSerialNumber.rawValue) as? String ?? ""
        }
    }
    
    override var windowNibName: NSNib.Name? {
        return NSNib.Name("PreferenceSettingsWindow")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
       
        let preferenceLogin = LoginServiceKit.isExistLoginItems()
        startupLaunchSettingCheckbox.state = preferenceLogin ? NSControl.StateValue.on : NSControl.StateValue.off
        airpodsHardwareMainSerial.stringValue = "\("serial_number_case".localized): \(mainSerialNumber)"
        airpodsHardwareLeftSerial.stringValue = "\("serial_number_left".localized): \(leftSerialNumber)"
        airpodsHardwareRightSerial.stringValue = "\("serial_number_right".localized): \(rightSerialNumber)"
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
