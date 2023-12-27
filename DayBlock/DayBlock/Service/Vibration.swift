//
//  Vibration.swift
//  DayBlock
//
//  Created by 김민준 on 12/14/23.
//

import UIKit
import AVFoundation

enum Vibration: String, CaseIterable {
    case error
    case success
    case warning
    case light
    case medium
    case heavy
    case selection
    case soft
    case rigid
    
    public func vibrate() {
        switch self {
        case .error: UINotificationFeedbackGenerator().notificationOccurred(.error)
        case .success: UINotificationFeedbackGenerator().notificationOccurred(.success)
        case .warning: UINotificationFeedbackGenerator().notificationOccurred(.warning)
        case .light: UIImpactFeedbackGenerator(style: .light).impactOccurred()
        case .medium: UIImpactFeedbackGenerator(style: .medium).impactOccurred()
        case .heavy: UIImpactFeedbackGenerator(style: .heavy).impactOccurred()
        case .selection: UISelectionFeedbackGenerator().selectionChanged()
        case .soft: UIImpactFeedbackGenerator(style: .soft).impactOccurred()
        case .rigid: UIImpactFeedbackGenerator(style: .rigid).impactOccurred()
        }
    }
}
