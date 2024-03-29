//
//  AppleScriptExecutor.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 02/07/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation

struct AppleScriptType {
    static let batteryNotification = "display notification \"Airpods Battery Monitor\" with title \"Low Battery\" subtitle \"Battery less than \" & %@ & \"%. Please connect to power now!\" sound name \"Frog\""
}

struct AppleScriptExecutor {
    
    func executeAction(script: String) {
        var error: NSDictionary?
        if let scriptObject = NSAppleScript(source: script) {
            let output = scriptObject.executeAndReturnError(&error)
            if error == nil {
                Logger.da(output.stringValue ?? "")
            } else {
                Logger.da(error?.description ?? "apple script error")
            }
        }
    }
}
