// swift-tools-version: 6.0
import PackageDescription

#if TUIST
    import struct ProjectDescription.PackageSettings

    let packageSettings = PackageSettings(
        productTypes: [
            "ComposableArchitecture": .framework,
            "HorizonCalendar": .framework
        ]
    )
#endif

let package = Package(
    name: "DayBlock",
    dependencies: [
        .package(
            url: "https://github.com/pointfreeco/swift-composable-architecture.git",
            from: "1.23.1"
        ),
        .package(
            url: "https://github.com/airbnb/HorizonCalendar",
            from: "2.0.0"
        )
    ]
)
