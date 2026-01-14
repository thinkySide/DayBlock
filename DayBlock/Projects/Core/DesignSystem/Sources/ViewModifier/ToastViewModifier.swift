//
//  ToastModifier.swift
//  DesignSystem
//
//  Created by Claude on 1/11/26.
//

import SwiftUI

extension View {

    /// Toast를 표시합니다.
    /// - Parameters:
    ///   - isPresented: Toast 표시 여부를 바인딩
    ///   - icon: SF Symbol 이름
    ///   - iconColor: 아이콘 색상
    ///   - message: 표시할 메시지
    ///   - duration: Toast가 자동으로 사라지는 시간 (기본값: 2초)
    public func toast(
        isPresented: Binding<Bool>,
        icon: String,
        iconColor: Color,
        message: String,
        duration: TimeInterval = 2
    ) -> some View {
        self.modifier(
            ToastViewModifier(
                isPresented: isPresented,
                icon: icon,
                iconColor: iconColor,
                message: message,
                duration: duration
            )
        )
    }
}

// MARK: - ViewModifier
public struct ToastViewModifier: ViewModifier {

    @Binding var isPresented: Bool
    let icon: String
    let iconColor: Color
    let message: String
    let duration: TimeInterval

    @State private var offsetY: CGFloat = -100
    @State private var opacity: Double = 0
    @State private var task: Task<Void, Never>?

    public init(
        isPresented: Binding<Bool>,
        icon: String,
        iconColor: Color,
        message: String,
        duration: TimeInterval
    ) {
        self._isPresented = isPresented
        self.icon = icon
        self.iconColor = iconColor
        self.message = message
        self.duration = duration
    }

    public func body(content: Content) -> some View {
        content
            .overlay(alignment: .top) {
                Toast(icon: icon, iconColor: iconColor, message: message)
                    .offset(y: offsetY)
                    .opacity(opacity)
                    .onTapGesture {
                        guard isPresented else { return }
                        task?.cancel()
                        dismissToast()
                    }
            }
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    showToast()
                }
            }
    }
}

// MARK: - Helper
extension ToastViewModifier {
    
    /// Toast를 출력합니다.
    private func showToast() {
        task?.cancel()
        offsetY = -50
        opacity = 0
        withAnimation(.spring(response: 0.5, dampingFraction: 0.5, blendDuration: 0)) {
            offsetY = 10
            opacity = 1
        }
        task = Task { @MainActor in
            try? await Task.sleep(for: .seconds(duration))
            if !Task.isCancelled {
                dismissToast()
            }
        }
    }

    /// Toast를 dismiss합니다.
    private func dismissToast() {
        withAnimation(.easeIn(duration: 0.25)) {
            offsetY = -50
            opacity = 0
        }
        Task { @MainActor in
            try? await Task.sleep(for: .seconds(0.25))
            isPresented = false
        }
    }
}
