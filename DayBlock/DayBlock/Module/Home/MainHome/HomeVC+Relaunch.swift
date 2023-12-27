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
        let lastTrackingTime = UserDefaultsItem.shared.trackingSecondBeforeAppTermination
        let dayElapsed = trackingData.calculateElapsedDaySinceAppExit
        let timeElapsed = trackingData.calculateElapsedTimeSinceAppExit
        var trackingTimeResult = 0
        
        // MARK: - 트래킹 진행중
        if !UserDefaultsItem.shared.isPaused {
            print("트래킹 진행중")
            
            // 하루가 지났는가? -> X
            if dayElapsed == 0 {
                print("하루 안지났음.")
                
                // 마지막 트래킹 시간 + 흐른 시간
                trackingTimeResult = lastTrackingTime + timeElapsed
            }
            
            // 하루가 지났는가? -> O
            else if dayElapsed > 0 {
                print("\(dayElapsed)일 지났음.")
                
                
            }
        }
        
        // MARK: - 트래킹 일시정지
        else if UserDefaultsItem.shared.isPaused {
            print("트래킹 일시정지")
            
            // 일시정지되었다면 마지막 트래킹 시간 그대로 사용
            trackingTimeResult = lastTrackingTime
            
            // 하루가 지났는가? -> X
            if dayElapsed == 0 {
                print("하루 안지났음.")
            }
            
            // 하루가 지났는가? -> O
            else if dayElapsed > 0 {
                print("\(dayElapsed)일 지났음.")
            }
        }
        
        // 최종 TimeManager 업데이트
        updateTrackingTimeResultAfterAppRestart(result: trackingTimeResult)
        
        // APP 종료되어있을 동안 생성된 블럭 코어데이터 추가
        appendDataBetweenAppExit()
        
        // 트래킹 보드 새롭게 업데이트
        updateTrackingBoardAfterAppRestart()
        
        // 트래킹 모드 최종 시작
        viewManager.trackingRestartForDisconnect()
    }
    
    /// APP 재시작 후 트래킹 시간을 계산해 TimeManager를 업데이트합니다.
    private func updateTrackingTimeResultAfterAppRestart(result: Int) {
        
        // 총 블럭 개수 및 UI 업데이트
        timerManager.totalBlockCount = Double(result / trackingData.targetSecond) * 0.5
        viewManager.updateCurrentProductivityLabel(timerManager.totalBlockCount)
        
        // 총 트래킹 시간 업데이트
        timerManager.totalTrackingSecond = result
        
        // 현재 트래킹 시간 및 프로그레스바 업데이트
        let currentTime = result % trackingData.targetSecond
        timerManager.currentTrackingSecond = Float(currentTime)
        viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
    }
    
    /// APP이 종료되어 있을 동안 생성된 블럭 데이터를 추가합니다.
    private func appendDataBetweenAppExit() {
        
        // 1. TrakcingTime 리스트 받아오기
        let timeList = trackingData.focusDate().trackingTimeList?.array as! [TrackingTime]
        
        // 2. endTime이 존재하는 데이터의 개수만 받아오기(이미 완성된 데이터)
        let completeDatas = timeList.filter { $0.endTime != nil }.count
        
        // 3. 생성해야할 블럭 개수 카운트
        let count = timeList.count - completeDatas
        
        print("[전체 개수: \(timeList.count)] - [endTime이 존재하는 개수: \(completeDatas)] = \(count)")
        
        // 4. 생성해야 할 개수만큼 데이터 생성
        if timerManager.totalBlockCount > 0 {
            for _ in 1...count {
                trackingData.appendDataBetweenAppExit()
            }
        }
    }
    
    /// APP이 재시작 이후 트래킹 보드를 새롭게 업데이트합니다.
    private func updateTrackingBoardAfterAppRestart() {
        
        // 추가된 데이터로 트래킹 보드 리스트 업데이트
        trackingData.regenerationTrackingBlocks() // 원래 코드
        // trackingData.testAppendForDisconnect() // 테스트 코드
        
        // 트래킹 보드 애니메이션 업데이트
        viewManager.trackingBoard.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
    }
}
