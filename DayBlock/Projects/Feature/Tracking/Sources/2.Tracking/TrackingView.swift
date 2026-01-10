//
//  TrackingView.swift
//  Tracking
//
//  Created by 김민준 on 1/10/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct TrackingView: View {
    
    private var store: StoreOf<TrackingFeature>

    public init(store: StoreOf<TrackingFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("TrackingView")
        }
    }
}
