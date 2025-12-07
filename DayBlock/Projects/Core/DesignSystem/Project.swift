import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "DesignSystem",
    targets: [
        .target(
            name: "DesignSystem",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.DesignSystem",
            buildableFolders: [
                "Sources",
                "Resources"
            ],
            settings: .shared
        ),
        .target(
            name: "Storybook",
            destinations: .iOS,
            product: .app,
            bundleId: "com.thinkyside.DayBlock.Storybook",
            infoPlist: .extendingDefault(with: ["UILaunchScreen": [:]]),
            buildableFolders: ["Storybook"],
            dependencies: [
                .target(name: "DesignSystem")
            ],
            settings: .shared
        )
    ],
    resourceSynthesizers: [
        .assets(),
        .fonts()
    ]
)
