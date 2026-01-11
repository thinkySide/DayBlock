//
//  ComponentsView.swift
//  Storybook
//
//  Created by 김민준 on 12/14/25.
//

import SwiftUI
import DesignSystem

struct ComponentsView: View {
    var body: some View {
        List(ComponentsPath.allCases) { componentsPath in
            NavigationLink(componentsPath.title, value: componentsPath)
        }
        .navigationDestination(for: ComponentsPath.self) { componentsPath in
            Group {
                switch componentsPath {
                case .navigationBar:
                    NavigationBar(
                        title: "네비게이션바",
                        backgroundColor: .gray,
                        leadingView: {
                            
                        },
                        centerView: {
                            
                        },
                        trailingView: {
                            
                        }
                    )

                case .trackingBoard:
                    TrackingBoard(
                        activeBlocks: [
                            0: .firstHalf(.red),
                            1: .mixed(firstHalf: .blue, secondHalf: .yellow),
                            9: .full(.purple),
                            12: .secondHalf(.green),
                            17: .full(.orange)
                        ],
                        blockSize: 18,
                        blockCornerRadius: 4.5,
                        spacing: 4
                    )
                    TrackingBoard(
                        activeBlocks: [
                            0: .firstHalf(.red, isTracking: true),
                            1: .mixed(firstHalf: .blue, secondHalf: .yellow, isSecondHalfTracking: true),
                            9: .full(.purple, isTracking: true),
                            12: .secondHalf(.green, isTracking: true),
                            17: .full(.orange, isTracking: true)
                        ],
                        blockSize: 18,
                        blockCornerRadius: 4.5,
                        spacing: 4
                    )
                    
                case .trackingBoardBlock:
                    HStack {
                        TrackingBoardBlock(
                            hour: 0,
                            variation: .none,
                            size: 32,
                            cornerRadius: 8,
                            isTracking: false
                        )
                        TrackingBoardBlock(
                            hour: 1,
                            variation: .firstHalf(.red),
                            size: 32,
                            cornerRadius: 8,
                            isTracking: false
                        )
                        TrackingBoardBlock(
                            hour: 2,
                            variation: .secondHalf(.blue),
                            size: 32,
                            cornerRadius: 8,
                            isTracking: false
                        )
                        TrackingBoardBlock(
                            hour: 3,
                            variation: .full(.purple),
                            size: 32,
                            cornerRadius: 8,
                            isTracking: false
                        )
                        TrackingBoardBlock(
                            hour: 4,
                            variation: .mixed(firstHalf: .cyan, secondHalf: .brown),
                            size: 32,
                            cornerRadius: 8,
                            isTracking: false
                        )
                    }
                }
            }
            .navigationTitle(componentsPath.title)
        }
    }
}
