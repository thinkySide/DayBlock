//
//  CustomBottomModal.swift
//  DayBlock
//
//  Created by 김민준 on 2023/04/16.
//

import UIKit

// MARK: - CustomBottomModalDelegate

final class CustomBottomModalDelegate: NSObject, UIViewControllerTransitioningDelegate {
    
    /// View의 사이즈 지정
    func presentationController(forPresented presented: UIViewController, presenting: UIViewController?, source: UIViewController) -> UIPresentationController? {
        return CustomBottomModal( presentedViewController: presented, presenting: presenting)
    }
}



// MARK: - CustomBottomModal

final class CustomBottomModal: UIPresentationController {
    
    /// 뒷배경 어두워지는 효과 및 터치 이벤트
    let backgroundView: UIView?
    var tap = UITapGestureRecognizer()
    
    override init(presentedViewController: UIViewController, presenting presentingViewController: UIViewController?) {
        backgroundView = UIView(frame: .zero)
        backgroundView?.backgroundColor = .black
        
        /// 상위 생성자 호출
        super.init(presentedViewController: presentedViewController, presenting: presentingViewController)
        
        tap = UITapGestureRecognizer(target: self, action: #selector(dismissController))
        backgroundView?.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView?.isUserInteractionEnabled = true
        backgroundView?.addGestureRecognizer(tap)
    }
    
    /// present 할 프레임 설정
    override var frameOfPresentedViewInContainerView: CGRect {
        let screenBounds = UIScreen.main.bounds
        let origin = CGPoint(x: .zero, y: screenBounds.height * 0.5)
        let size = CGSize(width: screenBounds.width, height: screenBounds.height * 0.5)
        return CGRect(origin: origin, size: size)
    }
    
    /// dismiss 메서드
    @objc func dismissController(gesture: UITapGestureRecognizer) {
        presentingViewController.dismiss(animated: true)
    }
    
    /// present 실행 준비
    override func presentationTransitionWillBegin() {
        guard let view = backgroundView,
              let containerBound = containerView?.bounds else { return }
        
        containerView?.addSubview(view)
        view.frame = containerBound
        view.alpha = 0
        
        guard let coordinator = presentedViewController.transitionCoordinator else {
            view.alpha = 0.6
            return
        }

        coordinator.animate { _ in view.alpha = 0.6 }
    }
    
    /// dismiss 실행 준비
    override func dismissalTransitionWillBegin() {
        guard let blurView = backgroundView else { return }
        guard let coordinator = presentedViewController.transitionCoordinator else {
            blurView.alpha = 0.0
            return
        }
        
        coordinator.animate { _ in blurView.alpha = 0.0 }
    }
}
