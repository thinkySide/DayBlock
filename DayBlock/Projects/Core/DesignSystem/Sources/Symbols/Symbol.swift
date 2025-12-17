//
//  Symbol.swift
//  DesignSystem
//
//  Created by 김민준 on 12/14/25.
//

import Foundation

public enum Symbol: String {
    case play_fill
    case pause_fill
    case party_popper_fill
    case plus_circle_fill
}

// MARK: - Helper
extension Symbol {
    
    /// SFSymbol 이름을 반환합니다.
    public var symbolName: String {
        rawValue.replacingOccurrences(of: "_", with: ".")
    }
}
