//
//  BluetoothAirpodsBatteryManagementProtocol.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 17/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation

enum DeviceConnectionState {
    case connected
    case disconnected
}

protocol BluetoothAirpodsBatteryManagementProtocol {
    
    var airpodsInfo: AirpodsInfo? { get set }
    var headsetInfo: HeadsetInfo? { get set }
    var connectionStatus: DeviceConnectionState { get set }
    var deviceName: String { get }
    var deviceAddress: String { get }
    
    func updateBatteryInformation(completion: @escaping BatteryInfoCompletion)
    func processAirpodsBatteryInfo(groups: [String])
    func fetchAirpodsName(completion: @escaping (_ deviceName: String,_ deviceAddress: String) -> Void)
    func toogleCurrentBluetoothDevice()
}
