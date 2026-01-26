//
//  GroupListView.swift
//  ManagementDemoApp
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct GroupListView: View {
    
    private var store: StoreOf<GroupListFeature>

    public init(store: StoreOf<GroupListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        ScrollView {
            Text("GroupList")
        }
    }
}
