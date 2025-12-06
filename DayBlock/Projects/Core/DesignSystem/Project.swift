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
        )
    ],
    resourceSynthesizers: [
        .assets()
    ]
)
