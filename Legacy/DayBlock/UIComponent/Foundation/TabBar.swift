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
        case calendar
        case manage
        case myPage
    }

    // MARK: - Component

    /// 트래킹 탭(Main)
    private let tracking: UIView = {
        let view = UIView()
        view.backgroundColor = Color.mainText
        view.alpha = 1
        return view
    }()

    /// 관리소 탭
    private let manage: UIView = {
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

    // MARK: - Initial Method

    init(location: Location) {
        super.init(frame: .zero)
        backgroundColor = .white

        axis = .horizontal
        distribution = .fillProportionally
        alignment = .fill
        spacing = 32
        alpha = 0 // 임시로 가려놓기

        addArrangedSubview(tracking)
        addArrangedSubview(manage)
        addArrangedSubview(repository)
        
        switch location {
        case .tracking:
            tracking.alpha = 1
            manage.alpha = 0
            repository.alpha = 0
            
        case .calendar:
            tracking.alpha = 0
            manage.alpha = 0
            repository.alpha = 1
            
        case .manage:
            tracking.alpha = 0
            manage.alpha = 1
            repository.alpha = 0
            
        case .myPage:
            break
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
