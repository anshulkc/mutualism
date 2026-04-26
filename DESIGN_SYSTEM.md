# Design System Documentation

## Overview
This design system implements the mutualism app's dark green aesthetic with consistent colors, typography, spacing, and reusable components.

## Architecture
The app follows MVVM architecture with:
- **Views/**: Main views (MainTabView, PeopleMemoriesView, ProfileView, SettingsView)
- **Components/**: Reusable UI components
- **ViewModels/**: Business logic and state management
- **DesignSystem.swift**: Centralized design tokens

## Design Tokens

### Colors (`AppColors`)
- `backgroundDark`: Main app background (dark green)
- `backgroundCard`: Card/section background (slightly lighter green)
- `accent`: Yellow/gold accent color for highlights
- `textPrimary`: White text for primary content
- `textSecondary`: Gray text for secondary content
- `textPlaceholder`: Darker gray for placeholder text

### Typography (`AppTypography`)
- `sectionTitle()`: Georgia italic 28pt - For main section headers like "CLOSE FRIENDS"
- `settingsSectionTitle()`: Georgia italic 18pt - For settings section headers
- `title()`: System 20pt semibold - For card titles
- `body()`: System 16pt regular - For body text
- `caption()`: System 14pt regular - For captions
- `tabLabel()`: System 18pt medium - For tab navigation

### Spacing (`AppSpacing`)
- `xs`: 4pt
- `sm`: 8pt
- `md`: 16pt
- `lg`: 24pt
- `xl`: 32pt

### Corner Radius (`AppRadius`)
- `sm`: 8pt
- `md`: 16pt
- `lg`: 24pt

## Components

### TabButton
Tab navigation button with active/inactive states.
- Accessible with selection state
- Consistent styling

### SectionCard
Reusable card container with:
- Dark green background
- Rounded corners
- Subtle border
- Consistent padding

### CompatibilityButton
Filter button for compatibility section:
- Selected/unselected states
- Rounded corners
- Border overlay
- Accessible hints

### CompatibilityIllustration
Custom illustration showing:
- Crescent moon
- Two person silhouettes
- Text description

### BottomNavBar
Navigation bar with:
- Three icon buttons (Gallery, Camera, Profile)
- Badge support (notification counts)
- Selection states
- Accessibility labels

### SettingsRow
List item for settings pages:
- Icon on left
- Title and optional subtitle
- Optional trailing text
- Chevron indicator
- Button action support

## Views

### MainTabView
Main container managing tab navigation between:
- People/Memories content (tab 0)
- Camera/Add (tab 1)
- Profile (tab 2)

### PeopleMemoriesView
Primary content view with:
- People/Memories tab switcher
- Close Friends section
- Compatibility section with filters

### ProfileView
User profile display:
- Large name display
- Role/title subtitle
- Referrals button
- Hamburger menu → Settings

### SettingsView
Account management page with sections:
- INFO: Name, phone number
- SETTINGS: Subscription, payments, notifications
- SUPPORT: Contact options
- ABOUT: How it works, policies
- MANAGE: Account actions

## Accessibility Features
- All interactive elements have accessibility labels
- Buttons include hints for state changes
- Color contrast meets WCAG guidelines
- Dynamic type support through system fonts
- Semantic structure for screen readers

## Responsive Design
- Flexible layouts using HStack/VStack
- Proper spacing scales
- ScrollView for overflow content
- Safe area insets respected
- Works on all iPhone sizes

## Usage Example

```swift
// Using design tokens
Text("Hello")
    .font(AppTypography.body())
    .foregroundColor(AppColors.textPrimary)
    .padding(AppSpacing.lg)

// Using components
SectionCard {
    Text("Card content")
}
```

