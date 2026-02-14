//
//  MyInfoListView.swift
//  MyInfo
//
//  Created by 김민준 on 2/14/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct MyInfoListView: View {
    
    private var store: StoreOf<MyInfoListFeature>

    public init(store: StoreOf<MyInfoListFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
        }
    }
}
