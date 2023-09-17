//
//  UIButton++.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/09.
//

import UIKit

extension UIButton {

    /// UIButton의 BackgroundColor를 설정합니다.
    ///
    /// - Parameter color: 설정할 컬러
    /// - Parameter state: 컬러가 설정될 버튼의 상태값(기본값: .normal)
    func setBackgroundColor(_ color: UIColor, for state: UIControl.State = .normal) {
        UIGraphicsBeginImageContext(CGSize(width: 1.0, height: 1.0))
        guard let context = UIGraphicsGetCurrentContext() else { return }
        context.setFillColor(color.cgColor)
        context.fill(CGRect(x: 0.0, y: 0.0, width: 1.0, height: 1.0))

        let backgroundImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        self.setBackgroundImage(backgroundImage, for: state)
    }
}
