//
//  BrandFontViewModifier.swift
//  DesignSystem
//
//  Created by 김민준 on 12/6/25.
//

import SwiftUI

public struct BrandFontViewModifier: ViewModifier {
    
    let brandFont: BrandFont
    let size: CGFloat
    
    public func body(content: Content) -> some View {
        let fontName: String = switch brandFont {
        case .pretendard(let pretendard): pretendard.fontName
        case .poppins(let poppins): poppins.fontName
        }
        return content
            .font(.custom(fontName, size: size))
    }
}

// MARK: - View Extension
extension View {
    
    /// 브랜드 폰트를 반환합니다.
    public func brandFont(_ brandfont: BrandFont, _ size: CGFloat) -> some View {
        modifier(BrandFontViewModifier(brandFont: brandfont, size: size))
    }
}
