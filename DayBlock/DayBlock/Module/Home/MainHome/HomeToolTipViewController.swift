//
//  HomeToolTipViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/28/23.
//

import UIKit

final class HomeToolTipViewController: UIViewController {
    
    let viewManager = HomeView()
    let trackingBoardToolTip = ToolTip(text: "현재 생산 중인 블럭은 깜빡거려요", tipStartX: 136)
    let longPressToolTip = ToolTip(text: "블럭을 길게 누르면 생산이 완료돼요", tipStartX: 104)
    let progressBarToolTip = ToolTip(text: "현재 세션의 진행도를 나타내요", tipStartX: 60)
    
    // MARK: - Life Cycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideComponent()
        setupAutoLayout()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissToolTip))
        view.addGestureRecognizer(tapGesture)
    }
    
    @objc func dismissToolTip() {
        dismiss(animated: true)
    }
    
    private func hideComponent() {
        [
            viewManager.groupSelectButton,
            viewManager.dateLabel,
            viewManager.timeLabel,
            viewManager.productivityLabel,
            viewManager.trackingBoard,
            viewManager.blockCollectionView,
            viewManager.trackingBlock,
            viewManager.messageLabel,
            viewManager.trackingTimeLabel,
            viewManager.trackingProgressView,
            viewManager.trackingButton,
            viewManager.warningToastView,
            viewManager.infoToastView,
            viewManager.tabBarStackView
        ].forEach {
            $0.alpha = 0
        }
    }
    
    private func setupAutoLayout() {
        viewManager.backgroundColor = Color.mainText.withAlphaComponent(0.4)
        
        [trackingBoardToolTip,
         longPressToolTip,
         progressBarToolTip
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        // 기기별 사이즈 대응을 위한 분기
        let deviceHeight = UIScreen.main.deviceHeight
        
        switch deviceHeight {
        case .small:
            progressBarToolTip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -80).isActive = true
        case .middle:
            progressBarToolTip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -112).isActive = true
        case .large:
            progressBarToolTip.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -156).isActive = true
        }
        
        NSLayoutConstraint.activate([
            trackingBoardToolTip.topAnchor.constraint(equalTo: viewManager.trackingBoard.bottomAnchor, constant: 12),
            trackingBoardToolTip.trailingAnchor.constraint(equalTo: viewManager.trackingBoard.trailingAnchor),
            trackingBoardToolTip.widthAnchor.constraint(equalToConstant: 200),
            
            longPressToolTip.topAnchor.constraint(equalTo: viewManager.trackingBlock.bottomAnchor, constant: 12),
            longPressToolTip.centerXAnchor.constraint(equalTo: viewManager.trackingBlock.centerXAnchor),
            longPressToolTip.widthAnchor.constraint(equalToConstant: 210),
            
            progressBarToolTip.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 32),
            progressBarToolTip.widthAnchor.constraint(equalToConstant: 180)
        ])
    }
}
