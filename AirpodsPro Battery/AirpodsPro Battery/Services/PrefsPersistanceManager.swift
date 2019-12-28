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
}
struct PrefsPersistanceManager {
    
    func savePreferences(key: PreferenceKey, value: Any, preferenceManager: UserDefaults = UserDefaults.standard) {
        preferenceManager.set(value, forKey: key.rawValue)
    }
    
    func getValuePreferences(from key: PreferenceKey, preferenceManager: UserDefaults = UserDefaults.standard) -> Any? {
        return preferenceManager.value(forKey: key.rawValue)
    }
}
