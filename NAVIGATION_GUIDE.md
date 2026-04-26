# Navigation Guide

## App Structure

```
MainTabView (Root)
├── Tab 0: PeopleMemoriesView
│   ├── People/Memories Tab Switcher
│   ├── Close Friends Section
│   └── Compatibility Section
│
├── Tab 1: Camera/Add (Placeholder)
│
└── Tab 2: ProfileView
    ├── Referrals Button (top-left)
    ├── Hamburger Menu (top-right)
    └── → Opens SettingsView (sheet)
        ├── INFO Section
        ├── SETTINGS Section
        ├── SUPPORT Section
        ├── ABOUT Section
        └── MANAGE Section
```

## Navigation Flow

### Bottom Navigation Bar
- **Tab 0** (Gallery icon): Takes you to People/Memories content
- **Tab 1** (Camera icon with badge "4"): Placeholder for camera/add functionality
- **Tab 2** (Profile icon with badge "1"): Takes you to Profile view

### Profile View
- **Top-left**: Referrals button (gift icon)
- **Top-right**: Hamburger menu (3 horizontal lines)
  - Tapping this opens the Settings page as a modal sheet
  
### Settings View
- **Back button** (top-left chevron): Dismisses settings and returns to profile
- **Grouped sections** with list items:
  - INFO: Display-only fields (name, phone)
  - SETTINGS: Interactive items (subscription, payment, notifications)
  - SUPPORT: Contact options
  - ABOUT: Information pages
  - MANAGE: Account actions (pause, logout, delete)

## User Journey Example

1. User launches app → Sees People/Memories view (Tab 0)
2. User taps Profile icon (bottom nav) → Navigates to Profile view
3. User taps hamburger menu (⋮) → Settings sheet slides up
4. User browses settings sections
5. User taps back chevron or swipes down → Returns to Profile
6. User taps Gallery icon (bottom nav) → Returns to main content

## Components Used

### Main Views
- `MainTabView`: Root container with tab state
- `PeopleMemoriesView`: Main content (people/compatibility)
- `ProfileView`: User profile with name/title
- `SettingsView`: Account settings (modal sheet)

### Reusable Components
- `BottomNavBar`: 3-icon navigation with badges
- `TabButton`: People/Memories switcher
- `SectionCard`: Card container with borders
- `SettingsRow`: List item for settings
- `CompatibilityButton`: Filter buttons
- `CompatibilityIllustration`: Custom artwork

## State Management

- `selectedTab` in MainTabView controls which main view is shown
- `showSettings` in ProfileView controls settings sheet presentation
- `ContentViewModel` manages business logic and data state
- All navigation is declarative using SwiftUI state

## Design Consistency

All views use:
- Same dark green color scheme from `AppColors`
- Consistent typography from `AppTypography`
- Standard spacing from `AppSpacing`
- Serif italic headers for section titles
- System fonts for body text
- Proper accessibility labels

