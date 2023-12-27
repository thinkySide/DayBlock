//
//  RepositoryItem.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

struct RepositoryItem {
    let groupName: String
    let groupColor: Int
    
    let blockTaskLabel: String
    let blockIcon: String
    
    let trackingDate: TrackingDate
    let trackingTimes: [TrackingTime]
}
