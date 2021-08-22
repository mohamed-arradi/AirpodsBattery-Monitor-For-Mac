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


struct AirpodsBatteryEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let batteryInformation: BatteryInformation
}

struct AirpodsBatteryProvider: IntentTimelineProvider {
    
    func placeholder(in context: Context) -> AirpodsBatteryEntry {
        AirpodsBatteryEntry(date: Date(), configuration: ConfigurationIntent(), batteryInformation: BatteryInformation())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AirpodsBatteryEntry) -> ()) {
        let entry = AirpodsBatteryEntry(date: Date(), configuration: configuration, batteryInformation: BatteryInformation())
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<AirpodsBatteryEntry>) -> ()) {
        var entries: [AirpodsBatteryEntry] = []
        let currentDate = Date()
        for secondOffset in stride(from: 10, to: 20, by: 5) {
            if let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset, to: currentDate) {
                let entry = AirpodsBatteryEntry(date: entryDate, configuration: configuration, batteryInformation: BatteryInformation())
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}
