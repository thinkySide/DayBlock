//
//  SwiftDataImplement.swift
//  PersistentData
//
//  Created by 김민준 on 12/26/25.
//

import SwiftData
import Dependencies

private enum ModelContainerKey: DependencyKey {

    static let liveValue: ModelContainer = {
        let schema = Schema([
            BlockGroupSwiftData.self,
            BlockSwiftData.self
        ])

        let modelConfiguration = ModelConfiguration(
            schema: schema,
            isStoredInMemoryOnly: false
        )

        do {
            let container = try ModelContainer(
                for: schema,
                configurations: [modelConfiguration]
            )
            return container
        } catch {
            fatalError("ModelContainer 생성 실패: \(error)")
        }
    }()
}

// MARK: - ModelContainer Dependency
extension DependencyValues {
    public var modelContainer: ModelContainer {
        get { self[ModelContainerKey.self] }
        set { self[ModelContainerKey.self] = newValue }
    }
}
