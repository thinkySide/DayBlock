import SwiftUI
import Tracking
import DesignSystem
import ComposableArchitecture
import SwiftData

@main
struct TrackingDemoApp: App {
    
    let store = Store(initialState: .init()) {
        BlockCarouselFeature()
    }
    
    @Dependency(\.modelContainer) private var modelContainer
    
    init() {
        DesignSystemConfiguration.configure()
    }
    
    var body: some Scene {
        WindowGroup {
            BlockCarouselView(store: store)
        }
        .modelContainer(modelContainer)
    }
}
