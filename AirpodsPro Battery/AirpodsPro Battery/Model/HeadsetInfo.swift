//
//  HeadsetInfo.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

struct HeadsetInfo {
    
    let batteryValue: CGFloat
    let deviceState: DeviceConnectionState
    
    var displayBatteryValue: String {
        return batteryValue > 0.0 ? "\(Int(batteryValue)) %" : "NC"
    }
}
