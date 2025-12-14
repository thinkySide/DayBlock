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
                    
                case .trackingBoardBlock:
                    HStack {
                        TrackingBoardBlock(
                            index: 0,
                            state: .none,
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            index: 1,
                            state: .firstHalf(.red),
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            index: 2,
                            state: .secondHalf(.blue),
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            index: 3,
                            state: .full(.purple),
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            index: 4,
                            state: .mixed(firstHalf: .cyan, secondHalf: .brown),
                            size: 32,
                            cornerRadius: 8
                        )
                    }
                }
            }
            .navigationTitle(componentsPath.title)
        }
    }
}
