//
//  TimeTracker.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/11.
//

import Foundation

struct TimeTracker {
    var totalTime = 0
    var currentTime: Float = 0
    
    var timeFormatter: String {
        let h = totalTime / 3600
        let m = (totalTime - (h * 3600)) / 60
        let s = (totalTime - (h * 3600)) - (m * 60)
        return String(format: "%02d:%02d:%02d", h, m, s)
    }
}
