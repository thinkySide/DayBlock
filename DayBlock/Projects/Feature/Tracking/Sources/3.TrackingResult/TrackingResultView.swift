//
//  TrackingResultView.swift
//  Tracking
//
//  Created by 김민준 on 1/24/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct TrackingResultView: View {
    
    private var store: StoreOf<TrackingResultFeature>

    public init(store: StoreOf<TrackingResultFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            Text("TrackingResultFeature")
        }
        .background(DesignSystem.Colors.gray0.swiftUIColor)
    }
}
