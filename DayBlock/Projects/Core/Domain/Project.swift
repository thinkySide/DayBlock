import ProjectDescription
import ProjectDescriptionHelpers

let project = Project(
    name: "Domain",
    targets: [
        .target(
            name: "Domain",
            destinations: .iOS,
            product: .framework,
            bundleId: "com.thinkyside.DayBlock.Domain",
            buildableFolders: ["Sources"],
            settings: .shared
        )
    ]
)
