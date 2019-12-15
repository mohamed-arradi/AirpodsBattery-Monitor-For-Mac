//
//  BatteryView.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa

class BatteryView: NSView {
    
    @IBOutlet weak var rightEarBatteryLevelLabel: NSTextField!
    @IBOutlet weak var leftEarBatteryLevelLabel: NSTextField!
    @IBOutlet weak var caseBatteryLevelLabel: NSTextField!
    @IBOutlet weak var batteryLevelRightProgressBar: JCGGProgressBar!
    @IBOutlet weak var batteryLevelLeftProgressBar: JCGGProgressBar!
    @IBOutlet weak var batteryLevelCaseProgressBar: JCGGProgressBar!
    @IBOutlet weak var caseImageView: NSImageView!
    @IBOutlet weak var leftEarImageView: NSImageView!
    @IBOutlet weak var rightEarImageView: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViewData(airpodsBatteryViewModel: BatteryViewModel) {
        
        caseBatteryLevelLabel.stringValue = airpodsBatteryViewModel.caseBatteryValue
        batteryLevelCaseProgressBar.progressValue = airpodsBatteryViewModel.caseBatteryProgressValue
        leftEarBatteryLevelLabel.stringValue = airpodsBatteryViewModel.leftBatteryValue
        batteryLevelLeftProgressBar.progressValue = airpodsBatteryViewModel.leftBatteryProgressValue
        rightEarBatteryLevelLabel.stringValue = airpodsBatteryViewModel.rightBatteryValue
        batteryLevelRightProgressBar.progressValue = airpodsBatteryViewModel.rightBatteryProgressValue
        
        switch airpodsBatteryViewModel.connectionStatus {
        case .connected:
            leftEarImageView.image = NSImage(imageLiteralResourceName: "LeftAirpodEar")
            rightEarImageView.image = NSImage(imageLiteralResourceName: "RightAirpodEar")
            caseImageView.image = NSImage(imageLiteralResourceName: "AirpodsCase")
        default:
            leftEarImageView.image = NSImage(imageLiteralResourceName: "LeftAirpodsDisconnected")
            rightEarImageView.image = NSImage(imageLiteralResourceName: "RightAirpodEarDisconnected")
            caseImageView.image = NSImage(imageLiteralResourceName: "AirpodsCaseDisconnected")
        }
    }
    
}
