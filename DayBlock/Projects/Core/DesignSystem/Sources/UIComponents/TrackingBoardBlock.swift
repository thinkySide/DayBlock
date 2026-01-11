//
//  TrackingBoardBlock.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoardBlock: View, Identifiable {

    public enum Variation: Equatable {
        case none
        case firstHalf(Color, isTracking: Bool = false)
        case secondHalf(Color, isTracking: Bool = false)
        case full(Color, isTracking: Bool = false)
        case mixed(
            firstHalf: Color,
            isFirstHalfTracking: Bool = false,
            secondHalf: Color,
            isSecondHalfTracking: Bool = false
        )
    }

    public var id: Int { hour }

    let hour: Int
    let variation: Variation
    let size: CGFloat
    let cornerRadius: CGFloat
    let isTracking: Bool

    public init(
        hour: Int,
        variation: Variation,
        size: CGFloat,
        cornerRadius: CGFloat,
        isTracking: Bool
    ) {
        self.hour = hour
        self.variation = variation
        self.size = size
        self.cornerRadius = cornerRadius
        self.isTracking = isTracking
    }
    
    public var body: some View {
        Group {
            switch variation {
            case .none:
                DesignSystem.Colors.gray300.swiftUIColor
                
            case .firstHalf(let color, let isTracking):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .leading) {
                        color
                            .opacity(isTracking ? animateOpacity : 1)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }

            case .secondHalf(let color, let isTracking):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .trailing) {
                        color
                            .opacity(isTracking ? animateOpacity : 1)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }

            case .full(let color, let isTracking):
                color
                    .opacity(isTracking ? animateOpacity : 1)

            case .mixed(let firstHalf, let isFirstHalfTracking, let secondHalf, let isSecondHalfTracking):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .leading) {
                        firstHalf
                            .opacity(isFirstHalfTracking ? animateOpacity : 1)
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                    .overlay(alignment: .trailing) {
                        secondHalf
                            .opacity(isSecondHalfTracking ? animateOpacity : 1)
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
    
    /// 애니메이션용 Opacity를 반환합니다.
    private var animateOpacity: Double {
        isTracking ? 0.1 : 1
    }
}

// MARK: - Variation Equtable
extension TrackingBoardBlock.Variation {

    public static func == (
        lhs: TrackingBoardBlock.Variation,
        rhs: TrackingBoardBlock.Variation
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
