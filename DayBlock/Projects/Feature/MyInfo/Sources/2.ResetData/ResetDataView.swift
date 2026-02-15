//
//  ResetDataView.swift
//  MyInfo
//
//  Created by 김민준 on 2/15/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct ResetDataView: View {
    
    private var store: StoreOf<ResetDataFeature>

    public init(store: StoreOf<ResetDataFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
        }
    }
}
