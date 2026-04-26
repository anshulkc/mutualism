//
//  CompatibilityButton.swift
//  mutualism
//
//  Button for compatibility filters
//

import SwiftUI

struct CompatibilityButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.body())
                .foregroundColor(isSelected 
                    ? AppColors.adaptivePrimaryStrong(for: colorScheme)
                    : AppColors.adaptiveText(for: colorScheme))
                .padding(.horizontal, AppSpacing.lg)
                .padding(.vertical, AppSpacing.sm)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.sm)
                        .fill(isSelected 
                            ? AppColors.adaptivePrimary(for: colorScheme)
                            : AppColors.adaptiveSurface(for: colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.sm)
                                .stroke(isSelected 
                                    ? AppColors.adaptivePrimary(for: colorScheme)
                                    : AppColors.adaptiveBorder(for: colorScheme), 
                                    lineWidth: 1)
                        )
                )
        }
        .pressableScale()
        .accessibilityLabel(title)
        .accessibilityHint(isSelected ? "Selected" : "Not selected")
    }
}

