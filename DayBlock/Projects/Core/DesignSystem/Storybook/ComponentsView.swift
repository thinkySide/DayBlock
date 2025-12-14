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
            ScrollView {
                switch componentsPath {
                case .navigationBar: navigationBar()
                }
            }
            .navigationTitle(componentsPath.title)
        }
    }
}

// MARK: - SubViews
extension ComponentsView {
    
    @ViewBuilder
    private func navigationBar() -> some View {
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
    }
}
