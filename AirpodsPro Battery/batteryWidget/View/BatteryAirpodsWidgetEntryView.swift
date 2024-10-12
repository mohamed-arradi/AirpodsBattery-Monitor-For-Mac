//
//  BatteryAirpodsWidgetEntryView.swift
//  batteryWidgetExtension
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import WidgetKit
import SwiftUI

extension View {
    @ViewBuilder func widgetBackground<T: View>(@ViewBuilder content: () -> T) -> some View {
        if #available(iOS 17.0, *) {
            if #available(macOSApplicationExtension 14.0, *) {
                containerBackground(for: .widget, content: content)
            } else {
                // Fallback on earlier versions
            }
        }else {
            background(content())
        }
    }
}

struct BatteryAirpodsWidgetEntryView : View {
    var entry: AirpodsBatteryProvider.Entry
    
    var body: some View {
        
        if let deviceType = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.DeviceMetaData.deviceType.rawValue) as? Int, deviceType == DeviceType.airpods.rawValue {
        Color("WidgetBackground")
            .overlay(
                VStack(alignment: .center, spacing: nil, content: {
                    VStack {
                        Image("Airpods")
                            .resizable()
                            .frame(width: 60.0, height: 60.0)
                        Text(entry.batteryInformation.displayableAirpodsBatteryText)
                            .bold()
                            .foregroundColor(.white)
                    }
                    HStack {
                        Image("CaseAirpods")
                            .resizable()
                            .frame(width: 15, height: 15, alignment: .leading)
                        Text(entry.batteryInformation.displayableCaseBattery)
                            .bold()
                            .foregroundColor(.white)
                    }
                    HStack {
                        Spacer()
                        Button {
                            let isConnected = entry.batteryInformation.isConnected
                            if let url = URL(string: "airpodsbattery://\(isConnected ? "disconnect" : "connect")") {
                                NSWorkspace.shared.open(url)
                            }
                        } label: {
                            Text(entry.batteryInformation.isConnected ? "Disconnect" : "Connect").foregroundColor(.white)
                        }

                        Spacer()
                    }
                    .frame(height: 30.0)
                })
            )
        } else {
            Color("WidgetBackground")
                .overlay(
                        VStack(alignment: .center, spacing: 8, content: {
                            Image("HeadSet")
                                .resizable()
                                .frame(width: 80.0, height: 80.0)
                            Text(entry.batteryInformation.displayableHeadsetBattery)
                                .font(Font.system(size: 18.0, weight: .bold, design: .default))
                                .foregroundColor(.white)
                            Text(entry.batteryInformation.deviceName)
                                .font(Font.system(size: 10.0, weight: .light, design: .default))
                                .foregroundColor(.white)
                        })
                )
        }
    }
}


struct BatteryInformation {
    
    var displayableHeadsetBattery: String {
        
        let batteryValue = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.headset.rawValue) as? CGFloat
    
        guard let batt = batteryValue,
              batt > 0.0 else {
            return "--"
        }
        
        return "\(Int(batt)) %"
    }
    
    var deviceName: String {
        
        guard let deviceName = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.DeviceMetaData.shortName.rawValue) as? String else {
            return ""
        }
        
        return deviceName
    }
    
    var displayableAirpodsBatteryText: String {
        
        let leftP =  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.left.rawValue) as? CGFloat
        let rightP = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.right.rawValue) as? CGFloat
        
        guard let left = leftP,
              let right = rightP, left > 0.0 && right > 0.0 else {
            return "Not connected"
        }
        
        var display = ""
        
        if let left = leftP {
            display = display.appending("\(left)%")
        }
        
        if let _ = leftP,
           let right = rightP {
            display = display.appending("       \(right)%")
        }
        if leftP == nil || left == -1,
           let right = rightP {
            display = "\(right)%"
        }
        
        return display
    }
    
    var displayableCaseBattery: String {
        
        let caseP = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.case.rawValue) as? CGFloat
        
        guard let caseP = caseP,
              caseP > 0.0 else {
            return "--"
        }
        
        return "\(caseP) %"
    }
    
    var isConnected: Bool {
        
        let leftP =  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.left.rawValue) as? CGFloat
        let rightP = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.right.rawValue) as? CGFloat
        
        guard let left = leftP,
              let right = rightP, left > 0.0 && right > 0.0 else {
            return false
        }
        
        return true
    }
}
