//
//  MainView.swift
//  DesignSystem
//
//  Created by 김민준 on 12/7/25.
//

import SwiftUI
import DesignSystem

struct MainView: View {
    
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            List(Path.allCases) { path in
                NavigationLink(path.title, value: path)
            }
            .navigationTitle("Storybook")
            .navigationDestination(for: Path.self) { path in
                Group {
                    switch path {
                    case .font: FontView()
                    }
                }
                .navigationTitle(path.title)
            }
        }
    }
}

#Preview {
    MainView()
}
