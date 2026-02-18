//
//  DayOfWeek.swift
//  Domain
//
//  Created by 김민준 on 2/18/26.
//

import Foundation

public enum DayOfWeek: Int {
    case sunday
    case monday
    case tueseday
    case wednesday
    case thursday
    case friday
    case saturday
    
    public var toString: String {
        switch self {
        case .sunday: "Sun"
        case .monday: "Mon"
        case .tueseday: "Tue"
        case .wednesday: "Wed"
        case .thursday: "Thu"
        case .friday: "Fri"
        case .saturday: "Sat"
        }
    }
}
