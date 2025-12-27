//
//  GroupSelectView.swift
//  Editor
//
//  Created by 김민준 on 12/27/25.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct GroupSelectView: View {
    
    private var store: StoreOf<GroupSelectFeature>

    public init(store: StoreOf<GroupSelectFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
