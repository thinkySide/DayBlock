//
//  MyPageView.swift
//  DayBlock
//
//  Created by 김민준 on 12/13/23.
//

import UIKit

final class MyPageView: UIView {
    
    let settingData = SettingDataStore()
    
    let scrollView: UIScrollView = {
        let scroll = UIScrollView()
        scroll.showsVerticalScrollIndicator = false
        return scroll
    }()
    
    var contentView: UIView = {
        let view = UIView()
        view.backgroundColor = UIColor(rgb: 0xF7F7F7)
        return view
    }()
    
    let totalTodayBurningView = TotalTodayBurningView()
    
    lazy var usageSettingView = SettingView(rowCount: settingData.usageData().count)
    lazy var developerSettingView = SettingView(rowCount: settingData.developerData().count)
    
    let versionInfo = InfoCellView(tagLabel: "버전", valueLabel: "0.1")
    
    let tabBarStackView = TabBar(location: .myPage)
    
    let toastView: ToastMessage = {
        let view = ToastMessage(state: .complete)
        view.messageLabel.text = "초기화 작업이 완료되었습니다"
        view.alpha = 0
        return view
    }()
    
    // MARK: - Initial Method
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = .white
        setupAutoLayout()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setupAutoLayout() {
        addSubview(scrollView)
        scrollView.addSubview(contentView)
        addSubview(tabBarStackView)
        addSubview(toastView)
        
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        contentView.translatesAutoresizingMaskIntoConstraints = false
        tabBarStackView.translatesAutoresizingMaskIntoConstraints = false
        toastView.translatesAutoresizingMaskIntoConstraints = false
        
        [totalTodayBurningView, usageSettingView, developerSettingView, versionInfo].forEach {
            contentView.addSubview($0)
            $0.translatesAutoresizingMaskIntoConstraints = false
        }
        
        NSLayoutConstraint.activate([
            scrollView.topAnchor.constraint(equalTo: topAnchor),
            scrollView.bottomAnchor.constraint(equalTo: tabBarStackView.topAnchor),
            scrollView.leadingAnchor.constraint(equalTo: leadingAnchor),
            scrollView.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            contentView.topAnchor.constraint(equalTo: scrollView.topAnchor),
            contentView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor),
            contentView.widthAnchor.constraint(equalTo: scrollView.widthAnchor),
            contentView.bottomAnchor.constraint(equalTo: versionInfo.bottomAnchor, constant: 0),
            
            totalTodayBurningView.topAnchor.constraint(equalTo: contentView.topAnchor),
            totalTodayBurningView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            totalTodayBurningView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            usageSettingView.topAnchor.constraint(equalTo: totalTodayBurningView.bottomAnchor, constant: 12),
            usageSettingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            usageSettingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            developerSettingView.topAnchor.constraint(equalTo: usageSettingView.bottomAnchor, constant: 12),
            developerSettingView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor),
            developerSettingView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            
            versionInfo.topAnchor.constraint(equalTo: developerSettingView.bottomAnchor),
            versionInfo.leadingAnchor.constraint(equalTo: leadingAnchor),
            versionInfo.trailingAnchor.constraint(equalTo: trailingAnchor),
            
            tabBarStackView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor),
            tabBarStackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            tabBarStackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            tabBarStackView.heightAnchor.constraint(equalToConstant: 2),
            
            toastView.centerXAnchor.constraint(equalTo: centerXAnchor),
            toastView.bottomAnchor.constraint(equalTo: safeAreaLayoutGuide.bottomAnchor, constant: -20)
        ])
    }
}
