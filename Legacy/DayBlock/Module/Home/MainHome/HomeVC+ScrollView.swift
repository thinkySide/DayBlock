//
//  HomeVC+ScrollView.swift
//  DayBlock
//
//  Created by 김민준 on 2023/09/19.
//

import UIKit

// MARK: - UIScrollView Delegate
extension HomeViewController: UIScrollViewDelegate {
    
    /// 스크롤이 시작되기 전 호출되는 Delegate 메서드입니다.
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        
        // 스크롤 시작 지점
        startScrollX = scrollView.contentOffset.x
        
        // 멀티 터치 비활성화
        scrollView.isUserInteractionEnabled = false
        
        // 트래킹 버튼 비활성화
        viewManager.trackingButton.isUserInteractionEnabled = false
    }
    
    /// 스크롤이 끝난 후 호출되는 Delegate 메서드입니다.
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        
        // 블럭 크기 = 블럭 가로 사이즈 + 블럭 여백 (보이는 영역 보다 크게 사이즈를 잡아야 캐러셀 구현 가능)
        let blockWidth = Size.blockSize.width + Size.blockSpacing
        
        // 스크롤된 크기 = 스크롤이 멈춘 x좌표 + 스크롤뷰 inset
        let scrollSize = targetContentOffset.pointee.x + scrollView.contentInset.left
        
        // 이전 블럭 인덱스 저장
        let rememberBlockIndex = blockIndex
        
        // 블럭 한칸 이상을 갔느냐 못갔느냐 체크
        let scrollSizeCheck = abs(startScrollX - targetContentOffset.pointee.x)
        
        // 햅틱 이벤트 출력
        Vibration.soft.vibrate()
        
        // 1. 한칸만 이동하는 제스처
        if scrollSizeCheck <= blockWidth {
            
            // 왼쪽으로 한칸 이동하는 경우 (제스처 보정용 -30)
            if startScrollX-30 > targetContentOffset.pointee.x && blockIndex > 0 {
                blockIndex -= 1
            }
            
            // 오른쪽으로 한칸 이동하는 경우 (제스처 보정용 +30)
            if startScrollX+30 < targetContentOffset.pointee.x && blockIndex < blockData.list().count {
                blockIndex += 1
            }
        }
        
        // 2. 한칸 이상 이동하는 제스처
        else { blockIndex = Int(round(scrollSize / blockWidth)) }
        
        // 최종 스크롤 위치 지정
        targetContentOffset.pointee = CGPoint(
            x: CGFloat(blockIndex) * blockWidth - scrollView.contentInset.left,
            y: scrollView.contentInset.top)
        
        // 사용자 터치 재활성화
        scrollView.isUserInteractionEnabled = true
        
        // 블럭 인덱스 업데이트
        if blockIndex != rememberBlockIndex {
            viewManager.blockCollectionView.reloadData()
        }
        
        blockData.updateFocusIndex(to: blockIndex)
        
        // 트래킹 버튼 활성화
        viewManager.trackingButton.isUserInteractionEnabled = true
    }
}
