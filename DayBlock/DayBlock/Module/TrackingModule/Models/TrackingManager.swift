//
//  TrackingManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/31.
//

import Foundation

/// 블럭 트래킹 매니저
final class TrackingManager {
    
    // MARK: - Properties
    
    /// 싱글톤
    static let shared = TrackingManager()
    private init() {}
    
    /// 트래킹 정보를 담는 타입
    ///
    /// YYYY년 M월 d일 E요일의 날짜를 키값으로 가지고,
    /// 1530, 1600, 1630 등의 시간대 배열을 값으로 가집니다.
    typealias TrackingType = [String: [String]]
    
    /// 트래킹 시작 시간
    ///
    /// 0부터 86,400 사이의 수를 기준으로 트래킹 할 블럭을 계산합니다.
    private var startTime = 0
    
    /// 현재 트래킹 중인 블럭의 정보를 담는 Dictionary
    private var trackingBlocks: TrackingType = [:]
    
    // MARK: - Format
    
    /// 날짜 기본 포맷
    var dateFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "M월 d일 E요일"
        return dateFormatter.string(from: Date())
    }
    
    /// 트래킹 기본 포맷
    var trackingFormat: String {
        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.dateFormat = "YYYY년 M월 d일 E요일"
        return dateFormatter.string(from: Date())
    }
    
    // MARK: - Method
    
    /// 현재 트래킹 중인 블럭 정보 Dictionary를 반환합니다.
    func fetchTrackingBlocks() -> TrackingType {
        updateTrackingBlockIndex()
        return trackingBlocks
    }
    
    /// 트래킹 정보를 담고 있는 Dictionary를 초기화합니다.
    func resetTrackingBlocks() {
        trackingBlocks.removeAll()
    }
    
    /// 트래킹 시작 시간을 업데이트합니다.
    func updateTrackingStartTime(_ timeFormat: String) {
        let timeArray = timeFormat.components(separatedBy: "/")
        var numArray: [Int] = []
        
        for index in timeArray {
            if let time = Int(index) {
                numArray.append(time)
                continue
            }
            print("시간 변환에 실패했습니다.")
            return
        }
        
        let hourSecond = numArray[0] * 3600
        let minSecond = numArray[1] * 60
        let second = numArray[2]
        
        // 최종 업데이트
        startTime = hourSecond + minSecond + second
    }
    
    /// 트래킹
    func appendTrackingBlockIndex(_ dateString: String) {
        
        if trackingBlocks.contains(where: { dic in
            dic.key == trackingFormat
        }) {
            // 만약 키값이 이미 존재한다면
            if let keyArray = trackingBlocks[trackingFormat] {
                
                // 동일한 시간대의 값이 존재하는지 확인 후 배열에 추가
                if !keyArray.contains(dateString) {
                    trackingBlocks[trackingFormat]?.append(dateString)
                }
            }
        } else {
            // 새로 추가하는 거라면 딕셔너리 생성
            trackingBlocks.updateValue([dateString], forKey: trackingFormat)
        }
        
        print(trackingBlocks)
    }
    
    /// 트래킹 블럭 번호를 업데이트합니다.
    func updateTrackingBlockIndex() {
        switch startTime {
        case 0...1799: appendTrackingBlockIndex("0000")
        case 1800...3599: appendTrackingBlockIndex("0030")
        case 3600...5399: appendTrackingBlockIndex("0100")
        case 5400...7199: appendTrackingBlockIndex("0130")
        case 7200...8999: appendTrackingBlockIndex("0200")
        case 9000...10799: appendTrackingBlockIndex("0230")
        case 10800...12599: appendTrackingBlockIndex("0300")
        case 12600...14399: appendTrackingBlockIndex("0330")
        case 14400...16199: appendTrackingBlockIndex("0400")
        case 16200...17999: appendTrackingBlockIndex("0430")
        case 18000...19799: appendTrackingBlockIndex("0500")
        case 19800...21599: appendTrackingBlockIndex("0530")
        case 21600...23399: appendTrackingBlockIndex("0600")
        case 23400...25199: appendTrackingBlockIndex("0630")
        case 25200...26999: appendTrackingBlockIndex("0700")
        case 27000...28799: appendTrackingBlockIndex("0730")
        case 28800...30599: appendTrackingBlockIndex("0800")
        case 30600...32399: appendTrackingBlockIndex("0830")
        case 32400...34199: appendTrackingBlockIndex("0900")
        case 34200...35999: appendTrackingBlockIndex("0930")
        case 36000...37799: appendTrackingBlockIndex("1000")
        case 37800...39599: appendTrackingBlockIndex("1030")
        case 39600...41399: appendTrackingBlockIndex("1100")
        case 41400...43199: appendTrackingBlockIndex("1130")
        case 43200...44999: appendTrackingBlockIndex("1200")
        case 45000...46799: appendTrackingBlockIndex("1230")
        case 46800...48599: appendTrackingBlockIndex("1300")
        case 48600...50399: appendTrackingBlockIndex("1330")
        case 50400...52199: appendTrackingBlockIndex("1400")
        case 52200...53999: appendTrackingBlockIndex("1430")
        case 54000...55799: appendTrackingBlockIndex("1500")
        case 55800...57599: appendTrackingBlockIndex("1530")
        case 57600...59399: appendTrackingBlockIndex("1600")
        case 59400...61199: appendTrackingBlockIndex("1630")
        case 61200...62999: appendTrackingBlockIndex("1700")
        case 63000...64799: appendTrackingBlockIndex("1730")
        case 64800...66599: appendTrackingBlockIndex("1800")
        case 66600...68399: appendTrackingBlockIndex("1830")
        case 68400...70199: appendTrackingBlockIndex("1900")
        case 70200...71999: appendTrackingBlockIndex("1930")
        case 72000...73799: appendTrackingBlockIndex("2000")
        case 73800...75599: appendTrackingBlockIndex("2030")
        case 75600...77399: appendTrackingBlockIndex("2100")
        case 77400...79199: appendTrackingBlockIndex("2130")
        case 79200...80999: appendTrackingBlockIndex("2200")
        case 81000...82799: appendTrackingBlockIndex("2230")
        case 82800...84599: appendTrackingBlockIndex("2300")
        case 84600...86399: appendTrackingBlockIndex("2330")
        default: break
        }
    }
}
