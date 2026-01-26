//
//  ManagementTabView.swift
//  Management
//
//  Created by 김민준 on 1/26/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct ManagementTabView: View {
    
    private var store: StoreOf<ManagementTabFeature>

    public init(store: StoreOf<ManagementTabFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
        }
    }
}
