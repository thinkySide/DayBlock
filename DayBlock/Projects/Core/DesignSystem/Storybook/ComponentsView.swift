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
                    TrackingBoard()
                    
                case .trackingBoardBlock:
                    HStack {
                        TrackingBoardBlock(
                            state: .none,
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            state: .firstHalf(.red),
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            state: .secondHalf(.blue),
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
                            state: .full(.purple),
                            size: 32,
                            cornerRadius: 8
                        )
                        TrackingBoardBlock(
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
