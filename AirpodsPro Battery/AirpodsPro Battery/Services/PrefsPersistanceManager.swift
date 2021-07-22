//
//  PreferencePersistanceManager.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 12/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

typealias PreferenceString = PreferenceKey

enum Threshold: Int {
    case minBatteryLow = 20
}

enum PreferenceKey {
    
    enum SystemData: String {
        case latestNotificationSendDate
    }
    enum AirpodsMetaData: String {
        case deviceName
        case deviceAddress
        case listeningMode
        case latestBatteryLevel
    }
    
    enum BatteryValue: String {
        case left
        case right
        case `case`
    }
}

struct PrefsPersistanceManager {
    
    func savePreferences(key: String, value: Any?, preferenceManager: UserDefaults = UserDefaults.init(suiteName: "group.mac.airpodsbatterygroup")!) {
        preferenceManager.set(value, forKey: key)
    }
    
    func getValuePreferences(from key: String, preferenceManager: UserDefaults = UserDefaults.init(suiteName: "group.mac.airpodsbatterygroup")!) -> Any? {
        return preferenceManager.value(forKey: key)
    }
}
