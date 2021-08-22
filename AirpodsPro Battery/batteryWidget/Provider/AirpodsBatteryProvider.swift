//
//  AirpodsBatteryProvider.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/08/2021.
//  Copyright © 2021 Mohamed Arradi. All rights reserved.
//

import SwiftUI
import Intents
import WidgetKit


struct BatteryEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let batteryInformation: BatteryInformation
}

struct AirpodsBatteryProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> BatteryEntry {
        BatteryEntry(date: Date(), configuration: ConfigurationIntent(), batteryInformation: BatteryInformation())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (BatteryEntry) -> ()) {
        let entry = BatteryEntry(date: Date(), configuration: configuration, batteryInformation: BatteryInformation())
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<BatteryEntry>) -> ()) {
        var entries: [BatteryEntry] = []
        let currentDate = Date()
        for secondOffset in stride(from: 10, to: 100, by: 10) {
            if let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate) {
                let entry = BatteryEntry(date: entryDate, configuration: configuration, batteryInformation: BatteryInformation())
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
