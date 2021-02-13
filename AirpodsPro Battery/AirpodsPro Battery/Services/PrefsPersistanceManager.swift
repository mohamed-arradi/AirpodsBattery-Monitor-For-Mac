//
//  PreferencePersistanceManager.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 12/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

enum PreferenceKey: String {
    case deviceName
    case deviceAddress
    
    enum BatteryValue: String {
        case left
        case right
        case `case`
    }
}

struct PrefsPersistanceManager {
    
    func savePreferences(key: String, value: Any, preferenceManager: UserDefaults = UserDefaults.init(suiteName: "com.mac.airpodsbatterygroup")!) {
        preferenceManager.set(value, forKey: key)
    }
    
    func getValuePreferences(from key: String, preferenceManager: UserDefaults = UserDefaults.init(suiteName: "com.mac.airpodsbatterygroup")!) -> Any? {
        return preferenceManager.value(forKey: key)
    }
}
