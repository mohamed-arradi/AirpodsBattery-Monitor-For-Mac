//
//  PreferencesKeys.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

typealias PreferenceString = PreferenceKey

enum Threshold: Int {
    case minBatteryLow = 20
}

enum PreferenceKey {
    
    enum SystemData: String {
        case latestNotificationSendDate
        case startupSystemAllowed
    }
    
    enum DeviceMetaData: String {
        case deviceName
        case deviceType
        case deviceAddress
        case listeningMode
        case latestBatteryLevel
    }
    
    enum BatteryValue: String {
        case left
        case right
        case `case`
        case headset
    }
}
