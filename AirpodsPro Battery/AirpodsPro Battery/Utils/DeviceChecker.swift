//
//  DeviceChecker.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 02/07/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

struct DeviceChecker {
    
    static func isAppleDevice(deviceAddress: String, scriptHandler: ScriptsHandler?, completion: @escaping (Bool) -> Void) {
        
        let script = scriptHandler?.scriptDiskFilePath(scriptName: "apple-devices-verification.sh") ?? ""
        let macMappingFile = scriptHandler?.scriptDiskFilePath(scriptName: "oui.txt") ?? ""
        
        scriptHandler?.execute(commandName: "sh", arguments: ["\(script)", "\(deviceAddress)","\(macMappingFile)"]) { (result) in
            
            switch result {
            case .success(let value):
                value.trimmingCharacters(in: .whitespacesAndNewlines) == "0" ? completion(false) : completion(true)
            case .failure( _):
                completion(false)
            }
        }
    }
}
