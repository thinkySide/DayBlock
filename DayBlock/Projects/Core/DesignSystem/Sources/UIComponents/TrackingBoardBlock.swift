//
//  TrackingBoardBlock.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoardBlock: View, Identifiable {

    public enum State: Equatable {
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
    let state: State
    let size: CGFloat
    let cornerRadius: CGFloat
    
    public init(
        hour: Int,
        state: State,
        size: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.hour = hour
        self.state = state
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        Group {
            switch state {
            case .none:
                DesignSystem.Colors.gray300.swiftUIColor
                
            case .firstHalf(let color, let isTracking):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .leading) {
                        color
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                
            case .secondHalf(let color, let isTracking):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .trailing) {
                        color
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                
            case .full(let color, let isTracking):
                color
                
            case .mixed(let firstHalf, let isFirstHalfTracking, let secondHalf, let isSecondHalfTracking):
                DesignSystem.Colors.gray300.swiftUIColor
                    .overlay(alignment: .leading) {
                        firstHalf
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                    .overlay(alignment: .trailing) {
                        secondHalf
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
        .frame(width: size, height: size)
    }
}

// MARK: - State Equtable
extension TrackingBoardBlock.State {

    public static func == (
        lhs: TrackingBoardBlock.State,
        rhs: TrackingBoardBlock.State
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
