import SwiftUI
import Tracking
import DesignSystem
import ComposableArchitecture
import SwiftData

@main
struct TrackingDemoApp: App {
    
    let store = Store(initialState: .init()) {
        TrackingCarouselFeature()
    }
    
    @Dependency(\.modelContainer) private var modelContainer
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TrackingCarouselView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
