//
//  BatteryViewModel.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 13/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation
import IOBluetooth
import WidgetKit

enum WidgetIdentifiers: String {
    case batteryMonitor = "com.mac.AirpodsPro-Battery.batteryWidget"
}

typealias BatteryInfoCompletion = (_ success: Bool, _ status: DeviceConnectionState, _ deviceType: DeviceType) -> Void

class AirPodsBatteryViewModel: BluetoothAirpodsBatteryManagementProtocol {
    
    var airpodsInfo: AirpodsInfo?
    var headsetInfo: HeadsetInfo?
    private var displayStatusMessage: String = ""
    private var listeningNoiseMode: String = ""
    
    var connectionStatus: DeviceConnectionState = .disconnected
    private (set) var scriptHandler: ScriptsHandler?
    private (set) var preferenceManager: PrefsPersistanceManager!
    
    private let transparencyModeViewModel: TransparencyModeViewModel!
    
    var deviceName: String {
        get {
            return preferenceManager.getValuePreferences(from: PreferenceKey.DeviceMetaData.deviceName.rawValue) as? String ?? ""
        }
    }
    
    
    var shortDeviceName: String {
        get {
            return preferenceManager.getValuePreferences(from: PreferenceKey.DeviceMetaData.shortName.rawValue) as? String ?? ""
        }
    }
    
    var deviceAddress: String {
        get {
            return preferenceManager.getValuePreferences(from: PreferenceKey.DeviceMetaData.deviceAddress.rawValue) as? String ?? ""
        }
    }
    
    var latestDeviceType: DeviceType {
        
        guard let deviceType = preferenceManager.getValuePreferences(from: PreferenceKey.DeviceMetaData.deviceType.rawValue) as? Int else {
            return .airpods
        }
        
        return DeviceType(rawValue: deviceType) ?? .airpods
    }
    
    var fullStatusMessage: String {
        if !listeningNoiseMode.isEmpty
            && !displayStatusMessage.isEmpty {  
            return "\(displayStatusMessage) - \(listeningNoiseMode)"
        } else {
            return displayStatusMessage
        }
    }
    
    // MARK: - Init
    
    init(scriptHandler: ScriptsHandler = ScriptsHandler.default,
         preferenceManager: PrefsPersistanceManager = PrefsPersistanceManager(),
         transparencyModeViewModel: TransparencyModeViewModel = TransparencyModeViewModel()) {
        self.scriptHandler = scriptHandler
        self.preferenceManager = preferenceManager
        self.transparencyModeViewModel = transparencyModeViewModel
        self.transparencyModeViewModel.deviceChangeDelegate = self
        self.transparencyModeViewModel.startListening()
    }
    
    // MARK: - Update Functions
    
    func updateBatteryInformation(completion: @escaping BatteryInfoCompletion) {
        
        guard let scriptHandler = scriptHandler else {
            connectionStatus = .disconnected
            completion(false, .disconnected, .unknown)
            return
        }
        
        let script = scriptHandler.scriptDiskFilePath(scriptName: "battery-airpods.sh")
        let macMappingFile = scriptHandler.scriptDiskFilePath(scriptName: "oui.txt")
        
        scriptHandler.execute(commandName: "sh", arguments: ["\(script)","\(macMappingFile)"]) { [weak self] (result) in
            
            var deviceType: DeviceType = .unknown
            
            switch result {
            case .success(let value):
                let valueGroupedBySpaces = value.split(separator: "\n")
                guard valueGroupedBySpaces.count > 0,
                      let topMostDeviceData = valueGroupedBySpaces.first else {
                    return
                }
                let pattern = "\\d+"
                let datas = String(topMostDeviceData).components(separatedBy: "@@")
                
                guard datas.count > 1,
                      let dataDevice = datas.last else {
                    return
                }
                
                let groups = dataDevice.groups(for: pattern).flatMap({$0})
                if groups.count > 1 {
                    deviceType = .airpods
                    DispatchQueue.main.async {
                        self?.processAirpodsBatteryInfo(groups:groups)
                        self?.processDeviceDetails()
                    }
                } else if groups.count == 1 {
                    deviceType = .headset
                    DispatchQueue.main.async {
                        self?.processHeadSetBatteryInfo(info: groups.first ?? "")
                        self?.processDeviceDetails()
                    }
                } else {
                    self?.resetAllDevicesBatteryState()
                }
               
                completion(true, .connected, deviceType)
            case .failure( _):
                if #available(OSX 11, *) {
                    WidgetCenter.shared.reloadAllTimelines()
                }
                completion(false, self?.connectionStatus ?? .disconnected, .unknown)
            }
        }
    }
    
    fileprivate func resetAllDevicesBatteryState() {
        connectionStatus = .disconnected
        airpodsInfo = AirpodsInfo(-1, -1, -1, .disconnected)
        headsetInfo = HeadsetInfo(batteryValue: -1, deviceState: .disconnected)
        displayStatusMessage = ""
        storeAirpodsBatteryLevelInCache(left: nil, right: nil, caseBatt: nil, deviceState: .disconnected)
        storeHeadSetBatteryLevelInCache(batteryLevel: -1)
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    fileprivate func updateStoredDeviceInfos(name: String, address: String) {
        
        var nameToSave = name
        if !address.isEmpty && address.count > 4 {
            nameToSave = "\(name) \r\n - \(address)"
        }
        preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.shortName.rawValue, value: name)
        preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.deviceName.rawValue, value: nameToSave)
        preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.deviceAddress.rawValue, value: address)
        NotificationCenter.default.post(name: NSNotification.Name("update_device_name"), object: nil)
    }
    
    func processHeadSetBatteryInfo(info: String) {
        
        guard !info.isEmpty,
              let battValue = Int(info) else {
            displayStatusMessage = ""
            return
        }
        airpodsInfo = nil
        connectionStatus = .connected
        let batteryValue = CGFloat(battValue)
        headsetInfo = HeadsetInfo(batteryValue: batteryValue, deviceState: .connected)
        displayStatusMessage = "\("headset_battery".localized): \(battValue) %"
        storeHeadSetBatteryLevelInCache(batteryLevel: batteryValue)
        
        if let listeningMode = preferenceManager.getValuePreferences(from: PreferenceKey.DeviceMetaData.listeningMode.rawValue) as? String {
            self.listeningNoiseMode = listeningMode
        }
        preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.deviceType.rawValue, value: DeviceType.headset.rawValue)
    }
    
    func processAirpodsBatteryInfo(groups: [String]) {
        
        displayStatusMessage = ""
        
        preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.deviceType.rawValue, value: DeviceType.airpods.rawValue)
        
        if groups.count > 0 {
            self.connectionStatus = .connected
            var left: CGFloat? = nil
            var right: CGFloat? = nil
            var caseBattery: CGFloat? = nil
            
            if let caseValue = Int(groups[0]) {
                caseBattery = CGFloat(caseValue)
            }
            
            if let leftValue = Int(groups[1]) {
                let value = leftValue > 0 ? "\(leftValue) %": "--"
                self.displayStatusMessage.append("\("left".localized): \(value) / ")
                left = CGFloat(leftValue)
            }
            
            if let rightValue = Int(groups[2]) {
                let value = rightValue > 0 ? "\(rightValue) %": "--"
                self.displayStatusMessage.append("\("right".localized): \(value)")
                right = CGFloat(rightValue)
            }
            
            if let listeningMode = preferenceManager.getValuePreferences(from: PreferenceKey.DeviceMetaData.listeningMode.rawValue) as? String {
                self.listeningNoiseMode = listeningMode
            }
            
            airpodsInfo = AirpodsInfo(left ?? -1, right ?? -1, caseBattery ?? -1, .connected)
            headsetInfo = nil
            storeAirpodsBatteryLevelInCache(left: left, right: right, caseBatt: caseBattery, deviceState: .connected)
        } else {
            self.connectionStatus = .disconnected
            self.displayStatusMessage = ""
            storeAirpodsBatteryLevelInCache(left: nil, right: nil, caseBatt: nil, deviceState: .disconnected)
        }
    }
    
    fileprivate func storeAirpodsBatteryLevelInCache(left: CGFloat? = nil, right: CGFloat? = nil, caseBatt: CGFloat? = nil, deviceState: DeviceConnectionState) {
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.left.rawValue, value: left ?? -1)
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.right.rawValue, value: right ?? -1)
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.case.rawValue, value: caseBatt ?? -1)
        
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
        //let lowerBatteryValue = min(left ?? -1, right ?? -1)
        
        // prepareNotificationIfNeeded(batteryValue: Int(lowerBatteryValue))
    }
    
    fileprivate func storeHeadSetBatteryLevelInCache(batteryLevel: CGFloat? = nil) {
        
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.headset.rawValue, value: batteryLevel ?? -1)
        
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    // MARK: - Notifications
    fileprivate func prepareNotificationIfNeeded(batteryValue: Int) {
        
        if batteryValue != -1 {
            preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.latestBatteryLevel.rawValue,
                                              value: batteryValue)
            prepareNotificationIfNeeded(batteryValue: Int(batteryValue))
        }
        
        let latestNotificationSendDate = preferenceManager.getValuePreferences(from: PreferenceKey.SystemData.latestNotificationSendDate.rawValue)
        
        guard latestNotificationSendDate == nil,
              batteryValue <= Threshold.minBatteryLow.rawValue else {
            resetNotificationState(batteryValue: batteryValue)
            return
        }
        
        let notificationMessage = AppleScriptType.batteryNotification.replacingOccurrences(of: "%@", with: "\(batteryValue)")
        AppleScriptExecutor().executeAction(script: notificationMessage)
        preferenceManager.savePreferences(key: PreferenceKey.SystemData.latestNotificationSendDate.rawValue,
                                          value: DateUtil().toDefaultStringFormat(date: Date()))
    }
    
    
    fileprivate func resetNotificationState(batteryValue: Int) {
        
        if batteryValue > Threshold.minBatteryLow.rawValue {
            preferenceManager.savePreferences(key: PreferenceKey.SystemData.latestNotificationSendDate.rawValue,
                                              value: nil)
        }
    }
    
    fileprivate func processDeviceDetails() {
        self.fetchAirpodsName { (deviceName, deviceAddress) in
            guard !deviceName.isEmpty, !deviceAddress.isEmpty else { return }
            
            DeviceChecker.isAppleDevice(deviceAddress: deviceAddress, scriptHandler: self.scriptHandler) { [weak self] (success) in
                guard !deviceName.isEmpty,
                      !deviceAddress.isEmpty,
                      success else {
                    self?.updateStoredDeviceInfos(name: "", address: "")
                    return
                }
                let transparencyType: String =  self?.transparencyModeViewModel.listeningModeDisplayable ?? ""
                self?.preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.listeningMode.rawValue,
                                                        value: transparencyType)
                self?.updateStoredDeviceInfos(name: deviceName, address: deviceAddress)
            }
        }
    }
    
    func updateAirpodsMode() {
        listeningNoiseMode = transparencyModeViewModel.listeningModeDisplayable
    }
    
    // MARK: - BLE
    func fetchAirpodsName(completion: @escaping (_ deviceName: String, _ deviceAddress: String) -> Void) {
        
        guard let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            completion("", "")
            return
        }
        
        if let device = findLatestDevices(connected: true, devices: devices) {
            completion(device.nameOrAddress, device.addressString)
        } else if let device = findLatestDevices(connected: false, devices: devices) {
            completion(device.nameOrAddress, device.addressString)
        } else {
            completion("", "")
        }
    }
    
    fileprivate func findLatestDevices(connected: Bool, devices: [IOBluetoothDevice]) -> IOBluetoothDevice? {
        
        guard let device = devices.first(where: { $0.isConnected() == connected
                                            && $0.deviceClassMajor == kBluetoothDeviceClassMajorAudio
                                            && $0.deviceClassMinor == kBluetoothDeviceClassMinorAudioHeadphones }) else {
            return nil
        }
        return device
    }
    
    func toogleCurrentBluetoothDevice() {
        
        guard !deviceAddress.isEmpty, let bluetoothDevice = IOBluetoothDevice(addressString: deviceAddress) else {
            Logger.da("Device not found")
            return
        }
        
        if !bluetoothDevice.isPaired() {
            Logger.da("Device not paired")
            return
        }
        
        if bluetoothDevice.isConnected() {
            bluetoothDevice.closeConnection()
        } else {
            bluetoothDevice.openConnection()
        }
    }
}

extension AirPodsBatteryViewModel: DeviceChangeDelegate {
    func updateDeviceMode(mode: NCListeningMode) {
        preferenceManager.savePreferences(key: PreferenceKey.DeviceMetaData.listeningMode.rawValue, value: mode.rawValue)
        updateBatteryInformation { _, _,_  in }
    }
    
    func deviceChanged(device: NCDevice) {
        DeviceChecker.isAppleDevice(deviceAddress: device.identifier, scriptHandler: scriptHandler) { [weak self] success in
            if success {
                self?.updateDeviceMode(mode: device.listeningMode)
            }
        }
        
    }
}

