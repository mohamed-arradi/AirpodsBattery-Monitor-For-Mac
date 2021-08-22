//
//  AirpodsInfo.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

struct AirpodsInfo {
    
    var leftDisplayBatteryValue: String {
        return leftBatteryValue > 0.0 ? "\(Int(leftBatteryValue)) %" : "--"
    }
    
    var rightDisplayBatteryValue: String {
        return rightBatteryValue > 0.0 ? "\(Int(rightBatteryValue)) %" : "--"
    }
    
    var caseDisplayBatteryValue: String {
        return caseBatteryValue > 0.0 ? "\(Int(caseBatteryValue)) %" : "--"
    }
    
    let leftBatteryValue: CGFloat
    let rightBatteryValue: CGFloat
    let caseBatteryValue: CGFloat
    let deviceState: DeviceConnectionState
    
    init(_ left: CGFloat,_ right: CGFloat,_ caseV: CGFloat, _ deviceState: DeviceConnectionState = .connected) {
        self.leftBatteryValue = left
        self.rightBatteryValue = right
        self.caseBatteryValue = caseV
        self.deviceState = deviceState
    }
}
