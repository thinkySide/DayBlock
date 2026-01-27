//
//  BlockListView.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem
import Domain

public struct BlockListView: View {

    @Bindable private var store: StoreOf<BlockListFeature>

    public init(store: StoreOf<BlockListFeature>) {
        self.store = store
    }

    @State private var cellFrames: [UUID: CGRect] = [:]
    @State private var sectionFrames: [UUID: CGRect] = [:]
    @State private var draggingCellFrame: CGRect = .zero
    @State private var dragStartTime: Date?
    @State private var isDragActivated: Bool = false
    @State private var dragOffset: CGSize = .zero
    @State private var lastDropTargetUpdate: Date = .distantPast

    public var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 40) {
                ForEach(store.sectionList) { section in
                    BlockListSection(from: section)
                }
            }
            .padding(.vertical, 20)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.sectionList)
        }
        .coordinateSpace(name: "scroll")
        .overlay(alignment: .topLeading) {
            // 드래그 중인 셀 오버레이
            if let draggingBlock = store.draggingBlock,
               let fromGroup = store.draggingFromGroup {
                DraggingCellOverlay(
                    block: draggingBlock,
                    group: fromGroup,
                    offset: dragOffset,
                    frame: draggingCellFrame
                )
                .transition(.scale.combined(with: .opacity))
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.draggingBlock != nil)
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

// MARK: - SubViews
extension BlockListView {

    @ViewBuilder
    private func BlockListSection(from viewItem: BlockListViewItem) -> some View {
        VStack(alignment: .leading, spacing: 0) {
            Text(viewItem.group.name)
                .brandFont(.pretendard(.bold), 18)
                .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

            VStack(spacing: 0) {
                if viewItem.blockList.isEmpty {
                    // 드래그 중이고 해당 섹션이 드롭 타겟일 때만 표시
                    let isDropTarget = store.draggingBlock != nil && store.dropTargetGroupId == viewItem.group.id

                    EmptyDropZone()
                        .padding(.top, isDropTarget ? 12 : 0)
                        .frame(height: isDropTarget ? 40 : 0)
                        .opacity(isDropTarget ? 1 : 0)
                        .scaleEffect(isDropTarget ? 1 : 0.95)
                        .animation(.easeInOut(duration: 0.2), value: isDropTarget)
                } else {
                    ForEach(Array(viewItem.blockList.enumerated()), id: \.element.id) { index, blockViewItem in
                        BlockListSectionCell(
                            from: blockViewItem,
                            group: viewItem.group,
                            index: index
                        )
                    }
                    .padding(.top, 12)
                }
            }

            AddBlockButton(group: viewItem.group)
                .padding(.top, 16)
        }
        .padding(.horizontal, 20)
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: SectionFramePreferenceKey.self,
                    value: [viewItem.group.id: geo.frame(in: .named("scroll"))]
                )
            }
        )
        .onPreferenceChange(SectionFramePreferenceKey.self) { frames in
            sectionFrames.merge(frames) { _, new in new }
        }
    }

    @ViewBuilder
    private func BlockListSectionCell(
        from viewItem: BlockListViewItem.BlockViewItem,
        group: BlockGroup,
        index: Int
    ) -> some View {
        let isDragging = store.draggingBlock?.id == viewItem.id
        let isDropTarget = store.dropTargetGroupId == group.id && store.dropTargetIndex == index

        VStack(spacing: 0) {
            // 드롭 인디케이터 (위)
            if isDropTarget {
                DropIndicator()
                    .transition(.opacity.combined(with: .scale(scale: 0.8)))
            }

            HStack(spacing: 14) {
                IconBlock(
                    symbol: IconPalette.toIcon(from: viewItem.block.iconIndex),
                    color: ColorPalette.toColor(from: viewItem.block.colorIndex),
                    size: 32
                )

                VStack(alignment: .leading, spacing: 0) {
                    Text(viewItem.block.name)
                        .brandFont(.pretendard(.bold), 16)
                        .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

                    Text("total +\(viewItem.total)")
                        .brandFont(.poppins(.semiBold), 13)
                        .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                }

                Spacer()

                DesignSystem.Icons.arrowRight.swiftUIImage
                    .tint(DesignSystem.Colors.gray700.swiftUIColor)
            }
            .frame(height: 52)
            .contentShape(Rectangle())
            .opacity(isDragging ? 0.3 : 1.0)
        }
        .animation(.easeInOut(duration: 0.15), value: isDropTarget)
        .animation(.easeInOut(duration: 0.15), value: isDragging)
        .background(
            GeometryReader { geo in
                Color.clear.preference(
                    key: CellFramePreferenceKey.self,
                    value: [viewItem.id: geo.frame(in: .named("scroll"))]
                )
            }
        )
        .onPreferenceChange(CellFramePreferenceKey.self) { frames in
            cellFrames.merge(frames) { _, new in new }
        }
        .gesture(
            DragGesture(minimumDistance: 0, coordinateSpace: .named("scroll"))
                .onChanged { drag in
                    // 드래그 시작 시간 기록
                    if dragStartTime == nil {
                        dragStartTime = Date()
                    }

                    // 0.3초 경과 확인
                    let elapsed = Date().timeIntervalSince(dragStartTime ?? Date())

                    if !isDragActivated && elapsed >= 0.3 {
                        // 드래그 모드 활성화
                        isDragActivated = true
                        if let frame = cellFrames[viewItem.id] {
                            draggingCellFrame = frame
                        }
                        store.send(.view(.onDragStarted(viewItem, group)))
                    }

                    if isDragActivated {
                        // @State로 offset 업데이트 (store 거치지 않음)
                        dragOffset = drag.translation

                        // 드롭 타겟 계산은 throttle (60fps 기준 약 16ms마다)
                        let now = Date()
                        if now.timeIntervalSince(lastDropTargetUpdate) > 0.016 {
                            lastDropTargetUpdate = now
                            calculateDropTarget(at: drag.location)
                        }
                    }
                }
                .onEnded { drag in
                    let elapsed = Date().timeIntervalSince(dragStartTime ?? Date())
                    let distance = sqrt(pow(drag.translation.width, 2) + pow(drag.translation.height, 2))

                    if isDragActivated {
                        // 드래그 완료
                        store.send(.view(.onDragEnded))
                    } else if elapsed < 0.3 && distance < 10 {
                        // 짧은 탭으로 처리
                        store.send(.view(.onTapBlockCell(viewItem, group)))
                    }

                    // 상태 초기화
                    dragStartTime = nil
                    isDragActivated = false
                    dragOffset = .zero
                }
        )
    }

    @ViewBuilder
    private func EmptyDropZone() -> some View {
        RoundedRectangle(cornerRadius: 8)
            .stroke(
                DesignSystem.Colors.gray300.swiftUIColor,
                style: StrokeStyle(lineWidth: 2, dash: [5])
            )
            .frame(height: 40)
            .contentShape(Rectangle())
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
    }

    @ViewBuilder
    private func AddBlockButton(group: BlockGroup) -> some View {
        Button {
            store.send(.view(.onTapAddBlockButton(group)))
        } label: {
            HStack(spacing: 8) {
                DesignSystem.Icons.addCell.swiftUIImage
                    .resizable()
                    .frame(width: 32, height: 32)

                Text("블럭 추가하기")
                    .brandFont(.pretendard(.semiBold), 15)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                    .padding(.leading, 8)

                Spacer()
            }
            .frame(height: 40)
        }
    }

    @ViewBuilder
    private func DraggingCellOverlay(
        block: BlockListViewItem.BlockViewItem,
        group: BlockGroup,
        offset: CGSize,
        frame: CGRect
    ) -> some View {
        HStack(spacing: 14) {
            IconBlock(
                symbol: IconPalette.toIcon(from: block.block.iconIndex),
                color: ColorPalette.toColor(from: block.block.colorIndex),
                size: 32
            )

            VStack(alignment: .leading, spacing: 0) {
                Text(block.block.name)
                    .brandFont(.pretendard(.bold), 16)
                    .foregroundStyle(DesignSystem.Colors.gray900.swiftUIColor)

                Text("total +\(block.total)")
                    .brandFont(.poppins(.semiBold), 13)
                    .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
            }

            Spacer()
        }
        .frame(width: frame.width, height: 52)
        .padding(.horizontal, 20)
        .background(DesignSystem.Colors.gray100.swiftUIColor)
        .cornerRadius(8)
        .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
        .offset(x: frame.minX + offset.width, y: frame.minY + offset.height)
    }
}

// MARK: - Drop Target Calculation
extension BlockListView {

    private func calculateDropTarget(at location: CGPoint) {
        // 어떤 섹션에 있는지 찾기
        var targetGroupId: UUID?
        for (groupId, frame) in sectionFrames {
            if frame.contains(location) {
                targetGroupId = groupId
                break
            }
        }

        guard let groupId = targetGroupId,
              let section = store.sectionList[id: groupId] else {
            store.send(.view(.onDropTargetChanged(groupId: nil, index: nil)))
            return
        }

        // 빈 섹션이면 인덱스 0
        if section.blockList.isEmpty {
            store.send(.view(.onDropTargetChanged(groupId: groupId, index: 0)))
            return
        }

        // 셀 프레임으로 드롭 인덱스 계산
        var targetIndex = section.blockList.count
        for (index, blockViewItem) in section.blockList.enumerated() {
            if let frame = cellFrames[blockViewItem.id] {
                let midY = frame.midY
                if location.y < midY {
                    targetIndex = index
                    break
                }
            }
        }

        store.send(.view(.onDropTargetChanged(groupId: groupId, index: targetIndex)))
    }
}

// MARK: - PreferenceKeys
struct CellFramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]

    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}

struct SectionFramePreferenceKey: PreferenceKey {
    static var defaultValue: [UUID: CGRect] = [:]

    static func reduce(value: inout [UUID: CGRect], nextValue: () -> [UUID: CGRect]) {
        value.merge(nextValue()) { _, new in new }
    }
}
