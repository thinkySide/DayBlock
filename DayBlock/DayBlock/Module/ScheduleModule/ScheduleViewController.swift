//
//  ScheduleViewController.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/02.
//

import UIKit

final class ScheduleViewController: UIViewController {
    
    let groupData = GroupDataStore.shared
    let blockData = BlockDataStore.shared
    let trackingData = TrackingDataStore.shared
    
    private let testLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont(name: Pretendard.semiBold, size: 16)
        label.textColor = Color.mainText
        label.textAlignment = .center
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private lazy var testButton: UIButton = {
        let button = UIButton()
        button.addTarget(self, action: #selector(testButtonTapped), for: .touchUpInside)
        button.setTitle("데이터 리로드", for: .normal)
        button.backgroundColor = .systemBlue
        button.tintColor = .white
        button.clipsToBounds = true
        button.layer.cornerRadius = 28
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // test layout
        view.backgroundColor = .white
        view.addSubview(testLabel)
        view.addSubview(testButton)
        NSLayoutConstraint.activate([
            testLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            testLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            testLabel.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 32),
            testLabel.bottomAnchor.constraint(equalTo: testButton.topAnchor, constant: -16),
            
            testButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            testButton.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -88),
            testButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            testButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            testButton.heightAnchor.constraint(equalToConstant: 56)
        ])
        
        testButtonTapped()
    }
    
    @objc func testButtonTapped() {
        print(#function)
        var testText = ""
        
        if let trackingDateList = blockData.focusEntity().trackingDateList?.array as? [TrackingDate] {
            if let trackingTimeList = trackingDateList.last?.trackingTimeList?.array as? [TrackingTime] {
                for (index, time) in trackingTimeList.enumerated() {
                    testText += "\(time.superDate.month)월 \(time.superDate.day)일 \(index)번째 데이터\n"
                    if let endTime = time.endTime {
                        let startHour = Int(time.startTime)! / 3600
                        let startMinute = ((Int(time.startTime)!) - (3600 * startHour)) / 60
                        let startSecond = ((Int(time.startTime)!) - (3600 * startHour)) % 60
                        let endHour = Int(endTime)! / 3600
                        let endMinute = (Int(endTime)! - (3600 * endHour)) / 60
                        let endSecond = (Int(endTime)! - (3600 * endHour)) % 60
                        testText += "\(startHour)시 \(startMinute)분 \(startSecond)초 ~ \(endHour)시 \(endMinute)분 \(endSecond)초\n\n"
                    }
                }
                testLabel.text = testText
            } else {
                testLabel.text = "가장 최근에 트래킹 된 데이터가 없습니다."
            }
        }
    }
}
