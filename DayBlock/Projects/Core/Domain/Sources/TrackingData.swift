//
//  TrackingData.swift
//  Domain
//
//  Created by 김민준 on 1/11/26.
//

import Foundation

public struct TrackingData: Identifiable, Equatable, Codable {
    
    /// 트래킹 데이터 Id
    public let id: UUID
    
    /// 트래킹 시간 리스트
    public var timeList: [Time]
    
    /// 트래킹 시간
    public struct Time: Equatable, Codable {
        
        /// 시작 날짜
        public var startDate: Date
        
        /// 종료 날짜
        public var endDate: Date?
        
        public init(
            startDate: Date,
            endDate: Date?
        ) {
            self.startDate = startDate
            self.endDate = endDate
        }
    }
    
    public init(
        id: UUID,
        timeList: [Time]
    ) {
        self.id = id
        self.timeList = timeList
    }
}
