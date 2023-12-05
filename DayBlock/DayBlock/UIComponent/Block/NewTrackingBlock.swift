//
//  NewTrackingBlock.swift
//  DayBlock
//
//  Created by 김민준 on 12/5/23.
//

import UIKit

final class NewTrackingBlock: UIView {
    
    /// 타임 라인 블록 상태
    enum State {
        case none // 1. 값 없음
        case firstHalf // 2. 왼쪽 반 채워진 상태
        case secondHalf // 3. 오른쪽 반 채워진 상태
        case full // 4. 한개의 블럭으로 꽉 찬 상태
        case mixed // 5. 두개의 블럭이 섞여 꽉 찬 상태
    }
}
