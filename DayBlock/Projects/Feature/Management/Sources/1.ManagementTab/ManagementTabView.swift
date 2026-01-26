//
//  ManagementTabView.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Editor

public struct ManagementTabView: View {
    
    @Bindable private var store: StoreOf<ManagementTabFeature>

    public init(store: StoreOf<ManagementTabFeature>) {
        self.store = store
    }
    
    public var body: some View {
        NavigationStack(path: $store.scope(state: \.path, action: \.path)) {
            contentView
        } destination: { store in
            switch store.case {
            case let .groupEditor(store):
                GroupEditorView(store: store)
            }
        }
    }
    
    @ViewBuilder
    private var contentView: some View {
        VStack(spacing: 0) {
            NavigationBar()
            
            ManagementTab()
            
            TabView(selection: Binding(
                get: { store.selectedTab },
                set: { store.send(.view(.onTapTab($0))) }
            )) {
                GroupListView(
                    store: store.scope(state: \.groupList, action: \.groupList)
                )
                .tag(ManagementTabFeature.State.Tab.group)
                
                BlockListView(
                    store: store.scope(state: \.blockList, action: \.blockList)
                )
                .tag(ManagementTabFeature.State.Tab.block)
            }
            .tabViewStyle(.page(indexDisplayMode: .never))
        }
    }
}

// MARK: - Tab
extension ManagementTabView {
    
    @ViewBuilder
    private func ManagementTab() -> some View {
        HStack(spacing: 0) {
            ManagementTabCell(from: .group)
            ManagementTabCell(from: .block)
        }
    }
    
    @ViewBuilder
    private func ManagementTabCell(from tab: ManagementTabFeature.State.Tab) -> some View {
        let isSelected = store.selectedTab == tab
        Button {
            store.send(.view(.onTapTab(tab)))
        } label: {
            Text(tabName(from: tab))
                .brandFont(.pretendard(.semiBold), 16)
                .foregroundStyle(
                    isSelected
                    ? DesignSystem.Colors.gray900.swiftUIColor
                    : DesignSystem.Colors.gray600.swiftUIColor
                )
                .frame(maxWidth: .infinity)
                .frame(height: 56)
                .overlay(alignment: .bottom) {
                    Rectangle()
                        .fill(
                            isSelected
                            ? DesignSystem.Colors.gray900.swiftUIColor
                            : DesignSystem.Colors.gray500.swiftUIColor
                        )
                        .frame(height: isSelected ? 3 : 1)
                }
        }
    }
}

// MARK: - Helper
extension ManagementTabView {
    
    /// Tab 이름을 반환합니다.
    private func tabName(from tab: ManagementTabFeature.State.Tab) -> String {
        switch tab {
        case .group: "그룹 관리"
        case .block: "블럭 관리"
        }
    }
}
