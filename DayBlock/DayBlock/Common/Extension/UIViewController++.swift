//
//  UIViewController++.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/15.
//

import UIKit

extension UIViewController {

    /// 화면 터치 시 키보드가 내려가는 제스처를 추가합니다.
    func addHideKeyboardGesture() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }

    /// View의 편집모드를 종료합니다.(키보드 내리기)
    @objc private func dismissKeyboard() {
        view.endEditing(true)
    }
}
