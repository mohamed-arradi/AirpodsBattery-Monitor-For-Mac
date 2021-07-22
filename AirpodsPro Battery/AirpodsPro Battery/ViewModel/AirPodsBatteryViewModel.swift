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

class AirPodsBatteryViewModel: BluetoothAirpodsBatteryManagementProtocol {
    
    var leftBatteryValue: String = "--"
    var rightBatteryValue: String = "--"
    var caseBatteryValue: String = "--"
    var leftBatteryProgressValue: CGFloat = 0.0
    var rightBatteryProgressValue: CGFloat = 0.0
    var caseBatteryProgressValue: CGFloat = 0.0
    private var displayStatusMessage: String = ""
    private var airpodsNoiseMode: String = ""
    
    var connectionStatus: AirpodsConnectionStatus = .disconnected
    private (set) var scriptHandler: ScriptsHandler?
    private (set) var preferenceManager: PrefsPersistanceManager!
    
    private let transparencyModeViewModel: TransparencyModeViewModel!
    
    var deviceName: String {
        get {
            return preferenceManager.getValuePreferences(from: PreferenceKey.AirpodsMetaData.deviceName.rawValue) as? String ?? ""
        }
    }
    
    var deviceAddress: String {
        get {
            return preferenceManager.getValuePreferences(from: PreferenceKey.AirpodsMetaData.deviceAddress.rawValue) as? String ?? ""
        }
    }
    
    var fullStatusMessage: String {
        if !airpodsNoiseMode.isEmpty
            && !displayStatusMessage.isEmpty {
            return "\(displayStatusMessage) - \(airpodsNoiseMode)"
        } else {
            return displayStatusMessage
        }
    }
    
    init(scriptHandler: ScriptsHandler = ScriptsHandler.default,
         preferenceManager: PrefsPersistanceManager = PrefsPersistanceManager(),
         transparencyModeViewModel: TransparencyModeViewModel = TransparencyModeViewModel()) {
        self.scriptHandler = scriptHandler
        self.preferenceManager = preferenceManager
        self.transparencyModeViewModel = transparencyModeViewModel
        self.transparencyModeViewModel.deviceChangeDelegate = self
        self.transparencyModeViewModel.startListening()
    }
    
    func updateBatteryInformation(completion: @escaping (_ success: Bool, _ status: AirpodsConnectionStatus) -> Void) {
        
        guard let scriptHandler = scriptHandler else {
            completion(false, .disconnected)
            return
        }
        
        let script = scriptHandler.scriptDiskFilePath(scriptName: "battery-airpods.sh")
        let macMappingFile = scriptHandler.scriptDiskFilePath(scriptName: "oui.txt")
        
        scriptHandler.execute(commandName: "sh", arguments: ["\(script)","\(macMappingFile)"]) { [weak self] (result) in
            
            switch result {
            case .success(let value):
                let pattern = "\\d+"
                let groups = value.groups(for: pattern).flatMap({$0})
                DispatchQueue.main.async {
                    self?.processBatteryEntries(groups: groups)
                    self?.processAirpodsDetails()
                }
                
                completion(true, self?.connectionStatus ?? .disconnected)
            case .failure( _):
                if #available(OSX 11, *) {
                    WidgetCenter.shared.reloadTimelines(ofKind: WidgetIdentifiers.batteryMonitor.rawValue)
                }
                completion(false, self?.connectionStatus ?? .disconnected)
            }
        }
    }
    
    fileprivate func updateAirpodsNameAndAddress(name: String, address: String) {
        
        var nameToSave = name
        if !address.isEmpty && address.count > 4 {
            nameToSave = "\n \(name) \r\n -\(address)-"
        }
        preferenceManager.savePreferences(key: PreferenceKey.AirpodsMetaData.deviceName.rawValue, value: nameToSave)
        preferenceManager.savePreferences(key: PreferenceKey.AirpodsMetaData.deviceAddress.rawValue, value: address)
        NotificationCenter.default.post(name: NSNotification.Name("update_device_name"), object: nil)
    }
    
    func processBatteryEntries(groups: [String]) {
        
        self.displayStatusMessage = ""
        
        if groups.count > 0 {
            self.connectionStatus = .connected
            
            var left: CGFloat? = nil
            var right: CGFloat? = nil
            var caseBattery: CGFloat? = nil
            
            if let caseValue = Int(groups[0]) {
                let value = caseValue > 0 ? "\(caseValue) %": "nc"
                caseBatteryValue = value
                caseBattery = CGFloat(caseValue)
                caseBatteryProgressValue = CGFloat(caseValue)
            }
            
            if let leftValue = Int(groups[1]) {
                let value = leftValue > 0 ? "\(leftValue) %": "--"
                self.leftBatteryValue = value
                self.leftBatteryProgressValue = CGFloat(leftValue)
                self.displayStatusMessage.append("\("left".localized): \(value) / ")
                left = CGFloat(leftValue)
            }
            
            if let rightValue = Int(groups[2]) {
                let value = rightValue > 0 ? "\(rightValue) %": "--"
                self.rightBatteryValue = value
                self.rightBatteryProgressValue = CGFloat(rightValue)
                self.displayStatusMessage.append("\("right".localized): \(value)")
                right = CGFloat(rightValue)
            }
            
            if let listeningMode = preferenceManager.getValuePreferences(from: PreferenceKey.AirpodsMetaData.listeningMode.rawValue) as? String {
                self.airpodsNoiseMode = listeningMode
            }
            
            saveBatteryLevelUserDefaults(left: left, right: right, caseBatt: caseBattery)
            
        } else {
            self.connectionStatus = .disconnected
            self.leftBatteryValue = "--"
            self.leftBatteryProgressValue = CGFloat(0)
            self.rightBatteryValue = "--"
            self.rightBatteryProgressValue = CGFloat(0)
            self.caseBatteryValue = "--"
            self.caseBatteryProgressValue = CGFloat(0)
            self.displayStatusMessage = ""
            saveBatteryLevelUserDefaults(left: nil, right: nil, caseBatt: nil)
        }
    }
    
    func saveBatteryLevelUserDefaults(left: CGFloat? = nil, right: CGFloat? = nil, caseBatt: CGFloat? = nil) {
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.left.rawValue, value: left ?? -1)
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.right.rawValue, value: right ?? -1)
        preferenceManager.savePreferences(key: PreferenceKey.BatteryValue.case.rawValue, value: caseBatt ?? -1)
        
        let lowerBatteryValue = min(left ?? -1, right ?? -1)

       // prepareNotificationIfNeeded(batteryValue: Int(lowerBatteryValue))
        
        if #available(OSX 11, *) {
            WidgetCenter.shared.reloadTimelines(ofKind: WidgetIdentifiers.batteryMonitor.rawValue)
        }
    }
    
    fileprivate func prepareNotificationIfNeeded(batteryValue: Int) {
        
        if batteryValue != -1 {
            preferenceManager.savePreferences(key: PreferenceKey.AirpodsMetaData.latestBatteryLevel.rawValue,
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
    
    
    fileprivate func processAirpodsDetails() {
        self.fetchAirpodsName { (deviceName, deviceAddress) in
            DeviceChecker.isAppleDevice(deviceAddress: deviceAddress, scriptHandler: self.scriptHandler) { [weak self] (success) in
                guard !deviceName.isEmpty,
                      !deviceAddress.isEmpty,
                      success else {
                    self?.updateAirpodsNameAndAddress(name: "", address: "")
                    return
                }
                let transparencyType: String = self?.transparencyModeViewModel.listeningModeDisplayable ?? ""
                self?.preferenceManager.savePreferences(key: PreferenceKey.AirpodsMetaData.listeningMode.rawValue,
                                                        value: transparencyType)
                self?.updateAirpodsNameAndAddress(name: deviceName, address: deviceAddress)
            }
        }
    }
    
    func updateAirpodsMode() {
        airpodsNoiseMode = transparencyModeViewModel.listeningModeDisplayable
    }
    
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
        preferenceManager.savePreferences(key: PreferenceKey.AirpodsMetaData.listeningMode.rawValue, value: mode.rawValue)
        updateBatteryInformation { _, _ in }
    }
    
    func deviceChanged(device: NCDevice) {
        DeviceChecker.isAppleDevice(deviceAddress: device.identifier, scriptHandler: scriptHandler) { [weak self] success in
            if success {
                self?.updateDeviceMode(mode: device.listeningMode)
            }
        }
        
    }
}

