import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Tracking",
    targets: [
        .target(
            name: "Tracking",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Tracking",
            buildableFolders: ["Sources"],
            dependencies: [],
            settings: .shared
        ),
        .target(
            name: "TrackingDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.TrackingDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                ]
            ),
            buildableFolders: ["Demo"],
            dependencies: [
                .target(name: "Tracking")
            ],
            settings: .shared
        )
    ]
)
