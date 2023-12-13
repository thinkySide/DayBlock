//
//  MyPageViewController.swift
//  DayBlock
//
//  Created by 김민준 on 12/12/23.
//

import UIKit

final class MyPageViewController: UIViewController {
    
    let viewManager = MyPageView()
    let trackingData = TrackingDataStore.shared
    
    // MARK: - ViewController LifeCycle
    override func loadView() {
        view = viewManager
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
    }
    
    // MARK: - Setup Method
    private func setupUI() {
        
        /// 지금까지 생산한 총 생산량 + 오늘의 생산량 + 연속일
        viewManager.totalInfoIcon.valueLabel.text = trackingData.totalOutput()
        viewManager.todayInfoIcon.valueLabel.text = trackingData.todayAllOutput()
        viewManager.burningInfoIcon.valueLabel.text = trackingData.burningCount()
    }
}
