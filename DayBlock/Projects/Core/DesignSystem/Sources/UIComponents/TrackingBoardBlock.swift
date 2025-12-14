//
//  TrackingBoardBlock.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI

public struct TrackingBoardBlock: View {
    
    public enum State {
        case none
        case firstHalf(Color)
        case secondHalf(Color)
        case full(Color)
        case mixed(firstHalf: Color, secondHalf: Color)
    }
    
    let state: State
    let size: CGFloat
    let cornerRadius: CGFloat
    
    public init(
        state: State,
        size: CGFloat,
        cornerRadius: CGFloat
    ) {
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
