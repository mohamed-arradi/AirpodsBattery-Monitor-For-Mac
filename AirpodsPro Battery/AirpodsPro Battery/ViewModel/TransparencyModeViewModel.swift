//
//  TransparencyModeViewModel.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 02/07/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

protocol DeviceChangeDelegate: AnyObject {
    func deviceChanged(device: NCDevice)
    func updateDeviceMode(mode: NCListeningMode)
}

class TransparencyModeViewModel {
    
    private let transparencyController: NCAVListeningModeController!
    private (set) var currentDevice: NCDevice?
    private let scriptHandler: ScriptsHandler?
    private (set) var refreshDataTimer: Timer?
    weak var deviceChangeDelegate: DeviceChangeDelegate?
    
    init(transparencyController: NCAVListeningModeController = NCAVListeningModeController(),
         delegate: DeviceChangeDelegate? = nil,
         scriptHandler: ScriptsHandler? = ScriptsHandler.default,
         currentDevice: NCDevice? = nil) {
        self.transparencyController = transparencyController
        self.deviceChangeDelegate = delegate
        self.scriptHandler = scriptHandler
        self.currentDevice = currentDevice
        refreshDataTimer?.invalidate()
        refreshDataTimer = Timer.scheduledTimer(timeInterval: 2, target: self, selector: #selector(updateListeningMode), userInfo: nil, repeats: true)
    }
    
    fileprivate var listeningMode: NCListeningMode {
        return currentDevice?.listeningMode ?? .normal
    }
    
    var listeningModeDisplayable: String {
        
        guard !isMontereyOS else {
            return ""
        }
        switch listeningMode {
        case .anc:
            return "anc".localized
        case .transparency:
            return "transparency".localized
        default:
            return "normal".localized
        }
    }
    
    func startListening() {
        
        self.transparencyController.outputDeviceDidChange = { device in
            guard let device = device else {
                return
            }
           DeviceChecker.isAppleDevice(deviceAddress: device.identifier,
                                       scriptHandler: self.scriptHandler, completion: { success in
                if success {
                    self.currentDevice = device
                    self.deviceChangeDelegate?.deviceChanged(device: device)
                    Logger.da("current device: \(self.currentDevice?._listeningMode ?? "")")
                } else {
                    self.currentDevice = nil
                }
            })
        }
        
        transparencyController.startListeningForUpdates()
    }
    
    @objc func updateListeningMode() {
        let mode = NCListeningMode(rawValue: self.transparencyController.listeningMode.rawValue) ?? .normal
        deviceChangeDelegate?.updateDeviceMode(mode: mode)
    }
}
