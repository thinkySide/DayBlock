//
//  TrackingCompleteToolTip.swift
//  DayBlock
//
//  Created by 김민준 on 1/10/24.
//

import UIKit

final class TrackingCompleteToolTip: UIViewController {
    
    let viewManager = TrackingCompleteView()
    
    let timeToolTip = ToolTip(text: "트래킹 날짜 및 시간을 나타내요", tipDirection: .bottom, tipStartX: 84)
    let outputToolTip = ToolTip(text: "생산한 블럭 개수를 나타내요", tipStartX: 78)
    let memoToolTip = ToolTip(text: "트래킹 후 메모를 작성할 수 있어요", tipDirection: .bottom, tipStartX: 92)
    
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
            viewManager.animationCircle, viewManager.checkSymbol, viewManager.checkLabel,
            viewManager.iconBlock,
            viewManager.groupLabel,
            viewManager.taskLabel,
            viewManager.dashedSeparator,
            viewManager.dateLabel,
            viewManager.timeLabel,
            viewManager.summaryLabel,
            viewManager.trackingBoard,
            viewManager.memoTextView
        ].forEach {
            $0.alpha = 0
        }
    }
    
    @objc func dismissToolTip() {
        dismiss(animated: true)
    }
    
    private func setupAutoLayout() {
        viewManager.backgroundColor = Color.mainText.withAlphaComponent(0.4)
        
        [timeToolTip,
         outputToolTip,
         memoToolTip
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            timeToolTip.bottomAnchor.constraint(equalTo: viewManager.dateLabel.topAnchor, constant: -12),
            timeToolTip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            timeToolTip.widthAnchor.constraint(equalToConstant: 180),
            
            outputToolTip.topAnchor.constraint(equalTo: viewManager.mainSummaryLabel.bottomAnchor, constant: 8),
            outputToolTip.centerXAnchor.constraint(equalTo: viewManager.mainSummaryLabel.centerXAnchor),
            outputToolTip.widthAnchor.constraint(equalToConstant: 168),
            
            memoToolTip.bottomAnchor.constraint(equalTo: viewManager.memoPlaceHolder.topAnchor, constant: -24),
            memoToolTip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            memoToolTip.widthAnchor.constraint(equalToConstant: 192)
        ])
    }
}
