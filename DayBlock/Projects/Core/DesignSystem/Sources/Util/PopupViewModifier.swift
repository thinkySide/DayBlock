//
//  PopupViewModifier.swift
//  DesignSystem
//
//  Created by 김민준 on 1/6/26.
//

import SwiftUI

extension View {

    /// Popup을 표시하는 ViewModifier
    /// - Parameters:
    ///   - isPresented: 팝업 표시 여부를 제어하는 Binding
    ///   - title: 팝업 제목
    ///   - message: 팝업 메시지
    ///   - leftAction: 왼쪽 버튼 액션 (옵셔널)
    ///   - rightAction: 오른쪽 버튼 액션 (옵셔널)
    public func popup(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        leftAction: Popup.PopupAction?,
        rightAction: Popup.PopupAction? = nil
    ) -> some View {
        self.modifier(
            PopupViewModifier(
                isPresented: isPresented,
                title: title,
                message: message,
                leftAction: leftAction,
                rightAction: rightAction
            )
        )
    }
}

public struct PopupViewModifier: ViewModifier {
    @Binding var isPresented: Bool

    let title: String
    let message: String
    let leftAction: Popup.PopupAction?
    let rightAction: Popup.PopupAction?

    public init(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        leftAction: Popup.PopupAction?,
        rightAction: Popup.PopupAction?
    ) {
        self._isPresented = isPresented
        self.title = title
        self.message = message
        self.leftAction = leftAction
        self.rightAction = rightAction
    }

    public func body(content: Content) -> some View {
        content
            .overlay {
                if isPresented {
                    ZStack {
                        Color.black.opacity(0.3)
                            .ignoresSafeArea()
                            .onTapGesture {
                                isPresented = false
                            }

                        Popup(
                            title: title,
                            message: message,
                            leftAction: leftAction,
                            rightAction: rightAction
                        )
                        .background(
                            RoundedRectangle(cornerRadius: 20)
                                .fill(DesignSystem.Colors.grayFFFFFF.swiftUIColor)
                        )
                        .padding(.horizontal, 32)
                        .transition(.scale.combined(with: .opacity))
                    }
                    .animation(
                        .spring(response: 0.3, dampingFraction: 0.8),
                        value: isPresented
                    )
                }
            }
    }
}
