//
//  TrackingCompleteViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteViewController: UIViewController {
    
    enum Mode {
        case tracking
        case onboarding
    }
    
    var mode: Mode
    weak var delegate: TrackingCompleteViewControllerDelegate?
    
    private let viewManager = TrackingCompleteView()
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    private let trackingData = TrackingDataStore.shared
    
    // MARK: - Life Cycle Methods
    
    init(mode: Mode) {
        self.mode = mode
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        trackingCompleteAnimation()
    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        
        // 아이콘
        viewManager.iconBlock.backgroundColor = groupData.focusColor()
        viewManager.iconBlock.symbol.image = UIImage(systemName: blockData.focusEntity().icon)
        
        // 작업명
        viewManager.taskLabel.text = blockData.focusEntity().taskLabel
        
        // 날짜 및 시간 라벨
        viewManager.dateLabel.text = trackingData.focusDateFormat()
        viewManager.timeLabel.text = trackingData.focusTrackingTimeFormat()
        
        // 생산량 라벨
        viewManager.plusSummaryLabel.textColor = groupData.focusColor()
        viewManager.mainSummaryLabel.text = String(trackingData.focusTrackingBlockCount())
        
        // 트래킹 보드
        let color = groupData.focusColor()
        print("finishTrackingBlocks: \(trackingData.finishTrackingBlocks())")
        viewManager.trackingBoard.trackingCompleteAndFill(trackingData.finishTrackingBlocks(), color: [color])
        
        // 전체 생산량
        viewManager.totalValue.text = trackingData.totalOutput(blockData.focusEntity())
        
        // 오늘 생산량
        viewManager.todayValue.text = trackingData.todayOutput(blockData.focusEntity())
        
        // 체크 심볼
        viewManager.checkSymbol.tintColor = groupData.focusColor()
    }
    
    private func setupEvent() {
        viewManager.backToHomeButton.addTarget(self, action: #selector(backToHomeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
    /// 트래킹 종료 애니메이션 실행 메서드입니다.
    func trackingCompleteAnimation() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3) {
                self.viewManager.animationEnd()
            }
        }
    }
    
    /// 홈 화면으로 돌아가기 버튼 탭 시 호출되는 메서드입니다.
    @objc func backToHomeButtonTapped() {
        
        // 트래킹 모드
        if mode == .tracking {
            delegate?.trackingCompleteVC(backToHomeButtonTapped: self)
            dismiss(animated: true)
            return
        }
        
        // 온보딩 모드
        if mode == .onboarding {
            NotificationCenter.default.post(name: .finishOnboarding, object: self, userInfo: nil)
            return
        }
    }
}
