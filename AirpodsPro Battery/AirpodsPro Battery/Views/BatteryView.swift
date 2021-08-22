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
    
    @IBOutlet weak var airpodsBatteryView: BatteryAirpodsView!
    @IBOutlet weak var headsetBatteryView: BatteryHeadsetView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func updateViewData(_ viewModel: AirPodsBatteryViewModel?) {
        
        guard let airpodsBatteryViewModel = viewModel else {
            return
        }
        
        if let airpodsInfo = airpodsBatteryViewModel.airpodsInfo,
           airpodsInfo.deviceState == .connected {
            airpodsBatteryView.updateData(airpodsBatteryViewModel: airpodsBatteryViewModel)
            headsetBatteryView.isHidden = true
            airpodsBatteryView.isHidden = false
        } else if let headsetInfo = airpodsBatteryViewModel.headsetInfo,
                  headsetInfo.deviceState == .connected {
            headsetBatteryView.isHidden = false
            airpodsBatteryView.isHidden = true
            headsetBatteryView.updateViewData(viewModel)
        } else {
            
            let latestDeviceType = airpodsBatteryViewModel.latestDeviceType
            
            headsetBatteryView.isHidden = true
            airpodsBatteryView.isHidden = true
            
            switch latestDeviceType {
            case .airpods:
                airpodsBatteryView.isHidden = false
                airpodsBatteryView.updateData(airpodsBatteryViewModel: airpodsBatteryViewModel)
            case .headset:
                headsetBatteryView.isHidden = false
                headsetBatteryView.updateViewData(viewModel)
            default:
                airpodsBatteryView.isHidden = false
                airpodsBatteryView.updateData(airpodsBatteryViewModel: airpodsBatteryViewModel)
            }
        }
    }
}
