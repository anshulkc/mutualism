# mutualism 🪴

Your friends are nearby. They just don't know it yet.

`mutualism` is a SwiftUI iOS app that whispers to second-degree connections: *"hey, I'm around, want to hang?"* — without doxxing your exact coordinates to the entire internet. Think: ambient presence, gentle nudges, real-life serendipity. Less doomscroll, more "wait you're in this coffee shop too??"

## Requirements

- Xcode 15+
- iOS 17+ (simulator or device)
- Swift 5.9+

## Getting started

Open the project in Xcode and run:

```bash
open mutualism.xcodeproj
```

Or build from the command line:

```bash
xcodebuild -project mutualism.xcodeproj -scheme mutualism build
```

## Common commands

```bash
# Run tests
xcodebuild test -project mutualism.xcodeproj -scheme mutualism \
  -destination 'platform=iOS Simulator,name=iPhone 15'

# Clean build folder
xcodebuild clean -project mutualism.xcodeproj -scheme mutualism
```

## Project structure

```
mutualism/
├── mutualismApp.swift          App entry point
├── ContentView.swift           Main view — map, feed, status toggle
├── Persistence.swift           Core Data stack
├── DesignSystem.swift          Design tokens (colors, type, spacing)
├── Components/                 Reusable UI components
├── Views/                      Screens (Onboarding, Profile, Settings)
├── ViewModels/                 MVVM view models
├── Services/                   Mocked APIs and telemetry
├── Assets.xcassets/            Image assets
└── mutualism.xcdatamodeld/     Core Data model
```

## How it's wired up 🔌

- **MVVM** because separating brains from beauty is good for everyone
- **Core Data** for the stuff that has to stick around between launches
- **SwiftUI + MapKit** for native vibes and that satisfying spring animation
- **Service layer** of friendly little mocks (`SerendipityService`, `TelemetryService`) standing in for the real backend until it shows up to the party

## The headline feature ✨

**Initiated Serendipity** — tell the app you're free for the next 90 minutes at the park, and it nudges nearby friends-of-friends without leaking your precise location. Privacy-respecting matchmaking for "wanna grab a drink?"

Full deep-dive: [`SERENDIPITY_README.md`](SERENDIPITY_README.md)

Other goodies:

- 🗺️  Map of nearby mutuals with custom pin annotations
- 👋 Onboarding flow (we promise it's short)
- 🪪 Profile & Settings
- 📰 Activity feed (currently a placeholder, please be patient)

## The look & feel 🎨

The aesthetic is "warm, calm, slightly chai-coded." Tokens live in `DesignSystem.swift`. Supporting reading material if you want to go deep:

- [`DESIGN_SYSTEM.md`](DESIGN_SYSTEM.md) — the bible
- [`CHAI_THEME_SUMMARY.md`](CHAI_THEME_SUMMARY.md) ☕ — the palette story
- [`CHAI_PALETTE_UNIFICATION.md`](CHAI_PALETTE_UNIFICATION.md) — when the chai got organized
- [`TYPOGRAPHY_CHANGES.md`](TYPOGRAPHY_CHANGES.md) — letters with feelings
- [`FONT_INSTALLATION_GUIDE.md`](FONT_INSTALLATION_GUIDE.md) — for when the fonts ghost you
- [`NAVIGATION_GUIDE.md`](NAVIGATION_GUIDE.md) — how to get around

Custom fonts are in `Fonts/` and registered via `Info.plist`. Treat them gently.

## Tests

- `mutualismTests/` — unit tests (XCTest)
- `mutualismUITests/` — UI tests (XCUITest)

## House rules 🏠

Cribbed from `.cursorrules`, the family handbook:

- Keep it simple. If you find yourself writing the same thing twice, stop and rethink 🛑
- Files over ~300 lines start to smell. Refactor before they ripen 🍌
- Use SwiftUI native components (`List`, `NavigationView`, `TabView`, SF Symbols)
- `VStack` / `HStack` / `ZStack` for layouts; `LazyVGrid` / `LazyHGrid` for grids
- Mock data lives in tests, **never** in dev or prod. We don't lie to users 🤝

---

*Made with care, mild chaos, and a lot of tea.* 🍵
