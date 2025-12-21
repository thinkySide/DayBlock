import SwiftUI
import Tracking
import DesignSystem

@main
struct TrackingDemoApp: App {
    
    init() {
        DesignSystemFontFamily.registerAllCustomFonts()
    }
    
    var body: some Scene {
        WindowGroup {
            TrackingCarouselView()
        }
    }
}
