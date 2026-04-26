//
//  DesignSystem.swift
//  mutualism
//
//  Design tokens for consistent UI
//

import SwiftUI

// MARK: - Colors
struct AppColors {
    // Chai Color Scheme - Light Mode
    static let background = Color(hex: "#FAF6F0") // foam
    static let surface = Color(hex: "#F3EDE4") // milk
    static let primary = Color(hex: "#D8BFA6") // chai
    static let primaryStrong = Color(hex: "#A8825A") // strong chai (for better contrast)
    static let accent = Color(hex: "#6C8F7D") // cardamom
    static let text = Color(hex: "#2E221B") // clove
    static let textMuted = Color(hex: "#6B5B4C")
    static let border = Color(hex: "#E5D8C8")
    
    // Dark Mode (Unified Chai Palette)
    static let backgroundDark = Color(hex: "#1E1712") // bg-1
    static let surfaceDark = Color(hex: "#2A211B")    // bg-2 (cards/inputs)
    static let primaryDark = Color(hex: "#D4AF89")    // chai primary (AA on dark bg)
    static let primaryStrongDark = Color(hex: "#8B6F47") // strong chai (for text on primary)
    static let accentDark = Color(hex: "#89BBA6")     // cardamom (AA on dark bg)
    static let textDark = Color(hex: "#F7EFE6")       // text primary (AA)
    static let textMutedDark = Color(hex: "#B5A595")  // text muted (AA)
    static let textSubtleDark = Color(hex: "#8B7B6B") // text subtle (AA on surface)
    static let borderDark = Color(hex: "#3A2E26")     // borders
    
    // Adaptive colors (automatically switch based on color scheme)
    static func adaptiveBackground(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? backgroundDark : background
    }
    
    static func adaptiveSurface(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? surfaceDark : surface
    }
    
    static func adaptivePrimary(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? primaryDark : primary
    }
    
    static func adaptivePrimaryStrong(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? primaryStrongDark : primaryStrong
    }
    
    static func adaptiveAccent(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? accentDark : accent
    }
    
    static func adaptiveText(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? textDark : text
    }
    
    static func adaptiveTextMuted(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? textMutedDark : textMuted
    }
    
    static func adaptiveTextSubtle(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? textSubtleDark : textMuted
    }
    
    static func adaptiveBorder(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? borderDark : border
    }
    
    // Legacy compatibility (for existing code) - no opacity, use solid colors
    static var backgroundCard: Color { surface }
    static var textPrimary: Color { text }
    static var textSecondary: Color { textMuted }
    static var textPlaceholder: Color { textMutedDark }
    
    // Interaction states
    static func hoverOverlay(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.08) : Color.black.opacity(0.04)
    }
    
    static func activeOverlay(for colorScheme: ColorScheme) -> Color {
        colorScheme == .dark ? Color.white.opacity(0.12) : Color.black.opacity(0.08)
    }
}

// MARK: - Color Extension for Hex
extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet.alphanumerics.inverted)
        var int: UInt64 = 0
        Scanner(string: hex).scanHexInt64(&int)
        let a, r, g, b: UInt64
        switch hex.count {
        case 3: // RGB (12-bit)
            (a, r, g, b) = (255, (int >> 8) * 17, (int >> 4 & 0xF) * 17, (int & 0xF) * 17)
        case 6: // RGB (24-bit)
            (a, r, g, b) = (255, int >> 16, int >> 8 & 0xFF, int & 0xFF)
        case 8: // ARGB (32-bit)
            (a, r, g, b) = (int >> 24, int >> 16 & 0xFF, int >> 8 & 0xFF, int & 0xFF)
        default:
            (a, r, g, b) = (1, 1, 1, 0)
        }
        
        self.init(
            .sRGB,
            red: Double(r) / 255,
            green: Double(g) / 255,
            blue:  Double(b) / 255,
            opacity: Double(a) / 255
        )
    }
}

// MARK: - Typography
struct AppTypography {
    // Font family names
    private static let displayFont = "Fraunces 72pt"
    private static let sansFont = "Nunito"
    
    // MARK: - Helper Method
    
    /// Helper to create font with fallback support
    private static func customFont(
        family: String,
        size: CGFloat,
        relativeTo textStyle: Font.TextStyle,
        weight: Font.Weight,
        fallback: Font
    ) -> Font {
        if UIFont.fontNames(forFamilyName: family).isEmpty {
            return fallback
        }
        return .custom(family, size: size, relativeTo: textStyle).weight(weight)
    }
    
    // MARK: - Display Fonts (headings) - Fraunces with Georgia fallback
    
    static func sectionTitle() -> Font {
        customFont(
            family: displayFont,
            size: 26,
            relativeTo: .title,
            weight: .semibold,
            fallback: .custom("Georgia", size: 26, relativeTo: .title).weight(.semibold)
        )
    }
    
    static func settingsSectionTitle() -> Font {
        customFont(
            family: displayFont,
            size: 17,
            relativeTo: .headline,
            weight: .semibold,
            fallback: .custom("Georgia", size: 17, relativeTo: .headline).weight(.semibold)
        )
    }
    
    static func title() -> Font {
        customFont(
            family: displayFont,
            size: 19,
            relativeTo: .title3,
            weight: .semibold,
            fallback: .system(size: 19, weight: .semibold, design: .serif)
        )
    }
    
    static func largeTitle() -> Font {
        customFont(
            family: displayFont,
            size: 52,
            relativeTo: .largeTitle,
            weight: .regular,
            fallback: .system(size: 52, weight: .regular, design: .serif)
        )
    }
    
    // MARK: - Sans Fonts (body/UI) - Nunito with system fallback
    
    static func body() -> Font {
        customFont(
            family: sansFont,
            size: 16,
            relativeTo: .body,
            weight: .regular,
            fallback: .system(size: 16, weight: .regular)
        )
    }
    
    static func bodyMedium() -> Font {
        customFont(
            family: sansFont,
            size: 16,
            relativeTo: .body,
            weight: .medium,
            fallback: .system(size: 16, weight: .medium)
        )
    }
    
    static func caption() -> Font {
        customFont(
            family: sansFont,
            size: 14,
            relativeTo: .caption,
            weight: .regular,
            fallback: .system(size: 14, weight: .regular)
        )
    }
    
    static func tabLabel() -> Font {
        customFont(
            family: sansFont,
            size: 17,
            relativeTo: .headline,
            weight: .medium,
            fallback: .system(size: 17, weight: .medium)
        )
    }
    
    static func button() -> Font {
        customFont(
            family: sansFont,
            size: 16,
            relativeTo: .body,
            weight: .semibold,
            fallback: .system(size: 16, weight: .semibold)
        )
    }
}

// MARK: - Font Registration Helper
extension AppTypography {
    /// Call this on app launch to validate custom fonts are loaded
    static func registerFonts() {
        let fraunces = UIFont.fontNames(forFamilyName: displayFont)
        let nunito = UIFont.fontNames(forFamilyName: sansFont)

        if fraunces.isEmpty {
            print("⚠️ Fraunces font not found. Using Georgia fallback.")
        } else {
            print("✅ Fraunces font loaded: \(fraunces.count) variants")
        }

        if nunito.isEmpty {
            print("⚠️ Nunito font not found. Using system font fallback.")
        } else {
            print("✅ Nunito font loaded: \(nunito.count) variants")
        }
    }
}

// MARK: - Spacing
struct AppSpacing {
    static let xs: CGFloat = 4
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
    static let xl: CGFloat = 32
}

// MARK: - Corner Radius
struct AppRadius {
    static let sm: CGFloat = 8
    static let md: CGFloat = 16
    static let lg: CGFloat = 24
}

// MARK: - Button Styles

/// A button style that provides press feedback with scale effect
struct PressableButtonStyle: ButtonStyle {
    let scaleEffect: CGFloat
    
    init(scaleEffect: CGFloat = 0.95) {
        self.scaleEffect = scaleEffect
    }
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .scaleEffect(configuration.isPressed ? scaleEffect : 1.0)
            .animation(.easeInOut(duration: 0.1), value: configuration.isPressed)
    }
}

/// A button style that provides press feedback with overlay
struct PressableOverlayButtonStyle: ButtonStyle {
    @Environment(\.colorScheme) var colorScheme
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .background(
                RoundedRectangle(cornerRadius: AppRadius.sm)
                    .fill(configuration.isPressed ? AppColors.hoverOverlay(for: colorScheme) : Color.clear)
            )
    }
}

// MARK: - View Extensions

extension View {
    /// Adds pressable scale effect to any view
    func pressableScale(_ scale: CGFloat = 0.95) -> some View {
        self.buttonStyle(PressableButtonStyle(scaleEffect: scale))
    }
    
    /// Adds pressable overlay effect to any view
    func pressableOverlay() -> some View {
        self.buttonStyle(PressableOverlayButtonStyle())
    }
}

