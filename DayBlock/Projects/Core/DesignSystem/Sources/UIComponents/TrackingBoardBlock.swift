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
        case firstHalf(Color)
        case secondHalf(Color)
        case full(Color)
        case mixed(firstHalf: Color, secondHalf: Color)
    }

    public var id: Int { index }

    let index: Int
    let state: State
    let size: CGFloat
    let cornerRadius: CGFloat
    
    public init(
        index: Int,
        state: State,
        size: CGFloat,
        cornerRadius: CGFloat
    ) {
        self.index = index
        self.state = state
        self.size = size
        self.cornerRadius = cornerRadius
    }
    
    public var body: some View {
        Group {
            switch state {
            case .none:
                DesignSystem.Colors.grayE8E8E8.swiftUIColor
                
            case .firstHalf(let color):
                DesignSystem.Colors.grayE8E8E8.swiftUIColor
                    .overlay(alignment: .leading) {
                        color
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                
            case .secondHalf(let color):
                DesignSystem.Colors.grayE8E8E8.swiftUIColor
                    .overlay(alignment: .trailing) {
                        color
                            .clipShape(RoundedRectangle(cornerRadius: cornerRadius))
                            .frame(width: size / 2, height: size)
                    }
                
            case .full(let color):
                color
                
            case .mixed(let firstHalf, let secondHalf):
                DesignSystem.Colors.grayE8E8E8.swiftUIColor
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
        case (.firstHalf(let lhsColor), .firstHalf(let rhsColor)),
             (.secondHalf(let lhsColor), .secondHalf(let rhsColor)),
             (.full(let lhsColor), .full(let rhsColor)):
            return lhsColor == rhsColor
        case (.mixed(let lhsFirst, let lhsSecond), .mixed(let rhsFirst, let rhsSecond)):
            return lhsFirst == rhsFirst && lhsSecond == rhsSecond
        default:
            return false
        }
    }
}
