//
//  batteryWidget.swift
//  batteryWidget
//
//  Created by Mohamed Arradi on 20/11/2020.
//  Copyright © 2020 Mohamed Arradi. All rights reserved.
//

import WidgetKit
import SwiftUI
import Intents

struct Provider: IntentTimelineProvider {
    func placeholder(in context: Context) -> AirpodsBatteryEntry {
        AirpodsBatteryEntry(date: Date(), configuration: ConfigurationIntent(), batteryInformation: BatteryInformation())
    }
    
    func getSnapshot(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (AirpodsBatteryEntry) -> ()) {
        let entry = AirpodsBatteryEntry(date: Date(), configuration: configuration, batteryInformation: BatteryInformation())
        completion(entry)
    }
    
    func getTimeline(for configuration: ConfigurationIntent, in context: Context, completion: @escaping (Timeline<Entry>) -> ()) {
        var entries: [AirpodsBatteryEntry] = []
        let currentDate = Date()
        for secondOffset in stride(from: 20, to: 180, by: 40) {
            if let entryDate = Calendar.current.date(byAdding: .second, value: secondOffset + 40, to: currentDate) {
                let entry = AirpodsBatteryEntry(date: entryDate, configuration: configuration, batteryInformation: BatteryInformation())
                entries.append(entry)
            }
        }
        
        let timeline = Timeline(entries: entries, policy: .atEnd)
        completion(timeline)
    }
}

struct BatteryInformation {
    
    var displayableBatteryText: String {
        let leftP =   PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.left.rawValue) as? CGFloat
        let rightP =  PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.right.rawValue) as? CGFloat
        
        guard let left = leftP,
              let right = rightP, left > 0.0 && right > 0.0 else {
            return "Not connected"
        }
        
        return "\(left)%        \(right)%"
    }
    
    var displayableCaseBattery: String {
        
        let caseP = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.BatteryValue.case.rawValue) as? CGFloat
        
        guard let caseP = caseP, caseP > 0.0 else {
            return "--"
        }
        
        return "\(caseP) %"
    }
}

struct AirpodsBatteryEntry: TimelineEntry {
    let date: Date
    let configuration: ConfigurationIntent
    let batteryInformation: BatteryInformation
}

struct batteryWidgetEntryView : View {
    var entry: Provider.Entry
    
    var body: some View {
        VStack(alignment: .center, spacing: nil, content: {
            VStack {
                Image("Airpods")
                    .resizable()
                    .frame(width: 80.0, height: 80.0)
                Text(entry.batteryInformation.displayableBatteryText)
                    .bold()
                    .foregroundColor(.white)
            }
            HStack {
                Image("CaseAirpods")
                    .resizable()
                    .frame(width: 15, height: 15, alignment: .leading)
                Text(entry.batteryInformation.displayableCaseBattery)
                    .fontWeight(.regular)
                    .foregroundColor(.white)
            }
        })
    }
}

@main
struct batteryWidget: Widget {
    let kind: String = "batteryWidget"
    
    var body: some WidgetConfiguration {
        IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: Provider()) { entry in
            batteryWidgetEntryView(entry: entry)
        }
        .supportedFamilies([.systemSmall, .systemMedium])
        .configurationDisplayName("Airpods Battery Monitor")
        .description("This widget help you monitoring your battery level from your mac")
    }
}

struct batteryWidget_Previews: PreviewProvider {
    static var previews: some View {
        batteryWidgetEntryView(entry: AirpodsBatteryEntry(date: Date(), configuration: ConfigurationIntent(), batteryInformation: BatteryInformation()))
            .previewContext(WidgetPreviewContext(family: .systemSmall))
    }
}
