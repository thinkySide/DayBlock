//
//  HomeVC+LongPressGesture.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/19.
//

import UIKit

extension HomeViewController {
    
    /// 트래킹 블럭의 Long Press 제스처를 설정합니다.
    func configureBlockLongPressGesture() {
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(trackingBlockLongPressed))
        longPressGesture.minimumPressDuration = 0.1
        viewManager.trackingBlock.addGestureRecognizer(longPressGesture)
    }
    
    /// 트래킹 블럭 Long Press Gestrue 실행 메서드입니다.
    @objc func trackingBlockLongPressed(_ gesture: UILongPressGestureRecognizer) {
        let block = viewManager.trackingBlock
        let state = gesture.state
        if state == .began { block.longPressAnimation(isFill: true) }
        else if state == .ended || state == .cancelled { block.longPressAnimation(isFill: false) }
    }
}
