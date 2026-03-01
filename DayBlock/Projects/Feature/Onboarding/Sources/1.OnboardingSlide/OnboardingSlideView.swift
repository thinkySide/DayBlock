//
//  OnboardingSlideView.swift
//  Onboarding
//
//  Created by 김민준 on 3/1/26.
//

import SwiftUI
import ComposableArchitecture
import DesignSystem

public struct OnboardingSlideView: View {
    
    private var store: StoreOf<OnboardingSlideFeature>

    public init(store: StoreOf<OnboardingSlideFeature>) {
        self.store = store
    }
    
    public var body: some View {
        VStack(spacing: 0) {
            
        }
    }
}
