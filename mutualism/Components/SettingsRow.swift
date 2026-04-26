//
//  SettingsRow.swift
//  mutualism
//
//  Reusable row component for settings list items
//

import SwiftUI

struct SettingsRow: View {
    @Environment(\.colorScheme) var colorScheme
    
    let icon: String
    let title: String
    let subtitle: String?
    let trailingText: String?
    let hasChevron: Bool
    let action: () -> Void
    
    init(
        icon: String,
        title: String,
        subtitle: String? = nil,
        trailingText: String? = nil,
        hasChevron: Bool = true,
        action: @escaping () -> Void = {}
    ) {
        self.icon = icon
        self.title = title
        self.subtitle = subtitle
        self.trailingText = trailingText
        self.hasChevron = hasChevron
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.md) {
                Image(systemName: icon)
                    .font(.system(size: 22))
                    .foregroundColor(AppColors.adaptivePrimaryStrong(for: colorScheme))
                    .frame(width: 32, height: 32)
                
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    
                    if let subtitle = subtitle {
                        Text(subtitle)
                            .font(AppTypography.caption())
                            .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                    }
                }
                
                Spacer()
                
                if let trailingText = trailingText {
                    Text(trailingText)
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                }
                
                if hasChevron {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                }
            }
            .padding(.vertical, AppSpacing.md)
        }
        .pressableOverlay()
        .accessibilityLabel(title)
        .accessibilityHint(subtitle ?? "")
    }
}

