//
//  RepositoryToolTip.swift
//  DayBlock
//
//  Created by 김민준 on 1/7/24.
//

import UIKit

final class RepositoryToolTipViewController: UIViewController {
    
    let viewManager = RepositoryView()
    
    let calendarToolTip = ToolTip(text: "블럭이 다양해질수록 날짜 셀의 모양도 변해요", tipDirection: .bottom, tipStartX: 127)
    let totalToolTip = ToolTip(text: "얼마나 블럭을 생산했는지 나타내요", tipDirection: .bottom, tipStartX: 160)
    let shareToolTip = ToolTip(text: "하루 기준 생산 블럭의 점유율을 나타내요", tipStartX: 160)
    
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
            viewManager.scrollView,
            viewManager.contentView,
            viewManager.noTrackingLabelView
        ].forEach {
            $0.alpha = 0
        }
    }
    
    @objc func dismissToolTip() {
        dismiss(animated: true)
    }
    
    private func setupAutoLayout() {
        viewManager.backgroundColor = Color.mainText.withAlphaComponent(0.4)
        
        [
            calendarToolTip,
            totalToolTip,
            shareToolTip
        ].forEach {
            view.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            calendarToolTip.topAnchor.constraint(equalTo: viewManager.calendarView.todayButton.bottomAnchor, constant: 20),
            calendarToolTip.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            calendarToolTip.widthAnchor.constraint(equalToConstant: 254),
            
            totalToolTip.bottomAnchor.constraint(equalTo: viewManager.timeLineView.shareTotalInfo.totalValue.topAnchor, constant: 20),
            totalToolTip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            totalToolTip.widthAnchor.constraint(equalToConstant: 200),
            
            shareToolTip.topAnchor.constraint(equalTo: viewManager.timeLineView.shareTotalInfo.shareValue.bottomAnchor, constant: 40),
            shareToolTip.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -72),
            shareToolTip.widthAnchor.constraint(equalToConstant: 230)
        ])
    }
}
