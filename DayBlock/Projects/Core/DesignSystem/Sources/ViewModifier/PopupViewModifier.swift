//
//  PopupViewModifier.swift
//  DesignSystem
//
//  Created by 김민준 on 1/6/26.
//

import SwiftUI

extension View {

    /// Popup을 표시하는 ViewModifier
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
            .onChange(of: isPresented) { _, newValue in
                if newValue {
                    showPopup()
                }
            }
            .onDisappear {
                PopupWindowManager.shared.dismiss()
            }
    }

    private func showPopup() {
        PopupWindowManager.shared.show(
            isPresented: $isPresented,
            title: title,
            message: message,
            leftAction: leftAction,
            rightAction: rightAction
        )
    }
}

// MARK: - PopupWindowManager
@MainActor
final class PopupWindowManager {
    static let shared = PopupWindowManager()

    private var window: UIWindow?

    func show(
        isPresented: Binding<Bool>,
        title: String,
        message: String,
        leftAction: Popup.PopupAction?,
        rightAction: Popup.PopupAction?
    ) {
        guard let scene = UIApplication.shared.connectedScenes
            .first(where: { $0.activationState == .foregroundActive }) as? UIWindowScene
        else { return }

        let overlayView = PopupOverlayView(
            isPresented: isPresented,
            title: title,
            message: message,
            leftAction: leftAction,
            rightAction: rightAction
        )

        let window = UIWindow(windowScene: scene)
        window.windowLevel = .alert
        window.backgroundColor = .clear

        let hostingController = UIHostingController(rootView: overlayView)
        hostingController.view.backgroundColor = .clear
        window.rootViewController = hostingController
        window.makeKeyAndVisible()
        self.window = window
    }

    func dismiss() {
        window?.isHidden = true
        window = nil
    }
}

// MARK: - PopupOverlayView
private struct PopupOverlayView: View {
    @Binding var isPresented: Bool
    @State private var isVisible = false

    let title: String
    let message: String
    let leftAction: Popup.PopupAction?
    let rightAction: Popup.PopupAction?

    var body: some View {
        ZStack {
            if isVisible {
                Color.black.opacity(0.3)
                    .ignoresSafeArea()
                    .transition(.opacity)

                Popup(
                    title: title,
                    message: message,
                    leftAction: wrappedAction(leftAction),
                    rightAction: wrappedAction(rightAction)
                )
                .background(
                    RoundedRectangle(cornerRadius: 20)
                        .fill(DesignSystem.Colors.gray0.swiftUIColor)
                        .shadow(color: .black.opacity(0.15), radius: 20, y: 10)
                )
                .padding(.horizontal, 32)
                .transition(.scale(scale: 0.8).combined(with: .opacity))
            }
        }
        .animation(.spring(response: 0.35, dampingFraction: 0.75), value: isVisible)
        .onAppear {
            isVisible = true
        }
    }

    private func wrappedAction(_ action: Popup.PopupAction?) -> Popup.PopupAction? {
        guard let action else { return nil }
        return .init(title: action.title, variation: action.variation) {
            dismissThenExecute(action.action)
        }
    }

    private func dismissThenExecute(_ action: @escaping () -> Void) {
        isVisible = false
        isPresented = false
        Task { @MainActor in
            try? await Task.sleep(for: .milliseconds(350))
            PopupWindowManager.shared.dismiss()
            action()
        }
    }
}
