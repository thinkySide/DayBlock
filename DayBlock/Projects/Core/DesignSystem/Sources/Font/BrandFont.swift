//
//  BrandFont.swift
//  DesignSystem
//
//  Created by 김민준 on 12/7/25.
//

import Foundation

public enum BrandFont {
    
    case pretendard(Pretendard)
    case poppins(Poppins)
    
    public enum Pretendard {
        case regular
        case medium
        case semiBold
        case bold
        
        public var fontName: String {
            switch self {
            case .regular: DesignSystemFontFamily.Pretendard.regular.name
            case .medium: DesignSystemFontFamily.Pretendard.medium.name
            case .semiBold: DesignSystemFontFamily.Pretendard.semiBold.name
            case .bold: DesignSystemFontFamily.Pretendard.bold.name
            }
        }
    }
    
    public enum Poppins {
        case semiBold
        case bold
        
        public var fontName: String {
            switch self {
            case .semiBold: DesignSystemFontFamily.Poppins.semiBold.name
            case .bold: DesignSystemFontFamily.Poppins.bold.name
            }
        }
    }
}
