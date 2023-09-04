//
//  TrackingManager.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/31.
//

import Foundation

/// 트래킹 매니저
final class TrackingManager {
    
    /// 싱글톤
    static let shared = TrackingManager()
    private init() {}
    
    /// 트래킹 시작 시간
    private var startTime = 0
    
    /// 현재 트래킹 중인 블럭 인덱스 배열 (문자열을 키값처럼 사용)
    private var trackingBlockIndexs: [String] = []
    
    /// 현재 트래킹 중인 블럭 인덱스 배열을 반환합니다.
    func getTrackingBlockIndexs() -> [String] {
        updateTrackingBlockIndex()
        return trackingBlockIndexs
    }
    
    /// 트래킹 시작 시간을 업데이트합니다.
    func updateTrackingStartTime(_ timeFormat: String) {
        let timeArray = timeFormat.components(separatedBy: "/")
        var numArray: [Int] = []
        
        for i in timeArray {
            if let time = Int(i) {
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
        
        // print("startTime: \(startTime)")
    }
    
    /// 트래킹 블럭 번호를 업데이트합니다.
    func updateTrackingBlockIndex() {
        switch startTime {
            
        case 0...1799:
            // 00:00-00:29
            trackingBlockIndexs.append("0000")
            
        case 1800...3599:
            // 00:30-00:59
            trackingBlockIndexs.append("0030")
            
        case 3600...5399:
            // 01:00-01:29
            trackingBlockIndexs.append("0100")
            
        case 5400...7199:
            // 01:30-01:59
            trackingBlockIndexs.append("0130")
            
        case 7200...8999:
            // 02:00-02:29
            trackingBlockIndexs.append("0200")
            
        case 9000...10799:
            // 02:30-02:59
            trackingBlockIndexs.append("0230")
            
        case 10800...12599:
            // 03:00-03:29
            trackingBlockIndexs.append("0300")
            
        case 12600...14399:
            // 03:30-03:59
            trackingBlockIndexs.append("0330")
            
        case 14400...16199:
            // 04:00-04:29
            trackingBlockIndexs.append("0400")
            
        case 16200...17999:
            // 04:30-04:59
            trackingBlockIndexs.append("0430")
            
        case 18000...19799:
            // 05:00-05:29
            trackingBlockIndexs.append("0500")
            
        case 19800...21599:
            // 05:30-05:59
            trackingBlockIndexs.append("0530")
            
        case 21600...23399:
            // 06:00-06:29
            trackingBlockIndexs.append("0600")
            
        case 23400...25199:
            // 06:30-06:59
            trackingBlockIndexs.append("0630")
            
        case 25200...26999:
            // 07:00-07:29
            trackingBlockIndexs.append("0700")
            
        case 27000...28799:
            // 07:30-07:59
            trackingBlockIndexs.append("0730")
            
        case 28800...30599:
            // 08:00-08:29
            trackingBlockIndexs.append("0800")
            
        case 30600...32399:
            // 08:30-08:59
            trackingBlockIndexs.append("0830")
            
        case 32400...34199:
            // 09:00-09:29
            trackingBlockIndexs.append("0900")
            
        case 34200...35999:
            // 09:30-09:59
            trackingBlockIndexs.append("0930")
            
        case 36000...37799:
            // 10:00-10:29
            trackingBlockIndexs.append("1000")
            
        case 37800...39599:
            // 10:30-10:59
            trackingBlockIndexs.append("1030")
            
        case 39600...41399:
            // 11:00-11:29
            trackingBlockIndexs.append("1100")
            
        case 41400...43199:
            // 11:30-11:59
            trackingBlockIndexs.append("1130")
            
        case 43200...44999:
            // 12:00-12:29
            trackingBlockIndexs.append("1200")
            
        case 45000...46799:
            // 12:30-12:59
            trackingBlockIndexs.append("1230")
            
        case 46800...48599:
            // 13:00-13:29
            trackingBlockIndexs.append("1300")
            
        case 48600...50399:
            // 13:30-13:59
            trackingBlockIndexs.append("1330")
            
        case 50400...52199:
            // 14:00-14:29
            trackingBlockIndexs.append("1400")
            
        case 52200...53999:
            // 14:30-14:59
            trackingBlockIndexs.append("1430")
            
        case 54000...55799:
            // 15:00-15:29
            trackingBlockIndexs.append("1500")
            
        case 55800...57599:
            // 15:30-15:59
            trackingBlockIndexs.append("1530")
            
        case 57600...59399:
            // 16:00-16:29
            trackingBlockIndexs.append("1600")
            
        case 59400...61199:
            // 16:30-16:59
            trackingBlockIndexs.append("1630")
            
        case 61200...62999:
            // 17:00-17:29
            trackingBlockIndexs.append("1700")
            
        case 63000...64799:
            // 17:30-17:59
            trackingBlockIndexs.append("1730")
            
        case 64800...66599:
            // 18:00-18:29
            trackingBlockIndexs.append("1800")
            
        case 66600...68399:
            // 18:30-18:59
            trackingBlockIndexs.append("1830")
            
        case 68400...70199:
            // 19:00-19:29
            trackingBlockIndexs.append("1900")
            
        case 70200...71999:
            // 19:30-19:59
            trackingBlockIndexs.append("1930")
            
        case 72000...73799:
            // 20:00-20:29
            trackingBlockIndexs.append("2000")
            
        case 73800...75599:
            // 20:30-20:59
            trackingBlockIndexs.append("2030")
            
        case 75600...77399:
            // 21:00-21:29
            trackingBlockIndexs.append("2100")
            
        case 77400...79199:
            // 21:30-21:59
            trackingBlockIndexs.append("2130")
            
        case 79200...80999:
            // 22:00-22:29
            trackingBlockIndexs.append("2200")
            
        case 81000...82799:
            // 22:30-22:59
            trackingBlockIndexs.append("2230")
            
        case 82800...84599:
            // 23:00-23:29
            trackingBlockIndexs.append("2300")
            
        case 84600...86399:
            // 23:30-23:59
            trackingBlockIndexs.append("2330")
            
        default:
            break
        }
        
        print(trackingBlockIndexs)
    }
    
    
}
