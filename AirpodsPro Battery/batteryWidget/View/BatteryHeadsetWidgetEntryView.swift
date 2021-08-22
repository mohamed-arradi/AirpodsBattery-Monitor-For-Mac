//
//  AirpodsBatteryEntryView.swift
//  batteryWidgetExtension
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

struct BatteryHeadsetWidgetEntryView: View {
    
    var entry: HeadsetBatteryProvider.Entry
        
    var body: some View {
        Color("WidgetBackground")
            .overlay(
                    VStack(alignment: .center, spacing: 8, content: {
                        Image("HeadSet")
                            .resizable()
                            .frame(width: 80.0, height: 80.0)
                        Text(entry.displayableBatteryText)
                            .font(Font.system(size: 18.0, weight: .bold, design: .default))
                            .foregroundColor(.white)
                        Text(entry.deviceName)
                            .font(Font.system(size: 10.0, weight: .light, design: .default))
                            .foregroundColor(.white)
                    })
            )
    }
}
