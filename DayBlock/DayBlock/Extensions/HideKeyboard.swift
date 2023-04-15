//
//  HideKeyboard.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/15.
//

import UIKit

/// 화면 터치 시 키보드 내리기
extension UIViewController {
    
    func hideKeyboard() {
        let tap = UITapGestureRecognizer(target: self, action: #selector(dismissKeyboard))
        tap.cancelsTouchesInView = false
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
