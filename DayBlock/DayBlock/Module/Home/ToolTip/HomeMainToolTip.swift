//
//  HomeMainToolTip.swift
//  DayBlock
//
//  Created by 김민준 on 1/6/24.
//

import UIKit

final class HomeMainToolTipViewController: UIViewController {
    
    let viewManager = HomeView()
    
    let trackingBoardToolTip = ToolTip(text: "오늘 생산한 블럭을 나타내요", tipStartX: 102)
    let groupSelectButtonToolTip = ToolTip(text: "그룹 간 전환이 가능한 버튼이에요", tipStartX: 98)
    let collectionViewToolTip = ToolTip(text: "좌우로 스와이프 해 블럭을 전환할 수 있어요", tipStartX: 124)
    let trackingButtonToolTip = ToolTip(text: "트래킹 시작 / 일시정지 버튼이에요", tipStartX: 96)
    
    // MARK: - Life Cycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupAutoLayout()
        hideComponent()
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(dismissToolTip))
        view.addGestureRecognizer(tapGesture)
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
    
    @objc func dismissToolTip() {
        dismiss(animated: true)
    }
    
    private func setupAutoLayout() {
        viewManager.backgroundColor = Color.mainText.withAlphaComponent(0.4)
        
        [trackingBoardToolTip,
         groupSelectButtonToolTip,
         collectionViewToolTip,
         trackingButtonToolTip
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            trackingBoardToolTip.topAnchor.constraint(equalTo: viewManager.trackingBoard.bottomAnchor, constant: 12),
            trackingBoardToolTip.trailingAnchor.constraint(equalTo: viewManager.trackingBoard.trailingAnchor),
            trackingBoardToolTip.widthAnchor.constraint(equalToConstant: 170),
            
            groupSelectButtonToolTip.topAnchor.constraint(equalTo: viewManager.groupSelectButton.bottomAnchor, constant: 6),
            groupSelectButtonToolTip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            groupSelectButtonToolTip.widthAnchor.constraint(equalToConstant: 196),
            
            collectionViewToolTip.topAnchor.constraint(equalTo: viewManager.blockCollectionView.bottomAnchor, constant: 12),
            collectionViewToolTip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            collectionViewToolTip.widthAnchor.constraint(equalToConstant: 250),
            
            trackingButtonToolTip.topAnchor.constraint(equalTo: viewManager.trackingButton.bottomAnchor, constant: 12),
            trackingButtonToolTip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            trackingButtonToolTip.widthAnchor.constraint(equalToConstant: 200)
        ])
    }
}
