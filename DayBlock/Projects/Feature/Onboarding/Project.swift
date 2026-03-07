import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Onboarding",
    targets: [
        .target(
            name: "Onboarding",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Onboarding",
            buildableFolders: ["Sources"],
            dependencies: [
                .TCA,
                .project(target: "DesignSystem", path: "../../Core/DesignSystem"),
                .project(target: "Domain", path: "../../Core/Domain"),
                .project(target: "PersistentData", path: "../../Core/Data"),
                .project(target: "UserDefaults", path: "../../Core/Data"),
                .project(target: "Util", path: "../../Shared"),
                .project(target: "Editor", path: "../Editor")
            ],
            settings: .shared
        ),
        .target(
            name: "OnboardingDemoApp",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.OnboardingDemoApp",
            infoPlist: .extendingDefault(
                with: [
                    "UILaunchScreen": [
                        "UIColorName": "",
                        "UIImageName": "",
                    ],
                    "CFBundleDisplayName": "🛠️Onboarding",
                ]
            ),
            buildableFolders: ["Demo"],
            dependencies: [
                .target(name: "Onboarding")
            ],
            settings: .shared
        )
    ]
)
