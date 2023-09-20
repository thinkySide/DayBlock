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
        if blockManager.getCurrentBlockList().count == 0 {
            viewManager.toggleTrackingButton(false)
        }
    }
    
    func setupTimer() {
        updateDateLabel()
        updateTimeLabel()
        
        // 1초마다 날짜 및 시간 업데이트 하는 타이머 실행
        dateTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTimeLabel), userInfo: nil, repeats: true)
    }
    
    /// 현재 시간을 기준으로 timeLabel을 설정합니다.
    @objc private func updateTimeLabel() {
        let timeFormatter = DateFormatter()
        timeFormatter.locale = Locale(identifier: "ko_KR")
        timeFormatter.dateFormat = "HH:mm"
        viewManager.timeLabel.text = timeFormatter.string(from: Date())
        
        let trackingFormatter = DateFormatter()
        trackingFormatter.locale = Locale(identifier: "ko_KR")
        trackingFormatter.dateFormat = "HH/mm/ss"
        
        // 트래킹 타임 업데이트
        trackingManager.updateTrackingStartTime(trackingFormatter.string(from: Date()))
        
        // 00:00에 날짜 업데이트
        if viewManager.timeLabel.text == "00:00" { updateDateLabel() }
    }
    
    /// 현재 날짜 및 요일을 기준으로 dateLabel을 설정합니다.
    private func updateDateLabel() {
        viewManager.dateLabel.text = trackingManager.dateFormat
    }
    
    /// 1초마다 실행되는 트래킹 메서드입니다.
    @objc func trackingEverySecond() {
        trackingManager.totalTime += 1
        trackingManager.currentTime += 1
        
        // 30분 단위 블럭 추가 및 현재 시간 초기화 (0.5블럭)
        if trackingManager.totalTime % 1800 == 0 {
            trackingManager.totalBlock += 0.5
            viewManager.updateCurrentProductivityLabel(trackingManager.totalBlock)
            trackingManager.currentTime = 0
        }
        
        // TimeLabel & ProgressView 업데이트
        viewManager.updateTracking(time: trackingManager.timeFormatter,
                                   progress: trackingManager.currentTime / 1800)
    }
}

// MARK: - Tracking Board
extension HomeViewController {
    
    /// 트래킹 보드를 활성화하고 애니메이션을 실행합니다.
    func activateTrackingBoard() {
        guard let trackingIndexs = trackingManager.fetchTrackingBlocks()[trackingManager.trackingFormat] else { return }
        let color = blockManager.getCurrentGroupColor()
        viewManager.blockPreview.activateTrackingAnimation(trackingIndexs, color: color)
    }
}

// MARK: - Tracking Complete Method
extension HomeViewController: TrackingCompleteViewControllerDelegate {
    
    /// TrackingCompleteViewController로 Present 합니다.
    func presentTrackingCompleteVC() {
        let trackingCompleteVC = TrackingCompleteViewController()
        trackingCompleteVC.delegate = self
        trackingCompleteVC.modalTransitionStyle = .coverVertical
        trackingCompleteVC.modalPresentationStyle = .overFullScreen
        present(trackingCompleteVC, animated: true)
    }
    
    /// 트래킹 모드 종료 델리게이트
    func endTrackingMode() {
        
        // 블럭 프리뷰 애니메이션 종료
        viewManager.blockPreview.stopTrackingAnimation()
        
        // 블럭 프리뷰 배열 초기화
        viewManager.blockPreview.resetCurrentBlocks()
        
        // 트래킹 Dictionary 초기화
        trackingManager.resetTrackingBlocks()
        
        // 트래킹 모드 종료
        viewManager.switchToHomeMode()
    }
}

// MARK: - Tracking Stop Popup Method
extension HomeViewController {
    
    /// 트래킹 중단 BarButtonItem Tap 이벤트 메서드입니다.
    @objc func trackingStopBarButtonItemTapped(_ sender: UIGestureRecognizer) {
        viewManager.trackingButtonTapped()
        viewManager.blockPreview.pausedTrackingAnimation()
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
        endTrackingMode()
    }
    
    /// 트래킹 중단 팝업 - "아니오" 버튼 탭 메서드입니다.
    @objc private func trackingStopPopupCancelButtonTapped() {
        viewManager.trackingButtonTapped()
    }
}
