//
//  AttributedString+.swift
//  Util
//
//  Created by 김민준 on 2/15/26.
//

import SwiftUI

extension AttributedString {

    /// 여러 (텍스트, 컬러) 조합을 하나의 AttributedString으로 만듭니다.
    public static func buildAttributed(_ components: [AttributedStringComponent]) -> AttributedString {
        var result = AttributedString()
        for component in components {
            var part = AttributedString(component.text)
            part.foregroundColor = component.color
            part.font = component.font
            result.append(part)
        }
        return result
    }
}

// MARK: - AttributedStringComponent
public struct AttributedStringComponent {
    
    let text: String
    let color: Color
    let font: Font
    
    public init(
        text: String,
        color: Color,
        font: Font
    ) {
        self.text = text
        self.color = color
        self.font = font
    }
}
