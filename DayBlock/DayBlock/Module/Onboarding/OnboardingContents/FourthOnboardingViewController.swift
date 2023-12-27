//
//  FourthOnboardingViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/15/23.
//

import UIKit

final class FourthOnboardingViewController: UIViewController {
    
    var mode: OnboardingViewController.Mode
    
    private let viewManager = FourthOnboardingView()
    private let trackingData = TrackingDataStore.shared
    
    // MARK: - ViewController LifeCycle
    init(mode: OnboardingViewController.Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureBlockLongPressGesture()
    }
    
    // MARK: - Long Press Gesture Method
    
    /// 트래킹 블럭의 Long Press 제스처를 설정합니다.
    private func configureBlockLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(trackingBlockLongPressed))
        longPressGesture.minimumPressDuration = 0.1
        viewManager.trackingBlock.addGestureRecognizer(longPressGesture)
        viewManager.trackingBlock.delegate = self
    }
    
    /// 트래킹 블럭 Long Press Gestrue 실행 메서드입니다.
    @objc func trackingBlockLongPressed(_ gesture: UILongPressGestureRecognizer) {
        let block = viewManager.trackingBlock
        let state = gesture.state
        if state == .began { block.longPressAnimation(isFill: true) }
        else if state == .ended || state == .cancelled { block.longPressAnimation(isFill: false) }
    }
}

// MARK: - DayBlock Delegate
extension FourthOnboardingViewController: DayBlockDelegate {
    
    /// LongPressGesutre 이후 호출되는 메서드입니다.
    func dayBlock(_ dayBlock: DayBlock, trackingComplete taskLabel: String?) {
        
        // 트래킹 코어데이터 저장
        trackingData.createOnboardingData()
        
        // 트래킹 블럭 업데이트
        trackingData.appendCurrentTimeInTrackingBlocksForOnboarding()
        
        // 온보딩 종료로 판단(UserDefaults 업데이트)
        UserDefaultsItem.shared.setIsFirstLaunch(to: false)
        
        // Push
        presentTrackingCompleteVC()
        Vibration.success.vibrate()
    }
    
    /// TrackingCompleteViewController로 Present 합니다.
    func presentTrackingCompleteVC() {
        let trackingCompleteVC = TrackingCompleteViewController(mode: .onboarding)
        trackingCompleteVC.modalTransitionStyle = .crossDissolve
        trackingCompleteVC.modalPresentationStyle = .overFullScreen
        present(trackingCompleteVC, animated: true)
    }
}
