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
    @State private var previewImage: UIImage?
    @State private var dragLocation: CGPoint = .zero
    @State private var sourceFrame: CGRect = .zero
    @State private var dragOffset: CGSize = .zero
    @GestureState private var isDragActive: Bool = false

    public init(store: StoreOf<GroupListFeature>) {
        self.store = store
    }

    public var body: some View {
        ScrollView {
            VStack(spacing: 0) {
                ForEach(store.groupList) { viewItem in
                    GroupCell(from: viewItem)
                }

                AddGroupButton()
            }
            .padding(.vertical, 6)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: store.groupList)
        }
        .coordinateSpace(name: "scroll")
        .overlay(alignment: .topLeading) {
            if store.draggingGroup != nil, let image = previewImage {
                Image(uiImage: image)
                    .shadow(color: .black.opacity(0.15), radius: 8, x: 0, y: 4)
                    .offset(
                        x: sourceFrame.minX + dragOffset.width,
                        y: sourceFrame.minY + dragOffset.height
                    )
            }
        }
        .animation(.easeInOut(duration: 0.2), value: store.draggingGroup != nil)
        .onChange(of: isDragActive) { _, isActive in
            if !isActive {
                handleDragEnd()
            }
        }
        .onAppear {
            store.send(.view(.onAppear))
        }
    }
}

// MARK: - Drag End
extension GroupListView {

    private func handleDragEnd() {
        if store.draggingGroup != nil {
            store.send(.view(.onDragEnded))
        }
        previewImage = nil
        dragOffset = .zero
        dragLocation = .zero
        sourceFrame = .zero
    }
}

// MARK: - SubViews
extension GroupListView {

    @ViewBuilder
    private func GroupCell(from viewItem: GroupListViewItem) -> some View {
        let isDragging = store.draggingGroup?.id == viewItem.id
        let isHovered = store.draggingGroup != nil
            && store.draggingGroup?.id != viewItem.id

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
        .opacity(isDragging ? 0 : 1.0)
        .onGeometryChange(for: CGRect.self) { proxy in
            proxy.frame(in: .named("scroll"))
        } action: { newFrame in
            cellFrames[viewItem.id] = newFrame
        }
        .onChange(of: dragLocation) { _, location in
            guard isHovered,
                  let frame = cellFrames[viewItem.id],
                  frame.contains(location),
                  let source = store.draggingGroup else { return }
            store.send(.view(.onSwapGroup(source: source, target: viewItem)))
        }
        .onTapGesture {
            store.send(.view(.onTapGroupCell(viewItem)))
        }
        .gesture(
            LongPressGesture(minimumDuration: 0.3)
                .sequenced(before: DragGesture(coordinateSpace: .named("scroll")))
                .updating($isDragActive) { _, state, _ in
                    state = true
                }
                .onChanged { value in
                    if case .second(true, let drag) = value {
                        if previewImage == nil {
                            if let frame = cellFrames[viewItem.id] {
                                sourceFrame = frame
                            }
                            previewImage = createPreviewImage(for: viewItem)
                            store.send(.view(.onDragStarted(viewItem)))
                        }

                        if let drag {
                            dragOffset = drag.translation
                            dragLocation = drag.location
                        }
                    }
                }
        )
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

// MARK: - Preview Image
extension GroupListView {

    private func createPreviewImage(for viewItem: GroupListViewItem) -> UIImage? {
        let content = HStack(spacing: 0) {
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
        .frame(width: sourceFrame.width, height: 56)
        .padding(.horizontal, 20)
        .background(DesignSystem.Colors.gray100.swiftUIColor)
        .clipShape(RoundedRectangle(cornerRadius: 8))

        let renderer = ImageRenderer(content: content)
        renderer.scale = UIScreen.main.scale
        return renderer.uiImage
    }
}
