//
//  IconSelectView.swift
//  Editor
//
//  Created by 김민준 on 12/26/25.
//

import SwiftUI
import ComposableArchitecture

public struct IconSelectView: View {
    
    private var store: StoreOf<IconSelectFeature>

    public init(store: StoreOf<IconSelectFeature>) {
        self.store = store
    }
    
    public var body: some View {
        Text(/*@START_MENU_TOKEN@*/"Hello, World!"/*@END_MENU_TOKEN@*/)
    }
}
