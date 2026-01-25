//
//  BlockRepository.swift
//  PersistentData
//
//  Created by Claude on 1/10/26.
//

import Foundation
import SwiftData
import Dependencies
import DependenciesMacros
import Domain
import Util

@DependencyClient
public struct BlockRepository {
    public var createBlock: @Sendable (_ groupId: UUID, Block) async -> Void
    public var fetchBlockList: @Sendable (_ groupId: UUID) async -> [Block] = { _ in [] }
    public var updateBlock: @Sendable (_ blockId: UUID, Block) async -> Void
    public var deleteBlock: @Sendable (_ blockId: UUID) async -> Void
}

// MARK: - DependencyKey
extension BlockRepository: DependencyKey {

    @MainActor
    static let modelContext: ModelContext = {
        @Dependency(\.modelContainer) var modelContainer
        return modelContainer.mainContext
    }()

    public static var liveValue: BlockRepository {
        BlockRepository(
            createBlock: { groupId, block in
                do {
                    let groupDescriptor = FetchDescriptor<BlockGroupSwiftData>(
                        predicate: #Predicate { $0.id == groupId }
                    )

                    let targetGroup = try await Task { @MainActor in
                        try modelContext.fetch(groupDescriptor).first
                    }.value

                    guard let targetGroup else {
                        throw PersistentDataError.notFound
                    }

                    let blockDescriptor = FetchDescriptor<BlockSwiftData>(
                        predicate: #Predicate { $0.group.id == groupId }
                    )

                    let existingBlocks = try await Task { @MainActor in
                        try modelContext.fetch(blockDescriptor)
                    }.value

                    let nextOrder = (existingBlocks.map(\.order).max() ?? -1) + 1

                    let swiftDataBlock = BlockSwiftData(
                        id: block.id,
                        name: block.name,
                        output: block.output,
                        iconIndex: block.iconIndex,
                        colorIndex: block.colorIndex,
                        order: nextOrder,
                        group: targetGroup
                    )

                    try await MainActor.run {
                        modelContext.insert(swiftDataBlock)
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            fetchBlockList: { groupId in
                do {
                    var descriptor = FetchDescriptor<BlockSwiftData>(
                        predicate: #Predicate { $0.group.id == groupId }
                    )
                    descriptor.sortBy = [SortDescriptor(\.order, order: .forward)]

                    let blockList = try await Task { @MainActor in
                        try modelContext.fetch(descriptor)
                    }.value

                    return blockList.map { swiftData in
                        Block(
                            id: swiftData.id,
                            name: swiftData.name,
                            iconIndex: swiftData.iconIndex,
                            colorIndex: swiftData.colorIndex,
                            output: swiftData.output,
                            order: swiftData.order
                        )
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                    return []
                }
            },
            updateBlock: { id, block in
                do {
                    let descriptor = FetchDescriptor<BlockSwiftData>(
                        predicate: #Predicate { $0.id == id }
                    )

                    let targetBlock = try await Task { @MainActor in
                        try modelContext.fetch(descriptor).first
                    }.value

                    guard let targetBlock else {
                        throw PersistentDataError.notFound
                    }

                    targetBlock.name = block.name
                    targetBlock.iconIndex = block.iconIndex
                    targetBlock.output = block.output
                    targetBlock.order = block.order

                    try await MainActor.run {
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            deleteBlock: { id in
                do {
                    let descriptor = FetchDescriptor<BlockSwiftData>(
                        predicate: #Predicate { $0.id == id }
                    )

                    let targetBlock = try await Task { @MainActor in
                        try modelContext.fetch(descriptor).first
                    }.value

                    guard let targetBlock else {
                        throw PersistentDataError.notFound
                    }

                    try await MainActor.run {
                        modelContext.delete(targetBlock)
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            }
        )
    }
}

// MARK: - DependencyValues
extension DependencyValues {
    public var blockRepository: BlockRepository {
        get { self[BlockRepository.self] }
        set { self[BlockRepository.self] = newValue }
    }
}
