//
//  StableTextEditor.swift
//  DesignSystem
//
//  Created by 김민준 on 1/25/26.
//

import SwiftUI

/// SwiftUI `TextEditor`의 스크롤 점핑 문제를 해결하기 위해 구현된 커스텀 텍스트 에디터.
///
/// - Note: `UITextView`와 `NSAttributedString`을 활용해 스크롤 점핑 문제를 해결했습니다.
public struct StableTextEditor: UIViewRepresentable {

    @Binding var isFocused: Bool
    @Binding var text: String

    let font: UIFont
    let textColor: UIColor
    let tintColor: UIColor
    let backgroundColor: UIColor
    let textAlignment: NSTextAlignment
    let lineSpacing: CGFloat
    let contentInset: UIEdgeInsets
    let isEditable: Bool

    public init(
        isFocused: Binding<Bool>,
        text: Binding<String>,
        font: UIFont,
        textColor: Color,
        tintColor: Color,
        backgroundColor: Color,
        textAlignment: NSTextAlignment = .center,
        lineSpacing: CGFloat,
        contentInset: UIEdgeInsets = .zero,
        isEditable: Bool = true
    ) {
        self._isFocused = isFocused
        self._text = text
        self.font = font
        self.textColor = UIColor(textColor)
        self.tintColor = UIColor(tintColor)
        self.backgroundColor = UIColor(backgroundColor)
        self.textAlignment = textAlignment
        self.lineSpacing = lineSpacing
        self.contentInset = contentInset
        self.isEditable = isEditable
    }

    public func makeUIView(context: Context) -> UITextView {
        let textView = UITextView()
        textView.delegate = context.coordinator
        textView.tintColor = tintColor
        textView.backgroundColor = backgroundColor
        textView.textContainerInset = contentInset
        textView.attributedText = NSAttributedString(string: text, attributes: attributes)
        textView.typingAttributes = attributes
        textView.isEditable = isEditable
        textView.isSelectable = isEditable
        return textView
    }

    public func updateUIView(_ uiView: UITextView, context: Context) {
        if uiView.text != text {
            uiView.attributedText = NSAttributedString(string: text, attributes: attributes)
            uiView.typingAttributes = attributes
        }

        if isFocused {
            uiView.becomeFirstResponder()
        } else {
            uiView.resignFirstResponder()
        }
    }

    public func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
}

// MARK: - Helper
extension StableTextEditor {

    /// NSAttributedString 속성 Dictionary를 반환합니다.
    private var attributes: [NSAttributedString.Key: Any] {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = textAlignment
        return [
            .font: font,
            .foregroundColor: textColor,
            .paragraphStyle: paragraphStyle
        ]
    }
}

// MARK: - Coordinator
extension StableTextEditor {

    public final class Coordinator: NSObject, UITextViewDelegate {

        var parent: StableTextEditor

        public init(_ parent: StableTextEditor) {
            self.parent = parent
        }

        public func textViewDidChange(_ textView: UITextView) {
            parent.text = textView.text
        }

        public func textViewDidBeginEditing(_ textView: UITextView) {
            parent.isFocused = true
        }

        public func textViewDidEndEditing(_ textView: UITextView) {
            parent.isFocused = false
        }
    }
}
