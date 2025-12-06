import ProjectDescription

public extension Settings {
    static let shared = Settings.settings(
        base: [
            "IPHONEOS_DEPLOYMENT_TARGET": "18.0",
            "DEVELOPMENT_TEAM": "9XG4S4XZWN"
        ]
    )
}
