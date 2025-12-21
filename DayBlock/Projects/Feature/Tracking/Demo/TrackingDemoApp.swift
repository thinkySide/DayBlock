import SwiftUI
import Tracking
import DesignSystem
import ComposableArchitecture

@main
struct TrackingDemoApp: App {
    
    let store = Store(initialState: .init()) {
        TrackingCarouselFeature()
    }
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TrackingCarouselView(store: store)
        }
    }
}
