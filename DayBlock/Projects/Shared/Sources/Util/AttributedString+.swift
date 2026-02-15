//
//  AttributedString+.swift
//  Util
//
//  Created by 김민준 on 2/15/26.
//

import SwiftUI

extension AttributedString {

    /// 여러 (텍스트, 컬러) 조합을 하나의 AttributedString으로 만듭니다.
    ///
    /// ```swift
    /// AttributedString.build(
    ///     ("초기화 작업 실행 시 ", Colors.gray700.swiftUIColor, nil),
    ///     ("모든 데이터가 삭제", Colors.red.swiftUIColor, .custom("Pretendard-Bold", size: 14)),
    ///     ("됩니다.", Colors.gray700.swiftUIColor, nil)
    /// )
    /// ```
    public static func build(_ components: (String, Color, Font?)...) -> AttributedString {
        var result = AttributedString()
        for (text, color, font) in components {
            var part = AttributedString(text)
            part.foregroundColor = color
            if let font { part.font = font }
            result.append(part)
        }
        return result
    }
}
