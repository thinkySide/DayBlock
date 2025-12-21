//
//  BlockAddEditView.swift
//  Block
//
//  Created by 김민준 on 12/21/25.
//

import SwiftUI
import DesignSystem
import ComposableArchitecture

public struct BlockAddEditView: View {

    public let store: StoreOf<BlockAddEditFeature>

    public init(store: StoreOf<BlockAddEditFeature>) {
        self.store = store
    }

    public var body: some View {
        Text("BlockAddEditView")
    }
}
