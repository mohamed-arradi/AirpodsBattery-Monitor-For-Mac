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
        
        if airpodsBatteryViewModel.airpodsInfo != nil {
            airpodsBatteryView.updateData(airpodsBatteryViewModel: airpodsBatteryViewModel)
            headsetBatteryView.isHidden = true
            airpodsBatteryView.isHidden = false
        } else if airpodsBatteryViewModel.headsetInfo != nil {
            headsetBatteryView.isHidden = false
            airpodsBatteryView.isHidden = true
            headsetBatteryView.updateViewData(viewModel)
        }
    }
}
