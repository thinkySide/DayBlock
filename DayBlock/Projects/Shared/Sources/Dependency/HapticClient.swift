//
//  HapticClient.swift
//  Util
//
//  Created by 김민준 on 1/6/26.
//

import UIKit
import Dependencies

// MARK: - Protocol
public protocol HapticClientProtocol {
    func notification(_ type: UINotificationFeedbackGenerator.FeedbackType)
    func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle)
    func selection()
}

// MARK: - LiveValue
public struct HapticClient: HapticClientProtocol {

    private let notificationGenerator = UINotificationFeedbackGenerator()
    private let selectionGenerator = UISelectionFeedbackGenerator()

    public func notification(_ type: UINotificationFeedbackGenerator.FeedbackType) {
        notificationGenerator.notificationOccurred(type)
    }

    public func impact(_ style: UIImpactFeedbackGenerator.FeedbackStyle) {
        let generator = UIImpactFeedbackGenerator(style: style)
        generator.impactOccurred()
    }

    public func selection() {
        selectionGenerator.selectionChanged()
    }
}

// MARK: - DependencyKey
public enum HapticClientDependencyKey: DependencyKey {
    public static var liveValue: HapticClientProtocol {
        HapticClient()
    }
}

// MARK: - DependencyValues
public extension DependencyValues {
    var haptic: HapticClientProtocol {
        get { self[HapticClientDependencyKey.self] }
        set { self[HapticClientDependencyKey.self] = newValue }
    }
}
