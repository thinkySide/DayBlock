//
//  NotificationName.swift
//  DayBlock
//
//  Created by 김민준 on 12/14/23.
//

import Foundation

extension Notification.Name {
    static let latestAccess = NSNotification.Name("latestAccess")
    static let onboardingTrackingCompleteToolTip = NSNotification.Name("onboardingTrackingCompleteToolTip")
    static let reloadForDeleteBlock = NSNotification.Name("reloadForDeleteBlock")
    static let reloadForUpdateBlock = NSNotification.Name("reloadForUpdateBlock")
    static let updateCreateBlockUI = NSNotification.Name("updateCreateBlockUI")
    static let resetAllData = NSNotification.Name("resetAllData")
}
