//
//  TrackingTime+CoreDataProperties.swift
//  DayBlock
//
//  Created by 김민준 on 10/1/23.
//
//

import Foundation
import CoreData

extension TrackingTime {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<TrackingTime> {
        return NSFetchRequest<TrackingTime>(entityName: "TrackingTime")
    }

    @NSManaged public var endTime: String
    @NSManaged public var startTime: String?
    @NSManaged public var output: Double
    @NSManaged public var superDate: TrackingDate

}

extension TrackingTime: Identifiable {

}
