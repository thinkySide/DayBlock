//
//  HomeVC+Relaunch.swift
//  DayBlock
//
//  Created by 김민준 on 12/27/23.
//

import UIKit

extension HomeViewController {
    
    /// APP 종료 후, 트래킹 모드를 다시 설정하는 메서드입니다.
    func setTrackingModeAfterAppRestart() {
        
        // 2. 마지막으로 앱을 종료한 시점 구하기
        let lastAccess = UserDefaultsItem.shared.lastAccessSecond
        
        // 3. (현재 시간 - 마지막 종료 시점) -> 얼마나 앱이 종료되었는지 구할 수 있음
        let elapsedTime = trackingData.todaySecondsToInt() - lastAccess
        
        // 4. 앱 종료 전 총 트래킹 시간 구하기
        let originalTotalTime = UserDefaultsItem.shared.trackingSecondBeforeAppTermination
        
        // 5. 최종 시간 = 기존 전체 시간 + 지난 시간
        let newTotalTime = originalTotalTime + elapsedTime
        timerManager.totalTime = newTotalTime
        print("[최종 시간: \(newTotalTime)] = [기존 전체 시간: \(originalTotalTime)] + [지난 시간: \(elapsedTime)]")
        
        // 6. 그럼 현재 트래킹 세션은 얼마나 진행되었는가?
        //    현재 시간 = 최종 시간 % 타겟 숫자
        let currentTime = newTotalTime % trackingData.targetSecond
        timerManager.currentTime = Float(currentTime)
        
        // 8. totalBlock 업데이트
        timerManager.totalBlock = Double(timerManager.totalTime / trackingData.targetSecond) * 0.5
        print("totalBlock: \(timerManager.totalBlock)개")
        
        // 11. 블럭이 생성된 만큼 데이터 추가(0보다 클 때만)
        let timeList = trackingData.focusDate().trackingTimeList?.array as! [TrackingTime]
        let filter = timeList.filter { $0.endTime != nil }.count
        let count = timeList.count - filter
        print("[전체 개수: \(timeList.count)] - [endTime이 존재하는 개수: \(filter)] = \(count)")
        
        if timerManager.totalBlock > 0 {
            for _ in 1...count {
                trackingData.appedDataBetweenAppDisconect()
            }
        }
        
        // 12. 생산 블럭량 라벨 업데이트
        viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
        
        // 13. 추가된 데이터로 트래킹 보드 리스트 업데이트
        trackingData.regenerationTrackingBlocks() // 원래 코드
        // trackingData.testAppendForDisconnect() // 테스트 코드
        
        // 14. 트래킹 보드 애니메이션 업데이트
        viewManager.trackingBoard.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
        
        // 15. 타이머 및 프로그레스 바 UI 업데이트
        viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
        
        // 16. 트래킹 모드 시작
        viewManager.trackingRestartForDisconnect()
    }
}
