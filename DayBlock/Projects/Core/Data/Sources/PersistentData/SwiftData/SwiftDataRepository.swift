//
//  SwiftDataRepository.swift
//  PersistentData
//
//  Created by 김민준 on 12/26/25.
//

import Foundation
import SwiftData
import Dependencies
import DependenciesMacros
import Domain
import Util

@DependencyClient
public struct SwiftDataRepository {

    public var createGroup: @Sendable (BlockGroup) async -> Void
    public var fetchDefaultGroup: @Sendable () async -> BlockGroup = { .init(id: .init(), name: "", colorIndex: 0, order: 0) }
    public var fetchGroupList: @Sendable () async -> [BlockGroup] = { [] }
    public var updateGroup: @Sendable (_ groupId: UUID, BlockGroup) async -> Void
    public var deleteGroup: @Sendable (_ groupId: UUID) async -> Void

    public var createBlock: @Sendable (_ groupId: UUID, Block) async -> Void
    public var fetchBlockList: @Sendable (_ groupId: UUID) async -> [Block] = { _ in [] }
    public var updateBlock: @Sendable (_ blockId: UUID, Block) async -> Void
    public var deleteBlock: @Sendable (_ blockId: UUID) async -> Void
}

// MARK: - DependencyKey
extension SwiftDataRepository: DependencyKey {
    
    @MainActor
    static let modelContext: ModelContext = {
        @Dependency(\.modelContainer) var modelContainer
        return modelContainer.mainContext
    }()

    public static var liveValue: SwiftDataRepository {
        SwiftDataRepository(
            createGroup: { group in
                do {
                    let descriptor = FetchDescriptor<BlockGroupSwiftData>()
                    let existingGroups = try await Task { @MainActor in
                        try modelContext.fetch(descriptor)
                    }.value

                    let nextOrder = (existingGroups.map(\.order).max() ?? -1) + 1

                    let swiftDataGroup = BlockGroupSwiftData(
                        id: group.id,
                        name: group.name,
                        colorIndex: group.colorIndex,
                        order: nextOrder,
                        blockList: []
                    )
                    try await MainActor.run {
                        modelContext.insert(swiftDataGroup)
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            fetchDefaultGroup: {
                do {
                    let descriptor = FetchDescriptor<BlockGroupSwiftData>()
                    var groupList = try await Task { @MainActor in
                        return try modelContext.fetch(descriptor)
                    }.value

                    if groupList.isEmpty {
                        @Dependency(\.uuid) var uuid
                        let defaultGroup = BlockGroupSwiftData(
                            id: uuid(),
                            name: "기본 그룹",
                            colorIndex: 4,
                            order: 0,
                            blockList: []
                        )

                        try await MainActor.run {
                            modelContext.insert(defaultGroup)
                            try modelContext.save()
                        }

                        groupList = [defaultGroup]
                    }
                    guard let firstGroup = groupList.first else {
                        return BlockGroup(id: .init(), name: "기본 그룹", colorIndex: 4, order: 0)
                    }
                    return BlockGroup(
                        id: firstGroup.id,
                        name: firstGroup.name,
                        colorIndex: firstGroup.colorIndex,
                        order: firstGroup.order
                    )
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                    return BlockGroup(id: .init(), name: "기본 그룹", colorIndex: 4, order: 0)
                }
            },
            fetchGroupList: {
                do {
                    var descriptor = FetchDescriptor<BlockGroupSwiftData>()
                    descriptor.sortBy = [SortDescriptor(\.order, order: .forward)]
                    var groupList = try await Task { @MainActor in
                        return try modelContext.fetch(descriptor)
                    }.value
                    if groupList.isEmpty {
                        @Dependency(\.uuid) var uuid
                        let defaultGroup = BlockGroupSwiftData(
                            id: uuid(),
                            name: "기본 그룹",
                            colorIndex: 4,
                            order: 0,
                            blockList: []
                        )
                        try await MainActor.run {
                            modelContext.insert(defaultGroup)
                            try modelContext.save()
                        }
                        groupList = [defaultGroup]
                    }

                    return groupList.map { swiftData in
                        BlockGroup(
                            id: swiftData.id,
                            name: swiftData.name,
                            colorIndex: swiftData.colorIndex,
                            order: swiftData.order
                        )
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                    return []
                }
            },
            updateGroup: { id, group in
                do {
                    let descriptor = FetchDescriptor<BlockGroupSwiftData>(
                        predicate: #Predicate { $0.id == id }
                    )
                    let targetGroup = try await Task { @MainActor in
                        try modelContext.fetch(descriptor).first
                    }.value

                    guard let targetGroup else {
                        throw PersistentDataError.notFound
                    }
                    targetGroup.name = group.name
                    targetGroup.colorIndex = group.colorIndex
                    targetGroup.order = group.order
                    try await MainActor.run {
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            deleteGroup: { id in
                do {
                    let descriptor = FetchDescriptor<BlockGroupSwiftData>(
                        predicate: #Predicate { $0.id == id }
                    )
                    
                    let targetGroup = try await Task { @MainActor in
                        try modelContext.fetch(descriptor).first
                    }.value
                    
                    guard let targetGroup else {
                        throw PersistentDataError.notFound
                    }

                    try await MainActor.run {
                        modelContext.delete(targetGroup)
                        try modelContext.save()
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
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

                    @Dependency(\.uuid) var uuid
                    let swiftDataBlock = BlockSwiftData(
                        id: uuid(),
                        name: block.name,
                        output: block.output,
                        iconIndex: block.iconIndex,
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
    public var swiftDataRepository: SwiftDataRepository {
        get { self[SwiftDataRepository.self] }
        set { self[SwiftDataRepository.self] = newValue }
    }
}
