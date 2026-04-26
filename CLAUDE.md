# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview
This is a SwiftUI iOS application called "mutualism" - a location-based social networking app that allows users to connect with mutuals in their area. The app uses Core Data for persistence and follows MVVM architecture.

## Build and Development Commands
```bash
# Build the project
xcodebuild -project mutualism.xcodeproj -scheme mutualism build

# Run tests
xcodebuild test -project mutualism.xcodeproj -scheme mutualism -destination 'platform=iOS Simulator,name=iPhone 15'

# Clean build folder
xcodebuild clean -project mutualism.xcodeproj -scheme mutualism

# Open in Xcode
open mutualism.xcodeproj
```

## Architecture and Structure

### Core Components
- **mutualismApp.swift**: Main app entry point, sets up Core Data context
- **ContentView.swift**: Primary UI implementation with map view, activity feed, and user status toggle
- **Persistence.swift**: Core Data stack management with NSPersistentContainer

### Key Architectural Decisions
- **MVVM Pattern**: ViewModels (like `ContentViewModel`) handle business logic and state management
- **Core Data**: Used for data persistence with `PersistenceController` managing the stack
- **SwiftUI**: Native iOS UI framework with custom components (CustomToggleStyle, HeartShape)
- **MapKit Integration**: For displaying location-based mutual connections

### Development Guidelines
From .cursorrules:
- Prefer simple solutions and avoid code duplication
- Keep files under 200-300 lines (refactor if larger)
- Use SwiftUI's native components (List, NavigationView, TabView, SF Symbols)
- Employ VStack, HStack, ZStack for layouts; LazyVGrid/LazyHGrid for grids
- Never overwrite .env file without confirmation
- Mock data only for tests, not for dev/prod environments

### Testing
- Uses XCTest framework for unit tests
- XCUITest for UI testing
- Test files located in `mutualismTests/` and `mutualismUITests/`

### Current Features
- User availability toggle with custom animated toggle style
- Map view showing nearby mutuals with custom annotations
- Activity feed (placeholder implementation)
- Custom logo with heart icon overlay
- Invite friends and add mutual/activity actions (stub implementations)