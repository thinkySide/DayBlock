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

    private var store: StoreOf<BlockListFeature>

    public init(store: StoreOf<BlockListFeature>) {
        self.store = store
    }

    public var body: some View {
        BlockListTableView(store: store)
            .onAppear {
                store.send(.view(.onAppear))
            }
    }
}

// MARK: - UIKit TableView
private struct BlockListTableView: UIViewControllerRepresentable {

    let store: StoreOf<BlockListFeature>

    func makeUIViewController(context: Context) -> UITableViewController {
        let vc = UITableViewController(style: .grouped)
        vc.tableView.dataSource = context.coordinator
        vc.tableView.delegate = context.coordinator
        vc.tableView.dragDelegate = context.coordinator
        vc.tableView.dropDelegate = context.coordinator
        vc.tableView.dragInteractionEnabled = true
        vc.tableView.separatorStyle = .none
        vc.tableView.backgroundColor = DesignSystem.Colors.gray0.color
        vc.tableView.register(UITableViewCell.self, forCellReuseIdentifier: "BlockCell")
        vc.tableView.register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: "SectionHeader"
        )
        vc.tableView.register(
            UITableViewHeaderFooterView.self,
            forHeaderFooterViewReuseIdentifier: "SectionFooter"
        )
        return vc
    }

    func updateUIViewController(_ vc: UITableViewController, context: Context) {
        let newSectionList = store.sectionList
        if context.coordinator.sectionList != newSectionList {
            context.coordinator.sectionList = newSectionList
            vc.tableView.reloadData()
        }
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(store: store)
    }
}

// MARK: - Coordinator
extension BlockListTableView {

    class Coordinator: NSObject,
                       UITableViewDataSource,
                       UITableViewDelegate,
                       UITableViewDragDelegate,
                       UITableViewDropDelegate {

        let store: StoreOf<BlockListFeature>
        var sectionList: IdentifiedArrayOf<BlockListViewItem> = []

        init(store: StoreOf<BlockListFeature>) {
            self.store = store
            self.sectionList = store.sectionList
        }

        // MARK: - DataSource
        func numberOfSections(in tableView: UITableView) -> Int {
            sectionList.count
        }

        func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
            sectionList[section].blockList.count
        }

        func tableView(
            _ tableView: UITableView,
            cellForRowAt indexPath: IndexPath
        ) -> UITableViewCell {
            let cell = tableView.dequeueReusableCell(withIdentifier: "BlockCell", for: indexPath)
            let viewItem = sectionList[indexPath.section].blockList[indexPath.row]

            cell.contentConfiguration = UIHostingConfiguration {
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

                        Text("total +\(viewItem.total.toValueString())")
                            .brandFont(.poppins(.semiBold), 13)
                            .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                    }

                    Spacer()

                    DesignSystem.Icons.arrowRight.swiftUIImage
                        .tint(DesignSystem.Colors.gray700.swiftUIColor)
                }
                .padding(.horizontal, 20)
                .frame(height: 52)
            }
            .margins(.all, 0)

            cell.selectionStyle = .none
            return cell
        }

        // MARK: - Section Header
        func tableView(
            _ tableView: UITableView,
            viewForHeaderInSection section: Int
        ) -> UIView? {
            let headerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "SectionHeader"
            )!
            let group = sectionList[section].group

            headerView.contentConfiguration = UIHostingConfiguration {
                HStack {
                    Text(group.name)
                        .brandFont(.pretendard(.bold), 18)
                        .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)

                    Spacer()
                }
                .padding(.leading, 22)
                .padding(.trailing, 20)
                .padding(.top, 8)
            }
            .margins(.all, 0)
            .background(DesignSystem.Colors.gray0.swiftUIColor)

            return headerView
        }

        func tableView(
            _ tableView: UITableView,
            heightForHeaderInSection section: Int
        ) -> CGFloat {
            48
        }

        // MARK: - Section Footer (Add Button)
        func tableView(
            _ tableView: UITableView,
            viewForFooterInSection section: Int
        ) -> UIView? {
            let footerView = tableView.dequeueReusableHeaderFooterView(
                withIdentifier: "SectionFooter"
            )!
            let group = sectionList[section].group
            let store = self.store

            footerView.contentConfiguration = UIHostingConfiguration {
                Button {
                    store.send(.view(.onTapAddBlockButton(group)))
                } label: {
                    HStack(spacing: 8) {
                        DesignSystem.Icons.addCell.swiftUIImage
                            .padding(.leading, 4)

                        Text("블럭 추가하기")
                            .brandFont(.pretendard(.semiBold), 15)
                            .foregroundStyle(DesignSystem.Colors.gray800.swiftUIColor)
                            .padding(.leading, 8)

                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .frame(height: 56)
                }
            }
            .margins(.all, 0)
            .background(.clear)

            return footerView
        }

        // MARK: - Drag
        func tableView(
            _ tableView: UITableView,
            itemsForBeginning session: UIDragSession,
            at indexPath: IndexPath
        ) -> [UIDragItem] {
            UIImpactFeedbackGenerator(style: .medium).impactOccurred()
            let dragItem = UIDragItem(itemProvider: NSItemProvider())
            dragItem.localObject = indexPath
            return [dragItem]
        }

        // MARK: - Drop
        func tableView(
            _ tableView: UITableView,
            canHandle session: any UIDropSession
        ) -> Bool {
            session.localDragSession != nil
        }

        func tableView(
            _ tableView: UITableView,
            dropSessionDidUpdate session: any UIDropSession,
            withDestinationIndexPath destinationIndexPath: IndexPath?
        ) -> UITableViewDropProposal {
            guard session.localDragSession != nil else {
                return UITableViewDropProposal(operation: .cancel)
            }
            return UITableViewDropProposal(
                operation: .move,
                intent: .insertAtDestinationIndexPath
            )
        }

        func tableView(
            _ tableView: UITableView,
            performDropWith coordinator: any UITableViewDropCoordinator
        ) {
            guard let dragItem = coordinator.items.first,
                  let sourceIndexPath = dragItem.sourceIndexPath else { return }

            // destinationIndexPath가 nil이면 마지막 섹션의 끝으로 이동
            let destinationIndexPath = coordinator.destinationIndexPath
                ?? IndexPath(
                    row: sectionList[sectionList.count - 1].blockList.count,
                    section: sectionList.count - 1
                )

            let block = sectionList[sourceIndexPath.section]
                .blockList.remove(at: sourceIndexPath.row)
            sectionList[destinationIndexPath.section]
                .blockList.insert(block, at: destinationIndexPath.row)

            UIImpactFeedbackGenerator(style: .soft).impactOccurred()

            tableView.performBatchUpdates {
                tableView.moveRow(at: sourceIndexPath, to: destinationIndexPath)
            }

            coordinator.drop(dragItem.dragItem, toRowAt: destinationIndexPath)

            store.send(.view(.onMoveBlock(
                fromSection: sourceIndexPath.section,
                fromIndex: sourceIndexPath.row,
                toSection: destinationIndexPath.section,
                toIndex: destinationIndexPath.row
            )))
        }

        // MARK: - Selection
        func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
            tableView.deselectRow(at: indexPath, animated: true)
            let block = sectionList[indexPath.section].blockList[indexPath.row]
            let group = sectionList[indexPath.section].group
            store.send(.view(.onTapBlockCell(block, group)))
        }
    }
}
