//
//  HideKeyboard.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/15.
//

import UIKit

extension UIViewController {
    
    // 화면 터치 시 키보드 내리기
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    // 실제 키보드 내리는 메서드
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
