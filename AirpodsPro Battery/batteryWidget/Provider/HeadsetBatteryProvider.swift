//
//  HeadsetBatteryProvider.swift
//  batteryWidgetExtension
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import Foundation
import SwiftUI
import Intents
import WidgetKit

struct HeadsetBatteryEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    
    var displayableBatteryText: String {
        
        let batteryValue = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.headset.rawValue) as? CGFloat
    
        guard let batt = batteryValue,
              batt > 0.0 else {
            return "--"
        }
        
        return "\(Int(batt)) %"
    }
}

struct HeadsetBatteryProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> HeadsetBatteryEntry {
        HeadsetBatteryEntry(date: Date(), configuration: ConfigurationIntent())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (HeadsetBatteryEntry) -> ()) {
        let entry = HeadsetBatteryEntry(date: Date(), configuration: configuration)
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<HeadsetBatteryEntry>) -> ()) {
        var entries: [HeadsetBatteryEntry] = []
        let currentDate = Date()
        for secondOffset in stride(from: 10, to: 20, by: 5) {
            if let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate) {
                let entry = HeadsetBatteryEntry(date: entryDate, configuration: configuration)
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
