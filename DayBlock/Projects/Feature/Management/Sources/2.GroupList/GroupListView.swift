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

    @State private var cellFrames: [UUID: CGRect] = [:]
    @State private var draggingCellFrame: CGRect = .zero
    @State private var isDragActivated: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var lastDropTargetUpdate: Date = .distantPast

    public init(store: StoreOf<GroupListFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(Array(store.groupList.enumerated()), id: \.element.id) { index, viewItem in
                    GroupCell(from: viewItem, index: index)
                }

                AddGroupButton()
            }
            .padding(.vertical, 6)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.groupList)
        }
        .coordinateSpace(name: "scroll")
        .overlay(alignment: .topLeading) {
            // 드래그 중인 셀 오버레이
            if let draggingGroup = store.draggingGroup {
                DraggingCellOverlay(
                    viewItem: draggingGroup,
                    offset: dragOffset,
                    frame: draggingCellFrame
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.draggingGroup != nil)
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

// MARK: - SubViews
extension GroupListView {

    @ViewBuilder
    private func GroupCell(from viewItem: GroupListViewItem, index: Int) -> some View {
        let isDragging = store.draggingGroup?.id == viewItem.id
        let isDropTarget = store.dropTargetIndex == index

        VStack(spacing: 0) {
            // 드롭 인디케이터 (위)
            if isDropTarget {
                DropIndicator()
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }

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
            .frame(height: 56)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
            .opacity(isDragging ? 0.3 : 1.0)
        }
        .animation(.easeInOut(duration: 0.15), value: isDropTarget)
        .animation(.easeInOut(duration: 0.15), value: isDragging)
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: GroupCellFramePreferenceKey.self,
                    value: [viewItem.id: geo.frame(in: .named("scroll"))]
                )
            }
        )
        .onPreferenceChange(GroupCellFramePreferenceKey.self) { frames in
            cellFrames.merge(frames) { _, new in new }
        }
        .onTapGesture {
            store.send(.view(.onTapGroupCell(viewItem)))
        }
        .gesture(
            LongPressGesture(minimumDuration: 0.3)
                .sequenced(before: DragGesture(coordinateSpace: .named("scroll")))
                .onChanged { value in
                    switch value {
                    case .first(true):
                        // 롱프레스 진행 중 - 아직 드래그 시작하지 않음
                        break
                    case .second(true, let drag):
                        // 롱프레스 완료 후 드래그 시작
                        if !isDragActivated {
                            isDragActivated = true
                            if let frame = cellFrames[viewItem.id] {
                                draggingCellFrame = frame
                            }
                            store.send(.view(.onDragStarted(viewItem)))
                        }

                        // 드래그 중
                        if let drag = drag {
                            dragOffset = drag.translation

                            // 드롭 타겟 계산은 throttle
                            let now = Date()
                            if now.timeIntervalSince(lastDropTargetUpdate) > 0.016 {
                                lastDropTargetUpdate = now
                                calculateDropTarget(at: drag.location)
                            }
                        }
                    default:
                        break
                    }
                }
                .onEnded { _ in
                    if isDragActivated {
                        store.send(.view(.onDragEnded))
                    }

                    // 상태 초기화
                    isDragActivated = false
                    dragOffset = .zero
                }
        )
    }

    @ViewBuilder
    private func DropIndicator() -> some View {
        HStack(spacing: 4) {
            Circle()
                .fill(DesignSystem.Colors.gray100.swiftUIColor)
                .frame(width: 8, height: 8)
            Rectangle()
                .fill(DesignSystem.Colors.gray100.swiftUIColor)
                .frame(height: 2)
        }
        .padding(.vertical, 4)
        .padding(.horizontal, 20)
    }

    @ViewBuilder
    private func DraggingCellOverlay(
        viewItem: GroupListViewItem,
        offset: CGSize,
        frame: CGRect
    ) -> some View {
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
        }
        .frame(width: frame.width, height: 56)
        .padding(.horizontal, 20)
        .background(DesignSystem.Colors.gray100.swiftUIColor)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .offset(x: frame.minX + offset.width, y: frame.minY + offset.height)
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
            .frame(height: 56)
            .padding(.horizontal, 20)
        }
    }
}

// MARK: - Drop Target Calculation
extension GroupListView {

    private func calculateDropTarget(at location: CGPoint) {
        // 셀 프레임으로 드롭 인덱스 계산
        var targetIndex = store.groupList.count
        for (index, viewItem) in store.groupList.enumerated() {
            if let frame = cellFrames[viewItem.id] {
                let midY = frame.midY
                if location.y < midY {
                    targetIndex = index
                    break
                }
            }
        }

        store.send(.view(.onDropTargetChanged(index: targetIndex)))
    }
}

// MARK: - PreferenceKey
struct GroupCellFramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]

    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}
