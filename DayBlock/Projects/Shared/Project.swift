import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Shared",
    targets: [
        .target(
            name: "Util",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Util",
            buildableFolders: ["Sources/Util"],
            settings: .shared
        )
    ]
)
