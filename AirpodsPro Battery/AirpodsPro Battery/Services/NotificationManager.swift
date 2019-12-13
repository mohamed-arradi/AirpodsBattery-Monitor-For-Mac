//
//  NotificationManager.swift
//  AirpodsPro Battery
//
//  Created by Mohamed Arradi on 22/11/2019.
//  Copyright © 2019 Mohamed Arradi. All rights reserved.
//

import Foundation
import Cocoa
import UserNotifications

enum NotificationType {
    
    case lowBatteryCase
    case lowBatteryLeft
    case lowBatteryRight
    case lowBatteryBoth
    case lowBatteryAll // Case + Airpods
    
    var title: String {
        switch self {
        case .lowBatteryCase:
            return "low_battery_case_title_notification".localized
        case .lowBatteryLeft:
            return "low_battery_left_ear_title_notification".localized
        case .lowBatteryRight:
            return "low_battery_right_ear_title_notification".localized
        case .lowBatteryBoth:
            return "low_battery_both_title_notification".localized
        case .lowBatteryAll:
            return "low_battery_all_title_notification".localized
        }
    }
}

protocol NotificationBuilderProtocol {
    func generateNotification(notificationType: NotificationType, batteryPercentage: CGFloat) -> NotificationBattery
}

struct NotificationManager {
    
    private (set) var notificationType: NotificationType?
    
    init() {}
    
    init(notificationType: NotificationType) {
        self.notificationType = notificationType
    }
    
    func requestAuthorisation() {
        
        let center = UNUserNotificationCenter.current()

        center.requestAuthorization(options: [.alert, .badge, .sound]) { (granted, error) in
        }
    }
    
    func sendUserNotification(notificationType: NotificationType,
                              batteryPercentage: CGFloat) {
        
        let center = UNUserNotificationCenter.current()
        
          let notificationObject = generateNotification(notificationType: notificationType, batteryPercentage: batteryPercentage)
        
           let content = UNMutableNotificationContent()
           content.title = notificationObject.title
           content.body = notificationObject.subtitle
           content.categoryIdentifier = "alarm"
           content.userInfo = ["percentage": "\(floor(batteryPercentage))"]
           content.sound = UNNotificationSound.default
           
           let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: nil)
           center.add(request)
    }
}

extension NotificationManager: NotificationBuilderProtocol {
    
    func generateNotification(notificationType: NotificationType,
                              batteryPercentage: CGFloat) -> NotificationBattery {
        
        return NotificationBattery(title: notificationType.title,
                                   subtitle: "low_battery_generic_subtitle_notification".localized,
                                   id: UUID().uuidString)
    }
}
