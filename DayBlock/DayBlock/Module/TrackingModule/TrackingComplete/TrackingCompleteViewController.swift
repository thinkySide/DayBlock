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
    }
    
    // MARK: - Setup Method
    
    private func setupUI() {
        viewManager.iconBlock.backgroundColor = groupData.focusColor()
        viewManager.iconBlock.symbol.image = UIImage(systemName: blockData.focusEntity().icon)
        viewManager.taskLabel.text = blockData.focusEntity().taskLabel
        
        viewManager.dateLabel.text = trackingData.focusDateFormat()
        viewManager.timeLabel.text = trackingData.focusTrackingTimeFormat()
        
        viewManager.plusSummaryLabel.textColor = groupData.focusColor()
        viewManager.mainSummaryLabel.text = String(trackingData.focusTrackingBlockCount())
        
        viewManager.trackingBoard.fillBlocks(trackingData.finishTrackingBlocks(), color: groupData.focusColor())
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
