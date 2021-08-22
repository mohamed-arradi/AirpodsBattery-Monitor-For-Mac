//
//  BatteryHeadsetView.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 21/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa

class BatteryHeadsetView: NSView {
    
    @IBOutlet weak var batteryLevelLabel: NSTextField!
    @IBOutlet weak var batteryLevelProgressBar: JCGGProgressBar!
    @IBOutlet weak var headsetImageView: NSImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViewData(_ viewModel: AirPodsBatteryViewModel?) {
        
        guard let airpodsBatteryViewModel = viewModel else {
            return
        }
    
        batteryLevelLabel.stringValue = airpodsBatteryViewModel.headsetInfo?.displayBatteryValue ?? "--"
        batteryLevelProgressBar.progressValue = airpodsBatteryViewModel.headsetInfo?.batteryValue ?? 0.0
        
        switch airpodsBatteryViewModel.connectionStatus {
        case .connected:
            headsetImageView.image = NSImage(imageLiteralResourceName: "HeadSetIcon")
        default:
            headsetImageView.image = NSImage(imageLiteralResourceName: "HeadSetIcon")
        }
    }
    
}
