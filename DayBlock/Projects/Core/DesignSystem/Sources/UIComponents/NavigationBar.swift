//
//  NavigationBar.swift
//  DesignSystem
//
//  Created by 김민준 on 12/8/25.
//

import SwiftUI

public struct NavigationBar<Leading: View, Center: View, Trailing: View>: View {
    
    let title: String?
    let backgroundColor: Color
    let isSheet: Bool
    let leadingView: Leading
    let centerView: Center
    let trailingView: Trailing
    
    public init(
        title: String? = nil,
        backgroundColor: Color = .clear,
        isSheet: Bool = false,
        @ViewBuilder leadingView: (() -> Leading) = { EmptyView() },
        @ViewBuilder centerView: (() -> Center) = { EmptyView() },
        @ViewBuilder trailingView: (() -> Trailing) = { EmptyView() }
    ) {
        self.title = title
        self.backgroundColor = backgroundColor
        self.isSheet = isSheet
        self.leadingView = leadingView()
        self.centerView = centerView()
        self.trailingView = trailingView()
    }
    
    public var body: some View {
        ZStack {
            HStack {
                leadingView
                Spacer()
                trailingView
            }
            
            HStack {
                Spacer()
                if let title = title {
                    Text(title)
                        .brandFont(.pretendard(.bold), 15)
                        .foregroundStyle(DesignSystem.Colors.gray323232.swiftUIColor)
                } else {
                    centerView
                }
                Spacer()
            }
        }
        .padding(.top, isSheet ? 24 : 0)
        .padding(.horizontal, 20)
        .frame(maxWidth: .infinity)
        .frame(height: 48)
        .background(backgroundColor)
    }
}
