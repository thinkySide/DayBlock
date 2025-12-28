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

    public var createGroup: @Sendable (BlockGroup) -> Void
    public var fetchGroupList: @Sendable () -> [BlockGroup] = { [] }
    public var updateGroup: @Sendable (_ groupId: UUID, BlockGroup) -> Void
    public var deleteGroup: @Sendable (_ groupId: UUID) -> Void

    public var createBlock: @Sendable (_ groupId: UUID, Block) -> Void
    public var fetchBlockList: @Sendable (_ groupId: UUID) -> [Block] = { _ in [] }
    public var updateBlock: @Sendable (_ blockId: UUID, Block) -> Void
    public var deleteBlock: @Sendable (_ blockId: UUID) -> Void
}

// MARK: - DependencyKey
extension SwiftDataRepository: DependencyKey {

    public static var liveValue: SwiftDataRepository {
        SwiftDataRepository(
            createGroup: { group in
                @Dependency(\.modelContext) var modelContext
                let swiftDataGroup = BlockGroupSwiftData(
                    name: group.name,
                    colorIndex: group.colorIndex,
                    blockList: []
                )
                modelContext.insert(swiftDataGroup)
                do {
                    try modelContext.save()
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            fetchGroupList: {
                @Dependency(\.modelContext) var modelContext
                let descriptor = FetchDescriptor<BlockGroupSwiftData>()
                do {
                    let groups = try modelContext.fetch(descriptor)
                    return groups.map { swiftData in
                        BlockGroup(
                            name: swiftData.name,
                            colorIndex: swiftData.colorIndex
                        )
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                    return []
                }
            },
            updateGroup: { id, group in
                @Dependency(\.modelContext) var modelContext
                let descriptor = FetchDescriptor<BlockGroupSwiftData>(
                    predicate: #Predicate { $0.id == id }
                )
                do {
                    guard let existingGroup = try modelContext.fetch(descriptor).first else {
                        throw PersistentDataError.notFound
                    }
                    existingGroup.name = group.name
                    existingGroup.colorIndex = group.colorIndex
                    try modelContext.save()
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            deleteGroup: { id in
                @Dependency(\.modelContext) var modelContext
                let descriptor = FetchDescriptor<BlockGroupSwiftData>(
                    predicate: #Predicate { $0.id == id }
                )
                do {
                    guard let groupToDelete = try modelContext.fetch(descriptor).first else {
                        throw PersistentDataError.notFound
                    }
                    modelContext.delete(groupToDelete)
                    try modelContext.save()
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            createBlock: { groupId, block in
                @Dependency(\.modelContext) var modelContext
                let groupDescriptor = FetchDescriptor<BlockGroupSwiftData>(
                    predicate: #Predicate { $0.id == groupId }
                )
                do {
                    guard let group = try modelContext.fetch(groupDescriptor).first else {
                        throw PersistentDataError.notFound
                    }

                    let swiftDataBlock = BlockSwiftData(
                        id: UUID(),
                        name: block.name,
                        output: block.output,
                        iconIndex: block.iconIndex,
                        group: group
                    )
                    modelContext.insert(swiftDataBlock)
                    try modelContext.save()
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            fetchBlockList: { groupId in
                @Dependency(\.modelContext) var modelContext
                let descriptor = FetchDescriptor<BlockSwiftData>(
                    predicate: #Predicate { $0.group.id == groupId }
                )
                do {
                    let blocks = try modelContext.fetch(descriptor)
                    return blocks.map { swiftData in
                        Block(
                            name: swiftData.name,
                            iconIndex: swiftData.iconIndex,
                            output: swiftData.output
                        )
                    }
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                    return []
                }
            },
            updateBlock: { id, block in
                @Dependency(\.modelContext) var modelContext
                let descriptor = FetchDescriptor<BlockSwiftData>(
                    predicate: #Predicate { $0.id == id }
                )
                do {
                    guard let existingBlock = try modelContext.fetch(descriptor).first else {
                        throw PersistentDataError.notFound
                    }
                    existingBlock.name = block.name
                    existingBlock.iconIndex = block.iconIndex
                    existingBlock.output = block.output
                    try modelContext.save()
                } catch {
                    Debug.log("SwiftData ModelContext 에러: \(error)")
                }
            },
            deleteBlock: { id in
                @Dependency(\.modelContext) var modelContext
                let descriptor = FetchDescriptor<BlockSwiftData>(
                    predicate: #Predicate { $0.id == id }
                )
                do {
                    guard let blockToDelete = try modelContext.fetch(descriptor).first else {
                        throw PersistentDataError.notFound
                    }
                    modelContext.delete(blockToDelete)
                    try modelContext.save()
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
