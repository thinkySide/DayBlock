//
//  PushNotificationService.swift
//  DayBlock
//
//  Created by 김민준 on 12/24/23.
//

import Foundation
import UserNotifications

final class PushNotificationService {
    
    static let shared = PushNotificationService()
    private init() {}
    
    /// Push 알림을 수신합니다.
    func pushNotification(title: String, body: String, seconds: Double, identifier: String) {
        
        // 알림 내용, 설정
        let notificationContent = UNMutableNotificationContent()
        notificationContent.title = title
        notificationContent.body = body
        
        // 조건(시간, 반복)
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: false)
        
        // 요청
        let request = UNNotificationRequest(identifier: identifier,
                                            content: notificationContent,
                                            trigger: trigger)
        
        // 알림 등록
        UNUserNotificationCenter.current().add(request) { error in
            if let error = error {
                print("Notification Error: ", error)
            }
        }
    }
}
