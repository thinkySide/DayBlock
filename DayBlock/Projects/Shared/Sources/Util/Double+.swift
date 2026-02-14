//
//  Double.swift
//  Util
//
//  Created by 김민준 on 2/14/26.
//

import Foundation

public extension Double {
    
    /// 소수점 한자리수 절삭 후 문자열을 반환합니다.
    func toValueString() -> String {
        String(format: "%.1f", self)
    }
}
