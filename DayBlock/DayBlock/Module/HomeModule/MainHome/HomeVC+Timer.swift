//
//  HomeVC+Tracking.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/19.
//

import UIKit

// MARK: - Setup Timer
extension HomeViewController {
    
    /// 트래킹 시작 버튼의 초기값을 설정합니다.
    func initialTrackingStartButton() {
        if blockData.list().count == 0 {
            viewManager.toggleTrackingButton(false)
        }
    }
    
    /// 타이머를 세팅합니다.
    func setupTimer() {
        updateDateLabel()
        updateTimeLabel()
        
        // 1초마다 날짜 및 시간 업데이트 하는 타이머 실행
        timerManager.dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    /// 현재 시간을 기준으로 timeLabel을 설정합니다.
    @objc private func updateTimeLabel() {
        viewManager.timeLabel.text = trackingData.timeLabel()
        
        // 00:00에 날짜 업데이트
        if viewManager.timeLabel.text == "00:00" { updateDateLabel() }
    }
    
    /// 현재 날짜 및 요일을 기준으로 dateLabel을 설정합니다.
    private func updateDateLabel() {
        viewManager.dateLabel.text = trackingData.dateLabel()
    }
    
    /// 트래커를 초기화합니다.
    func resetTracker() {
        
        // 1. 타이머 비활성화
        timerManager.trackingTimer?.invalidate()
        
        // 2. UI 및 트래커 초기화
        viewManager.updateTracking(time: "00:00:00", progress: 0)
        timerManager.reset()
        
        // 3. ouput 라벨 초기화
        viewManager.trackingBlock.outputLabel.text = "0.0"
        
        // 4. 화면 꺼짐 해제
        isScreenCanSleep(true)
    }
}

// MARK: - Tracking Board
extension HomeViewController {
    
    /// 트래킹 보드를 업데이트하고 애니메이션을 실행합니다.
    func updateTrackingBoard(isPaused: Bool) {
        let currentBlocks = trackingData.trackingBlocks()
        let currentColor = groupData.focusColor()
        viewManager.blockPreview.updateTrackingAnimation(currentBlocks, color: currentColor, isPaused: isPaused)
    }
}

// MARK: - Tracking Complete Method
extension HomeViewController {
    
    /// TrackingCompleteViewController로 Present 합니다.
    func presentTrackingCompleteVC() {
        let trackingCompleteVC = TrackingCompleteViewController()
        trackingCompleteVC.delegate = self
        trackingCompleteVC.modalTransitionStyle = .coverVertical
        trackingCompleteVC.modalPresentationStyle = .overFullScreen
        present(trackingCompleteVC, animated: true)
    }
}

// MARK: - Tracking Stop Popup Method
extension HomeViewController {
    
    /// 트래킹 중단 BarButtonItem Tap 이벤트 메서드입니다.
    @objc func trackingStopBarButtonItemTapped(_ sender: UIGestureRecognizer) {
        presentStopTrackingPopup()
    }
    
    /// 트래킹 중단 팝업을 Present합니다.
    func presentStopTrackingPopup() {
        let popup = PopupViewController()
        popup.modalPresentationStyle = .overCurrentContext
        popup.modalTransitionStyle = .crossDissolve
        popup.deletePopupView.mainLabel.text = "블럭 생산을 중단할까요?"
        popup.deletePopupView.subLabel.text = "지금까지 생산한 블럭이 모두 사라져요."
        popup.deletePopupView.actionStackView.confirmButton.setTitle("중단할래요", for: .normal)
        
        popup.deletePopupView.actionStackView.confirmButton.addTarget(self, action: #selector(trackingStopPopupConfirmButtonTapped), for: .touchUpInside)
        popup.deletePopupView.actionStackView.cancelButton.addTarget(self, action: #selector(trackingStopPopupCancelButtonTapped), for: .touchUpInside)
        
        self.present(popup, animated: true)
    }
    
    /// 트래킹 중단 팝업 - "중단할래요" 버튼 탭 메서드입니다.
    @objc private func trackingStopPopupConfirmButtonTapped() {
        viewManager.stopTrackingMode()
    }
    
    /// 트래킹 중단 팝업 - "아니오" 버튼 탭 메서드입니다.
    @objc private func trackingStopPopupCancelButtonTapped() {
        //
    }
}
