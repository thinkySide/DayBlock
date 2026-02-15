//
//  GroupListView.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct GroupListView: View {

    private var store: StoreOf<GroupListFeature>

    public init(store: StoreOf<GroupListFeature>) {
        self.store = store
    }

    public var body: some View {
        List {
            ForEach(store.groupList) { viewItem in
                GroupCell(from: viewItem)
                    .listRowSeparator(.hidden)
                    .listRowInsets(EdgeInsets())
                    .onTapGesture {
                        store.send(.view(.onTapGroupCell(viewItem)))
                    }
            }
            .onMove { from, to in
                store.send(.view(.onMoveGroup(from: from, to: to)))
            }

            AddGroupButton()
                .listRowSeparator(.hidden)
                .listRowInsets(EdgeInsets())
        }
        .listStyle(.plain)
        .environment(\.editMode, .constant(.inactive))
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

// MARK: - SubViews
extension GroupListView {

    @ViewBuilder
    private func GroupCell(from viewItem: GroupListViewItem) -> some View {
        HStack(spacing: 0) {
            Text(viewItem.group.name)
                .brandFont(.pretendard(.semiBold), 16)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

            Text("+\(viewItem.blockCount)")
                .brandFont(.pretendard(.semiBold), 15)
                .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                .padding(.leading, 8)

            if viewItem.isDefault {
                Text("기본 그룹")
                    .brandFont(.pretendard(.semiBold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)
                    .padding(.horizontal, 6)
                    .frame(height: 26)
                    .background(DesignSystem.Colors.gray100.swiftUIColor)
                    .clipShape(Capsule())
                    .padding(.leading, 10)
            }

            Spacer()
            
            DesignSystem.Icons.arrowRight.swiftUIImage
                .tint(DesignSystem.Colors.gray700.swiftUIColor)
        }
        .padding(.horizontal, 20)
        .frame(height: 56)
        .contentShape(.rect)
    }

    @ViewBuilder
    private func AddGroupButton() -> some View {
        Button {
            store.send(.view(.onTapAddGroupButton))
        } label: {
            HStack(spacing: 8) {
                DesignSystem.Icons.addCell.swiftUIImage

                Text("그룹 추가하기")
                    .brandFont(.pretendard(.semiBold), 15)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                    .padding(.leading, 8)

                Spacer()
            }
            .padding(.horizontal, 20)
            .frame(height: 56)
        }
        .moveDisabled(true)
    }
}
