//
//  Tracker.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/11.
//

import Foundation

struct Tracker {
    var totalTime = 0
    var currentTime: Float = 0
    var totalBlock: Float = 0

    var timeFormatter: String {
        let hour = totalTime / 3600
        let minute = (totalTime - (hour * 3600)) / 60
        let second = (totalTime - (hour * 3600)) - (minute * 60)
        return String(format: "%02d:%02d:%02d", hour, minute, second)
    }
}
