//
//  BluetoothAirpodsBatteryManagementProtocol.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 17/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

enum AirpodsConnectionStatus {
    case connected
    case disconnected
}

struct AirpodsInfo {
    
    var leftDisplayBatteryValue: String {
        return leftBatteryValue > 0.0 ? "\(Int(leftBatteryValue)) %" : "--"
    }
    
    var rightDisplayBatteryValue: String {
        return rightBatteryValue > 0.0 ? "\(Int(rightBatteryValue)) %" : "--"
    }
    
    var caseDisplayBatteryValue: String {
        return caseBatteryValue > 0.0 ? "\(Int(caseBatteryValue)) %" : "NC"
    }
    
    let leftBatteryValue: CGFloat
    let rightBatteryValue: CGFloat
    let caseBatteryValue: CGFloat
    
    init(_ left: CGFloat,_ right: CGFloat,_ caseV: CGFloat) {
        self.leftBatteryValue = left
        self.rightBatteryValue = right
        self.caseBatteryValue = caseV
    }
}

struct HeadsetInfo {
    
    let batteryValue: CGFloat
    
    var displayBatteryValue: String {
        return batteryValue > 0.0 ? "\(Int(batteryValue)) %" : "NC"
    }
}

protocol BluetoothAirpodsBatteryManagementProtocol {
    
    
    var airpodsInfo: AirpodsInfo? { get set }
    var headsetInfo: HeadsetInfo? { get set }
    var connectionStatus: AirpodsConnectionStatus { get set }
    var deviceName: String { get }
    var deviceAddress: String { get }
    
    func updateBatteryInformation(completion: @escaping (_ success: Bool, _ connectionStatus: AirpodsConnectionStatus) -> Void)
    func processAirpodsBatteryInfo(groups: [String])
    func fetchAirpodsName(completion: @escaping (_ deviceName: String,_ deviceAddress: String) -> Void)
    func toogleCurrentBluetoothDevice()
}
