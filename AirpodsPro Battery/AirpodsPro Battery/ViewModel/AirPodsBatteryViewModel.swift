//
//  BatteryViewModel.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 13/12/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation
import IOBluetooth

class AirPodsBatteryViewModel: BluetoothAirpodsBatteryManagementProtocol {
    
    var leftBatteryValue: String = "--"
    var rightBatteryValue: String = "--"
    var caseBatteryValue: String = "--"
    var leftBatteryProgressValue: CGFloat = 0.0
    var rightBatteryProgressValue: CGFloat = 0.0
    var caseBatteryProgressValue: CGFloat = 0.0
    var displayStatusMessage: String = ""
    
    var deviceName: String {
        get {
            return preferenceManager.getValuePreferences(from: .deviceName) as? String ?? ""
        }
    }
    
    var deviceAddress: String {
        get {
            return preferenceManager.getValuePreferences(from: .deviceAddress) as? String ?? ""
        }
    }
    
    var connectionStatus: AirpodsConnectionStatus = .disconnected
    private (set) var scriptHandler: ScriptsHandler!
    private (set) var preferenceManager: PrefsPersistanceManager!
    
    init(scriptHandler: ScriptsHandler,
         preferenceManager: PrefsPersistanceManager = PrefsPersistanceManager()) {
        self.scriptHandler = scriptHandler
        self.preferenceManager = preferenceManager
    }
    
    func updateBatteryInformation(completion: @escaping (_ success: Bool, _ status: AirpodsConnectionStatus) -> Void) {
        
        let script = scriptHandler.scriptDiskFilePath(scriptName: "battery-airpods.sh")
        let macMappingFile = scriptHandler.scriptDiskFilePath(scriptName: "mapmac.txt")
        
        scriptHandler.execute(commandName: "sh", arguments: ["\(script)","\(macMappingFile)"]) { (result) in
            
            switch result {
            case .success(let value):
                let pattern = "\\d+"
                let groups = value.groups(for: pattern).flatMap({$0})
                self.processBatteryEntries(groups: groups)
                self.processAirpodsDetails()
                completion(true, self.connectionStatus)
            case .failure(let error):
                print(error)
                completion(false, self.connectionStatus)
            }
        }
    }
    
    fileprivate func updateAirpodsNameAndAddress(name: String, address: String) {
        preferenceManager.savePreferences(key: .deviceName, value: deviceName)
        preferenceManager.savePreferences(key: .deviceAddress, value: deviceAddress)
        NotificationCenter.default.post(name: NSNotification.Name("update_device_name"), object: nil)
    }
    
    func processBatteryEntries(groups: [String]) {
        
        self.displayStatusMessage = ""
        
        if groups.count > 0 {
            self.connectionStatus = .connected
            
            if let caseValue = Int(groups[0]) {
                let value = caseValue > 0 ? "\(caseValue) %": "nc"
                self.caseBatteryValue = value
                self.caseBatteryProgressValue = CGFloat(caseValue)
            }
            
            if let leftValue = Int(groups[1]) {
                self.leftBatteryValue = "\(leftValue) %"
                self.leftBatteryProgressValue = CGFloat(leftValue)
                self.displayStatusMessage.append("L: \(leftValue)% - ")
            }
            
            if let rightValue = Int(groups[2]) {
                self.rightBatteryValue = "\(rightValue) %"
                self.rightBatteryProgressValue = CGFloat(rightValue)
                self.displayStatusMessage.append("R: \(rightValue)%")
            }
        } else {
            self.connectionStatus = .disconnected
            self.leftBatteryValue = "--"
            self.leftBatteryProgressValue = CGFloat(0)
            self.rightBatteryValue = "--"
            self.rightBatteryProgressValue = CGFloat(0)
            self.caseBatteryValue = "NC"
            self.caseBatteryProgressValue = CGFloat(0)
            self.displayStatusMessage = ""
        }
    }
    
    func processAirpodsDetails() {
        self.fetchAirpodsName { (deviceName, deviceAddress) in
            self.isAppleDevice(deviceAddress: deviceAddress) { (success) in
                
                guard !deviceName.isEmpty, !deviceAddress.isEmpty else {
                    return
                }
                self.updateAirpodsNameAndAddress(name: deviceName, address: deviceAddress)
            }
        }
    }
    
    func fetchAirpodsName(completion: @escaping (_ deviceName: String, _ deviceAddress: String) -> Void) {
        
        guard let devices = IOBluetoothDevice.pairedDevices() as? [IOBluetoothDevice] else {
            completion("", "")
            return
        }
        
        guard let device = devices.first(where: { $0.isConnected()
            && $0.deviceClassMajor == kBluetoothDeviceClassMajorAudio
            && $0.deviceClassMinor == kBluetoothDeviceClassMinorAudioHeadphones }) else {
                completion("", "")
                return
        }
        
        completion(device.name, device.addressString)
    }
    
    func isAppleDevice(deviceAddress: String, completion: @escaping (Bool) -> Void) {
        
        let script = scriptHandler.scriptDiskFilePath(scriptName: "apple-devices-verification.sh")
        let macMappingFile = scriptHandler.scriptDiskFilePath(scriptName: "mapmac.txt")
        
        scriptHandler.execute(commandName: "sh", arguments: ["\(script)", "\(deviceAddress)","\(macMappingFile)"]) { (result) in
            
            completion(true)
        }
    }
    
    func toogleCurrentBluetoothDevice() {
        
        guard !deviceAddress.isEmpty, let bluetoothDevice = IOBluetoothDevice(addressString: deviceAddress) else {
            print("Device not found")
            return
        }
        
        if !bluetoothDevice.isPaired() {
            print("Device not paired")
            return
        }
        
        if bluetoothDevice.isConnected() {
            bluetoothDevice.closeConnection()
        } else {
            bluetoothDevice.openConnection()
        }
    }
}

