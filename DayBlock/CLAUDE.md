# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

DayBlock is an iOS app built with SwiftUI and The Composable Architecture (TCA). The project uses Tuist for modular architecture and dependency management.

## Build System

### Tuist Commands

```bash
# Generate Xcode project from Tuist manifests
tuist generate

# Clean Tuist cache
tuist clean

# Edit Tuist project manifests
tuist edit
```

After modifying any `Project.swift` files or Tuist configuration, always run `tuist generate` to regenerate the Xcode project.

### Running the App

- **Main App**: Select the `App` scheme in Xcode
- **Feature Demo Apps**: Each feature module has its own demo app (e.g., `TrackingDemoApp`) for isolated development and testing

## Architecture

### Module Structure

The project follows a modular architecture organized into layers:

```
Projects/
├── App/              # Main application target
├── Core/             # Core infrastructure modules
│   ├── Domain/       # Pure domain models (Block, BlockGroup)
│   ├── Data/         # Data layer
│   │   ├── PersistentData/  # SwiftData repository
│   │   └── UserDefaults/    # UserDefaults service
│   └── DesignSystem/ # UI components, fonts, colors, symbols
├── Feature/          # Feature modules
│   ├── Tracking/     # Main tracking feature
│   └── Editor/       # Editing features (BlockEditor, GroupEditor, etc.)
└── Shared/           # Shared utilities
    └── Util/         # Extensions, helpers, TCA utilities
```

### Dependency Rules

- **Domain**: No dependencies (pure Swift models)
- **Data**: Depends on Domain, Util, TCA
- **DesignSystem**: Minimal dependencies
- **Feature**: Can depend on Core modules and other Features
- **Shared/Util**: Now depends on TCA for Dependency injection (HapticClient, etc.)

### TCA Architecture Pattern

All features follow a consistent TCA pattern with structured actions:

```swift
public enum Action: TCAFeatureAction, BindableAction {
    public enum ViewAction {
        // User-initiated actions from the view
    }

    public enum InnerAction {
        // Internal state management actions
    }

    public enum DelegateAction {
        // Actions to communicate with parent features
    }

    case view(ViewAction)
    case inner(InnerAction)
    case delegate(DelegateAction)
    case binding(BindingAction<State>)
}
```

This pattern is enforced by the `TCAFeatureAction` protocol in `Shared/Util/TCAFeatureAction.swift`.

### Data Layer

**SwiftData Repository**:
- Located in `Projects/Core/Data/Sources/PersistentData/SwiftData/`
- Models: `BlockSwiftData`, `BlockGroupSwiftData`
- Repository: `SwiftDataRepository` - handles all database operations
- Accessed via TCA Dependency: `@Dependency(\.swiftDataRepository)`

**UserDefaults Service**:
- Type-safe UserDefaults wrapper
- Key definitions in `UserDefaultsKey.swift` and `UserDefaultsKeyGroup.swift`
- Accessed via TCA Dependency: `@Dependency(\.userDefaultsService)`
- Supports domain-based storage with `UserDefaultsDomain`

### Dependency Injection

The project uses TCA's dependency system for all services:

```swift
// In Reducer
@Dependency(\.haptic) private var haptic
@Dependency(\.swiftDataRepository) private var swiftDataRepository
@Dependency(\.userDefaultsService) private var userDefaultsService
@Dependency(\.date) private var date
@Dependency(\.continuousClock) private var clock

// Services are defined with DependencyKey protocol
// See: HapticClient.swift, SwiftDataRepository.swift, UserDefaultsService.swift
```

When adding a new dependency:
1. Create a protocol defining the service interface
2. Implement `DependencyKey` with `liveValue` and `testValue`
3. Extend `DependencyValues` with computed property
4. If the dependency imports `Dependencies`, ensure the module's `Project.swift` includes `.TCA` dependency

### Tuist Configuration

**External Dependencies**:
- Defined in `Tuist/Package.swift`
- Currently uses TCA (swift-composable-architecture) v1.23.1
- Helper extension in `Tuist/ProjectDescriptionHelpers/TargetDependency++.swift` provides `.TCA` shorthand

**Shared Settings**:
- `Tuist/ProjectDescriptionHelpers/Settings++.swift` defines `.shared` settings
- iOS deployment target: 18.0

## Design System

### UI Components

Located in `Projects/Core/DesignSystem/Sources/UIComponents/`:
- Reusable SwiftUI components
- Example: `CarouselDayBlock` - animated block component with front/back variations

### Resources

- **Fonts**: `DesignSystem/Sources/Font/`
- **Colors**: `DesignSystem/Sources/Palette/` - Color palette definitions
- **SF Symbols**: `DesignSystem/Sources/Symbols/` - Symbol name enums

## Common Patterns

### Haptic Feedback

Use the `HapticClient` dependency for haptic feedback:

```swift
@Dependency(\.haptic) var haptic

// Usage
haptic.impact(.soft)       // Light impact
haptic.impact(.medium)     // Medium impact
haptic.impact(.heavy)      // Heavy impact
haptic.notification(.success)  // Success notification
haptic.notification(.error)    // Error notification
haptic.selection()         // Selection changed
```

**Important**: When triggering haptics on state changes (like `binding(\.focusedBlock)`), consider whether the change is user-initiated or programmatic. Use a flag (e.g., `shouldTriggerHaptic`) to prevent unwanted haptics during:
- Initial view load
- Programmatic state updates
- Data refresh operations

### State Management Flags

Common pattern for distinguishing user actions from programmatic updates:

```swift
@ObservableState
public struct State {
    var shouldTriggerHaptic: Bool = true
    var previousValue: SomeValue?
}

// Before programmatic update
state.shouldTriggerHaptic = false
state.value = newValue

// In binding reducer
case .binding(\.value):
    if state.shouldTriggerHaptic && state.previousValue != state.value {
        haptic.impact(.soft)
    }
    state.previousValue = state.value
    state.shouldTriggerHaptic = true  // Reset for next user interaction
```

### Concurrency

**IMPORTANT**: Always use Swift's modern concurrency (Task, async/await) instead of DispatchQueue.

```swift
// ✅ GOOD: Use Task with async/await
Task { @MainActor in
    try? await Task.sleep(for: .milliseconds(100))
    // Perform work
}

// ❌ BAD: Don't use DispatchQueue
DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
    // Perform work
}
```

**Task patterns**:
- Use `@MainActor` annotation for UI updates
- Use `Task.sleep(for:)` for delays (not `Thread.sleep`)
- Use `Task.detached` for background work that doesn't need actor context
- Always handle cancellation with `Task.isCancelled` for long-running operations

## Code Style

### File Organization

Features are organized by numbered prefixes for visual ordering:
- `1.TrackingCarousel/`
- `2.GroupEditor/`
- etc.

### SwiftUI Extensions

Utility extensions are in `Shared/Util/`:
- View modifiers (e.g., `OnLoadViewModifier`, `DisableToolBarItem`)
- Date formatting extensions
- String utilities
- Pop gesture customization

## Troubleshooting

### Duplicate Symbol Errors

If you encounter duplicate class errors from `Dependencies` or `IssueReporting`:
- Ensure any module importing `Dependencies` has `.TCA` in its dependencies in `Project.swift`
- Run `tuist clean` and `tuist generate`
- The `Dependencies` package is embedded in TCA and should not be linked separately

### Module Not Found

After adding new modules or changing dependencies:
1. Run `tuist generate`
2. Clean build folder (Cmd+Shift+K)
3. Rebuild project
