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
    
    /// 화면 자동 꺼짐을 활성 / 비활성화 합니다.
    ///
    /// - Parameter bool: 화면 꺼짐 여부
    func isScreenCanSleep(_ bool: Bool) {
        UIApplication.shared.isIdleTimerDisabled = !bool
    }
    
    /// SFSymbol Bounce 애니메이션을 시작합니다.
    func startSFSymbolBounceAnimation(_ symbol: UIImageView) {
        if #available(iOS 17.0, *) {
            symbol.addSymbolEffect(.bounce, options: .speed(0.3).repeating)
        }
    }
    
    /// SFSymbol 애니메이션을 종료합니다.
    func stopSFSymbolAnimation(_ symbol: UIImageView) {
        if #available(iOS 17.0, *) {
            symbol.removeAllSymbolEffects()
        }
    }
    
    /// 토스트 메시지를 출력하는 메서드
    func showToast(toast: ToastMessage, isActive active: Bool) {
    
        // 중복 클릭에 의한 불필요한 Dispatch 대기열 삭제
        toastWorkItem?.cancel()
        
        // 토스트 활성화
        if active {
            UIView.animate(withDuration: 0.2) { toast.alpha = 1 }
            
            // 2초 뒤 비활성화
            toastWorkItem = DispatchWorkItem {
                UIView.animate(withDuration: 0.2) { toast.alpha = 0 }
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now()+3, execute: toastWorkItem!)
            return
        }
        
        // 토스트 비활성화
        if !active {
            UIView.animate(withDuration: 0.2) { toast.alpha = 0 }
        }
    }
    
    /// UIView에 UITapGesture를 추가합니다.
    ///
    /// - Parameter component: 제스처를 추가할 UIView
    /// - Parameter target: 제스처가 동작할 타겟
    /// - Parameter action: 제스처 동작 메서드
    func addTapGesture<T: UIView>(_ component: T, target: Any?, action: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: action)
        component.addGestureRecognizer(gesture)
    }
    
    /// UILabel에 UITapGesture를 추가합니다.
    ///
    /// - Parameter component: 제스처를 추가할 UILabel
    /// - Parameter target: 제스처가 동작할 타겟
    /// - Parameter action: 제스처 동작 메서드
    func addTapGesture<T: UILabel>(_ component: T, target: Any?, action: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: action)
        component.addGestureRecognizer(gesture)
    }
    
    /// UIButton에 UITapGesture를 추가합니다.
    ///
    /// - Parameter component: 제스처를 추가할 UIButton
    /// - Parameter target: 제스처가 동작할 타겟
    /// - Parameter action: 제스처 동작 메서드
    func addTapGesture<T: UIButton>(_ component: T, target: Any?, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        component.addGestureRecognizer(gesture)
    }
    
    /// UIBarButtonItem에 UITapGesture를 추가합니다.
    ///
    /// - Parameter component: 제스처를 추가할 UIBarButtonItem
    /// - Parameter target: 제스처가 동작할 타겟
    /// - Parameter action: 제스처 동작 메서드
    func addTapGesture<T: UIBarButtonItem>(_ component: T, target: Any?, action: Selector?) {
        let gesture = UITapGestureRecognizer(target: target, action: action)
        component.customView?.addGestureRecognizer(gesture)
    }
    
    /// Section에 UITapGesture를 추가합니다.
    ///
    /// - Parameter component: 제스처를 추가할 Section
    /// - Parameter target: 제스처가 동작할 타겟
    /// - Parameter action: 제스처 동작 메서드
    func addTapGesture<T: Section>(_ component: T, target: Any?, action: Selector) {
        let gesture = UITapGestureRecognizer(target: self, action: action)
        component.addGestureRecognizer(gesture)
    }
}
