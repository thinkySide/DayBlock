//
//  TrackingCompleteViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/08/23.
//

import UIKit

final class TrackingCompleteViewController: UIViewController {
    
    weak var delegate: TrackingCompleteViewControllerDelegate?
    private let viewManager = TrackingCompleteView()
    private let groupData = GroupDataStore.shared
    private let blockData = BlockDataStore.shared
    private let trackingData = TrackingDataStore.shared
    
    // MARK: - Life Cycle Method
    
    override func loadView() {
        super.loadView()
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupEvent()
        
        /// 애니메이션
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) {
            UIView.animate(withDuration: 0.3) {
                self.viewManager.animationEnd()
            }
        }
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
        viewManager.trackingBoard.fillBlocks(trackingData.finishTrackingBlocks(), color: groupData.focusColor())
        // viewManager.trackingBoard.fillBlocks(["00:00", "01:00", "01:30", "02:00", "03:30"], color: groupData.focusColor())
        
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
    
    @objc func backToHomeButtonTapped() {
        delegate?.trackingCompleteVC(backToHomeButtonTapped: self)
        dismiss(animated: true)
    }
}
