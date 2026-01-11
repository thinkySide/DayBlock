//
//  TrackingBoardBlock.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoardBlock: View, Identifiable {

    public enum Area: Equatable {
        case none
        case firstHalf(Color, Variation)
        case secondHalf(Color, Variation)
        case full(Color, Variation)
        case mixed(
            firstHalf: Color,
            firstHalfState: Variation,
            secondHalf: Color,
            secondHalfState: Variation
        )
        
        public enum Variation: Equatable {
            case stored
            case tracking
            case paused
        }
    }

    public var id: Int { hour }

    let hour: Int
    let area: Area
    let size: CGFloat
    let cornerRadius: CGFloat
    let isAnimating: Bool

    public init(
        hour: Int,
        area: Area,
        size: CGFloat,
        cornerRadius: CGFloat,
        isAnimating: Bool
    ) {
        self.hour = hour
        self.area = area
        self.size = size
        self.cornerRadius = cornerRadius
        self.isAnimating = isAnimating
    }
    
    public var body: some View {
        Group {
            switch area {
            case .none:
                DesignSystem.Colors.gray300.swiftUIColor

            case .firstHalf(let color, let variation):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .leading) {
                        displayColor(color, for: variation)
                            .opacity(opacity(for: variation))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }

            case .secondHalf(let color, let variation):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .trailing) {
                        displayColor(color, for: variation)
                            .opacity(opacity(for: variation))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }

            case .full(let color, let variation):
                displayColor(color, for: variation)
                    .opacity(opacity(for: variation))

            case .mixed(let firstHalfColor, let firstHalfState, let secondHalfColor, let secondHalfState):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .leading) {
                        displayColor(firstHalfColor, for: firstHalfState)
                            .opacity(opacity(for: firstHalfState))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                    .overlay(alignment: .trailing) {
                        displayColor(secondHalfColor, for: secondHalfState)
                            .opacity(opacity(for: secondHalfState))
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .frame(width: size, height: size)
    }
}

// MARK: - Helper
extension TrackingBoardBlock {

    /// Variation에 따라 표시할 색상을 반환합니다.
    private func displayColor(_ originalColor: Color, for variation: Area.Variation) -> Color {
        switch variation {
        case .paused: DesignSystem.Colors.gray400.swiftUIColor
        default: originalColor
        }
    }

    /// Variation에 따른 Opacity를 반환합니다.
    private func opacity(for variation: Area.Variation) -> Double {
        switch variation {
        case .tracking: isAnimating ? 0.1 : 1.0
        default: 1
        }
    }
}

// MARK: - Area Equtable
extension TrackingBoardBlock.Area {

    public static func == (
        lhs: TrackingBoardBlock.Area,
        rhs: TrackingBoardBlock.Area
    ) -> Bool {
        switch (lhs, rhs) {
        case (.none, .none):
            return true

        case (.firstHalf(let lhsColor, let lhsTracking), .firstHalf(let rhsColor, let rhsTracking)):
            return lhsColor == rhsColor && lhsTracking == rhsTracking

        case (.secondHalf(let lhsColor, let lhsTracking), .secondHalf(let rhsColor, let rhsTracking)):
            return lhsColor == rhsColor && lhsTracking == rhsTracking

        case (.full(let lhsColor, let lhsTracking), .full(let rhsColor, let rhsTracking)):
            return lhsColor == rhsColor && lhsTracking == rhsTracking

        case (.mixed(let lhsFirst, let lhsFirstTracking, let lhsSecond, let lhsSecondTracking),
              .mixed(let rhsFirst, let rhsFirstTracking, let rhsSecond, let rhsSecondTracking)):
            return lhsFirst == rhsFirst &&
                   lhsFirstTracking == rhsFirstTracking &&
                   lhsSecond == rhsSecond &&
                   lhsSecondTracking == rhsSecondTracking

        default:
            return false
        }
    }
}
