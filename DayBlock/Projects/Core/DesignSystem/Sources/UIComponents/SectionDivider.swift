//
//  SectionDivider.swift
//  DesignSystem
//
//  Created by 김민준 on 2/14/26.
//

import SwiftUI

public struct SectionDivider: View {
    
    public init() {}
    
    public var body: some View {
        Rectangle()
            .foregroundStyle(DesignSystem.Colors.gray100.swiftUIColor)
            .frame(height: 12)
    }
}
