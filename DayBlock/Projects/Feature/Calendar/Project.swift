import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Calendar",
    targets: [
        .target(
            name: "Calendar",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Calendar",
            buildableFolders: ["Sources"],
            dependencies: [
                .TCA,
                .HorizonCalendar,
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Domain", path: "../../Core/Domain"),
                .project(target: "PersistentData", path: "../../Core/Data"),
                .project(target: "UserDefaults", path: "../../Core/Data"),
                .project(target: "Util", path: "../../Shared")
            ],
            settings: .shared
        ),
        .target(
            name: "CalendarDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.CalendarDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "🛠️Calendar",
                ]
            ),
            buildableFolders: ["Demo"],
            dependencies: [
                .target(name: "Calendar")
            ],
            settings: .shared
        )
    ]
)
