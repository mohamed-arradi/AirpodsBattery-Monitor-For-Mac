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
}

class TransparencyModeViewModel {
    
    private let transparencyController: NCAVListeningModeController!
    private (set) var currentDevice: NCDevice?
    private let scriptHandler: ScriptsHandler?
    
    weak var deviceChangeDelegate: DeviceChangeDelegate?
    
    init(transparencyController: NCAVListeningModeController = NCAVListeningModeController(),
         delegate: DeviceChangeDelegate? = nil,
         scriptHandler: ScriptsHandler? = nil) {
        self.transparencyController = transparencyController
        self.deviceChangeDelegate = delegate
        self.scriptHandler = scriptHandler
    }
    
    fileprivate var listeningMode: NCListeningMode {
        return currentDevice?.listeningMode ?? .normal
    }
    
    var listeningModeDisplayable: String {
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
                } else {
                    self.currentDevice = nil
                }
            })
        }
        
        self.transparencyController.startListeningForUpdates()
    }
}
