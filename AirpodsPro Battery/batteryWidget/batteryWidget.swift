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
@main
struct batteryWidget: Widget {
    let kind: String = "batteryWidget"
    
    var body: some WidgetConfiguration {
        if let deviceType = PrefsPersistanceManager().getValuePreferences(from: PreferenceKey.DeviceMetaData.deviceType.rawValue) as? Int,
           deviceType == DeviceType.headset.rawValue {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: HeadsetBatteryProvider()) { entry in
                AnyView(BatteryHeadsetWidgetEntryView(entry: entry))
            }
            .supportedFamilies([.systemSmall, .systemMedium])
            .configurationDisplayName("Airpods Battery Monitor")
            .description("This widget help you monitoring your battery level from your mac")
        } else {
            return IntentConfiguration(kind: kind, intent: ConfigurationIntent.self, provider: AirpodsBatteryProvider()) { entry in
                AnyView(BatteryAirpodsWidgetEntryView(entry: entry))
            }
            .supportedFamilies([.systemSmall, .systemMedium])
            .configurationDisplayName("Airpods Battery Monitor")
            .description("This widget help you monitoring your battery level from your mac")
        }
    }
}

struct batteryWidget_Previews: PreviewProvider {
    static var previews: some View {
        
        let test = 2
        if test == 1 {
            return AnyView(BatteryAirpodsWidgetEntryView(entry: AirpodsBatteryEntry(date: Date(), configuration: ConfigurationIntent(), batteryInformation: BatteryInformation())))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        } else {
            return AnyView(BatteryHeadsetWidgetEntryView(entry: HeadsetBatteryEntry(date: Date(), configuration: ConfigurationIntent())))
                .previewContext(WidgetPreviewContext(family: .systemSmall))
        }
    }
}
