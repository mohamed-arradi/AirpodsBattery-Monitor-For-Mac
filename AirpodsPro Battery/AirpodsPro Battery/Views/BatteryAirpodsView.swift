//
//  BatteryAirpodsView.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa

class BatteryAirpodsView: NSView {

    @IBOutlet weak var rightEarBatteryLevelLabel: NSTextField!
    @IBOutlet weak var leftEarBatteryLevelLabel: NSTextField!
    @IBOutlet weak var caseBatteryLevelLabel: NSTextField!
    @IBOutlet weak var batteryLevelRightProgressBar: JCGGProgressBar!
    @IBOutlet weak var batteryLevelLeftProgressBar: JCGGProgressBar!
    @IBOutlet weak var batteryLevelCaseProgressBar: JCGGProgressBar!
    @IBOutlet weak var caseImageView: NSImageView!
    @IBOutlet weak var leftEarImageView: NSImageView!
    @IBOutlet weak var rightEarImageView: NSImageView!

    func updateData(airpodsBatteryViewModel: AirPodsBatteryViewModel) {

        caseBatteryLevelLabel.stringValue = airpodsBatteryViewModel.airpodsInfo?.caseDisplayBatteryValue ?? "--"
        batteryLevelCaseProgressBar.progressValue = airpodsBatteryViewModel.airpodsInfo?.caseBatteryValue ?? 0.0
        leftEarBatteryLevelLabel.stringValue = airpodsBatteryViewModel.airpodsInfo?.leftDisplayBatteryValue ?? "--"
        batteryLevelLeftProgressBar.progressValue = airpodsBatteryViewModel.airpodsInfo?.leftBatteryValue ?? 0.0
        rightEarBatteryLevelLabel.stringValue = airpodsBatteryViewModel.airpodsInfo?.rightDisplayBatteryValue ?? "--"
        batteryLevelRightProgressBar.progressValue = airpodsBatteryViewModel.airpodsInfo?.rightBatteryValue ?? 0.0

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
