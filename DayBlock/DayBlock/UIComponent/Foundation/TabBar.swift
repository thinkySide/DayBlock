//
//  TabBar.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/04.
//

import UIKit

/// 커스텀 탭바 컴포넌트
final class TabBar: UIStackView {

    /// 현재 탭바의 위치
    enum Location {
        case tracking
        case schedule
        case repository
    }

    // MARK: - Component

    /// 트래킹 탭(Main)
    private let tracking: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainText
        view.alpha = 1
        return view
    }()

    /// 계획표 탭
    private let schedule: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainText
        view.alpha = 0
        return view
    }()

    /// 저장소 탭
    private let repository: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainText
        view.alpha = 0
        return view
    }()

    // MARK: - Event Method

    /// 탭바 전환 이펙트를 실행합니다.
    ///
    /// - Parameter tab: 전환할 탭
    func switchEffect(to tab: Location) {
        switch tab {
        case .tracking:
            tracking.alpha = 1
            schedule.alpha = 0
            repository.alpha = 0
        case .schedule:
            tracking.alpha = 0
            schedule.alpha = 1
            repository.alpha = 0
        case .repository:
            tracking.alpha = 0
            schedule.alpha = 0
            repository.alpha = 1
        }
    }

    // MARK: - Initial Method

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(rgb: 0xF7F7F7)

        axis = .horizontal
        distribution = .fillEqually
        alignment = .fill
        spacing = 0

        addArrangedSubview(tracking)
        addArrangedSubview(schedule)
        addArrangedSubview(repository)
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
