# Font Installation Guide - Chai Typography

## Overview
This guide explains how to add the Fraunces and Nunito fonts to your Xcode project to complete the warm chai typography aesthetic.

## Fonts to Download

### 1. Fraunces (Display/Headings)
**Download from:** https://fonts.google.com/specimen/Fraunces
- Download the font family
- Extract the ZIP file
- Select these weights:
  - Fraunces-Regular.ttf
  - Fraunces-SemiBold.ttf
  - Fraunces-Bold.ttf

**Alternative (Variable Font):**
- Fraunces[SOFT,WONK,opsz,wght].ttf (contains all weights)

### 2. Nunito (Body/UI)
**Download from:** https://fonts.google.com/specimen/Nunito
- Download the font family
- Extract the ZIP file
- Select these weights:
  - Nunito-Regular.ttf
  - Nunito-Medium.ttf
  - Nunito-SemiBold.ttf

**Alternative (Variable Font):**
- Nunito[wght].ttf (contains all weights)

## Installation Steps

### Step 1: Add Fonts to Xcode Project

1. **Create Fonts Folder** (optional, for organization):
   - In Xcode, right-click on the `mutualism` group
   - Select "New Group"
   - Name it "Fonts"

2. **Add Font Files**:
   - Drag and drop the downloaded `.ttf` files into the Fonts group (or mutualism group)
   - In the dialog that appears:
     - ✅ Check "Copy items if needed"
     - ✅ Check "Create groups"
     - ✅ Ensure "mutualism" target is selected
   - Click "Finish"

### Step 2: Register Fonts in Info.plist

1. **Open Info.plist**:
   - In Xcode, select the `mutualism` folder
   - Right-click on `Info.plist` (or create it if missing)

2. **Add Font Files**:
   - Right-click in Info.plist
   - Select "Add Row"
   - Type: "Fonts provided by application" (key: `UIAppFonts`)
   - Click the disclosure triangle to expand
   - Add each font file name:
     - Item 0: `Fraunces-Regular.ttf`
     - Item 1: `Fraunces-SemiBold.ttf`
     - Item 2: `Fraunces-Bold.ttf`
     - Item 3: `Nunito-Regular.ttf`
     - Item 4: `Nunito-Medium.ttf`
     - Item 5: `Nunito-SemiBold.ttf`

**Info.plist XML format:**
```xml
<key>UIAppFonts</key>
<array>
    <string>Fraunces-Regular.ttf</string>
    <string>Fraunces-SemiBold.ttf</string>
    <string>Fraunces-Bold.ttf</string>
    <string>Nunito-Regular.ttf</string>
    <string>Nunito-Medium.ttf</string>
    <string>Nunito-SemiBold.ttf</string>
</array>
```

### Step 3: Verify Font Names

1. **Build and Run** the app
2. Check the console output:
   - ✅ `Fraunces font loaded: X variants`
   - ✅ `Nunito font loaded: X variants`

3. **If fonts don't load** (shows warning messages):
   - Verify font files are in the Xcode project
   - Check that files are listed in Info.plist exactly as they appear in Finder
   - Ensure the "Target Membership" is checked for the mutualism app

### Step 4: Verify Font Family Names (Optional)

If fonts still don't load, print all available font families:

```swift
// Add to AppTypography.registerFonts()
print("Available font families:")
for family in UIFont.familyNames.sorted() {
    print("Family: \(family)")
    for name in UIFont.fontNames(forFamilyName: family) {
        print("  - \(name)")
    }
}
```

## Fallback Behavior

The app is designed to work with or without custom fonts:

### With Custom Fonts (After Installation)
- **Headings**: Fraunces (warm, handcrafted serif)
- **Body/UI**: Nunito (soft, friendly sans-serif)

### Without Custom Fonts (Before Installation)
- **Headings**: Georgia (iOS system serif)
- **Body/UI**: San Francisco (iOS system font)

The app will display warnings in the console but continue working perfectly with fallback fonts.

## Alternative: Using SF Pro as Fallback

If you prefer to skip custom fonts entirely, the current implementation already uses excellent fallbacks:

- **Fraunces → Georgia**: Apple's refined serif font
- **Nunito → SF Pro**: Apple's optimized system font

Both provide excellent readability and work seamlessly with iOS.

## Font Licensing

Both fonts are free and open source:

- **Fraunces**: SIL Open Font License 1.1
- **Nunito**: SIL Open Font License 1.1

Safe for commercial use, modification, and distribution.

## Troubleshooting

### Fonts Don't Appear
1. Clean build folder: `Product → Clean Build Folder` (Cmd+Shift+K)
2. Check Target Membership: Select font file → File Inspector → Target Membership
3. Verify Info.plist entries match exact file names

### Wrong Font Weight
- Make sure you've included all weight variants
- Variable fonts (single file with all weights) are recommended

### Font Looks Different on Device vs Simulator
- This is normal; fonts may render slightly differently
- Test on actual device for production

## Quick Test

After installation, rebuild and check:

1. **Section headers** should use Fraunces (or Georgia if not installed)
2. **Body text** should use Nunito (or SF Pro if not installed)
3. **"anshul" on profile** should use large Fraunces

## File Sizes

Approximate download sizes:
- Fraunces: ~200KB per weight (600KB total)
- Nunito: ~80KB per weight (240KB total)
- **Total**: ~840KB for all fonts

## Need Help?

Check the console output on app launch:
- ✅ Green checkmark = Font loaded successfully
- ⚠️ Warning = Using fallback font (still works fine!)

The app is fully functional with or without custom fonts installed.

