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
        case calendar
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
        
        // 캘린더 모드라면 바로 정보 표시
        if mode == .calendar {
            viewManager.completeAnimation()
            return
        }
        
        // 애니메이션 출력
        DispatchQueue.main.async {
            self.viewManager.circleAnimation()
        }
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        
        // 캘린더 모드라면 해당 UI 업데이트 사용 X
        if mode == .calendar { return }
        
        // 애니메이션 컬러
        viewManager.animationCircle.backgroundColor = groupData.focusColor()
        
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
        viewManager.trackingBoard.trackingCompleteAndFill(trackingData.finishTrackingBlocks(), color: [color])
        
        // 전체 생산량
        viewManager.totalValue.text = trackingData.totalOutput(blockData.focusEntity())
        
        // 오늘 생산량
        viewManager.todayValue.text = trackingData.todayOutput(blockData.focusEntity())
    }
    
    /// 캘린더 모드에서의 UI를 설정합니다.
    func setupCalendarMode(icon: String, color: Int, taskLabel: String, currentDate: String, trackingTime: String, output: String, trackingBlocks: [String]) {
        
        let color = UIColor(rgb: color)
        
        // AutoLayout
        viewManager.topConstraint.constant = 96
        
        // 아이콘
        viewManager.iconBlock.backgroundColor = color
        viewManager.iconBlock.symbol.image = UIImage(systemName: icon)
        
        // 작업명
        viewManager.taskLabel.text = taskLabel
        
        // 날짜 및 시간 라벨
         viewManager.dateLabel.text = currentDate
        viewManager.timeLabel.text = trackingTime
        
        // 생산량 라벨
        viewManager.plusSummaryLabel.textColor = color
        viewManager.mainSummaryLabel.text = output
        
        // 트래킹 보드
        viewManager.trackingBoard.trackingCompleteAndFill(trackingBlocks, color: [color])
        
        // total, today, 버튼 숨기기
        [viewManager.totalValue, viewManager.totalLabel,
         viewManager.todayValue, viewManager.todayLabel,
         viewManager.bottomSeparator, viewManager.backToHomeButton].forEach { $0.isHidden = true }
    }
    
    private func setupEvent() {
        viewManager.backToHomeButton.addTarget(self, action: #selector(backToHomeButtonTapped), for: .touchUpInside)
    }
    
    // MARK: - Event Method
    
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
        
        // 캘린더 모드
        if mode == .calendar {
            dismiss(animated: true)
            return
        }
    }
}
