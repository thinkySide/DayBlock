//
//  HomeVC+Notification.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/19.
//

import UIKit

extension HomeViewController {
    
    /// Notification Observer를 추가합니다.
    func setupNotification() {
        
        // 마지막 트래킹 시간 추적 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(restartTrackingMode),
            name: NSNotification.Name(Noti.latestAccess),
            object: nil
        )
        
        // 블럭 삭제 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadForDeleteBlock),
            name: NSNotification.Name(Noti.reloadForDeleteBlock),
            object: nil
        )
        
        // 블럭 편집 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(reloadForUpdateBlock),
            name: NSNotification.Name(Noti.reloadForUpdateBlock),
            object: nil
        )
        
        // 모든 데이터 초기화 observer
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(resetAllData),
            name: .resetAllData,
            object: nil
        )
    }
    
    /// 백그라운드 모드로 진입 후 트래킹 모드를 재시작 합니다.
    @objc private func restartTrackingMode(_ notification: Notification) {
        
        // 1. 트래킹 모드 확인
        let isTracking = UserDefaults.standard.object(forKey: UserDefaultsKey.isTracking) as? Bool ?? false
        let isPause = UserDefaults.standard.object(forKey: UserDefaultsKey.isPause) as? Bool ?? false
        
        print("isTracking: \(isTracking)")
        print("isPause: \(isPause)")
        
        // 2. 트래킹 모드 진행 중일 시 실행
        if isTracking && !isPause {
            
            print("트래킹 모드 재실행\n")
            
            // 타이머 재시작
            timerManager.trackingTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(trackingEverySecond), userInfo: nil, repeats: true)
            
            // 3. 시간 확인
            let latestTime = notification.userInfo?["time"] as? Int ?? 0 // 마지막 todaySeconds와 같음.
            let currentTime = Int(TrackingDataStore.shared.todaySecondsToString())!
            let elapsedTime = currentTime - latestTime
            
            print("음 \(elapsedTime)초가 지났군") 
            
            // 4. 시간 업데이트
            timerManager.totalTime += elapsedTime
            timerManager.currentTime += Float(elapsedTime)
            
            // 4-1. 0.5개 이상의 블럭이 생산된 경우
            if timerManager.currentTime > Float(trackingData.targetSecond) {
                let count = Int(timerManager.currentTime / Float(trackingData.targetSecond))
                timerManager.currentTime -= Float(trackingData.targetSecond) * Float(count)
                
                for _ in 1...count {
                    
                    // 4-2. 생산 블럭 업데이트
                    timerManager.totalBlock += 0.5
                    
                    // 4-3. 그동안 트래킹 되었던 데이터 추가
                    trackingData.appendDataBetweenBackground()
                }
                
                // 5. 생산 블럭량 라벨 업데이트
                viewManager.updateCurrentProductivityLabel(timerManager.totalBlock)
                
                // 6. 트래킹 보드 애니메이션 업데이트
                viewManager.trackingBlockPreview.refreshAnimation(trackingData.trackingBlocks(), color: groupData.focusColor())
            }
            
            // 7. 타이머 및 프로그레스 바 UI 업데이트
            viewManager.updateTracking(time: timerManager.format, progress: timerManager.progressPercent())
        }
    }
    
    /// 블럭 편집 Noti를 받았을 때 블럭을 편집 후 리로드합니다.
    /// - Post : EditGroupViewController
    ///
    /// - Parameter notification: 블럭 편집 Notification
    @objc private func reloadForUpdateBlock(_ notification: Notification) {
        let currentGroup = groupData.focusEntity()
        viewManager.groupSelectButton.label.text = currentGroup.name
        viewManager.groupSelectButton.color.backgroundColor = UIColor(rgb: currentGroup.color)
        viewManager.blockCollectionView.reloadData()
    }
    
    /// 블럭 삭제 Notification을 받았을 때 그룹 내 블럭 선택값을 초기화합니다.
    /// - Post : EditGroupViewController
    ///
    /// - Parameter notification: 블럭 삭제 Notification
    @objc private func reloadForDeleteBlock(_ notification: Notification) {
        switchHomeGroup(index: 0)
    }
    
    /// 모든 데이터 초기화 Notification을 받았을 때 그룹 내 블럭 선택값을 초기화합니다.
    /// - Post : ResetDataViewController
    ///
    /// - Parameter notification: 블럭 삭제 Notification
    @objc private func resetAllData(_ notification: Notification) {
        switchHomeGroup(index: 0)
    }
}
