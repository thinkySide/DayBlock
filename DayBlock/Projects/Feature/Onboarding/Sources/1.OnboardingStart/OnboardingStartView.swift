//
//  OnboardingStartView.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct OnboardingStartView: View {
    
    private var store: StoreOf<OnboardingStartFeature>

    public init(store: StoreOf<OnboardingStartFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
        }
    }
}
