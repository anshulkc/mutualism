//
//  OnboardingButtons.swift
//  mutualism
//
//  Reusable button components for onboarding flow
//

import SwiftUI

// MARK: - Primary Button
struct OnboardingPrimaryButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let showArrow: Bool
    let action: () -> Void
    
    init(title: String, showArrow: Bool = true, action: @escaping () -> Void) {
        self.title = title
        self.showArrow = showArrow
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: AppSpacing.sm) {
                Text(title)
                    .font(AppTypography.button())
                
                if showArrow {
                    Image(systemName: "arrow.right")
                        .font(.system(size: 14, weight: .semibold))
                }
            }
            .foregroundColor(AppColors.adaptivePrimaryStrong(for: colorScheme))
            .frame(maxWidth: .infinity)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.adaptivePrimary(for: colorScheme))
            )
        }
    }
}

// MARK: - Secondary Button
struct OnboardingSecondaryButton: View {
    @Environment(\.colorScheme) var colorScheme
    
    let title: String
    let action: () -> Void
    
    init(title: String = "skip for now", action: @escaping () -> Void) {
        self.title = title
        self.action = action
    }
    
    var body: some View {
        Button(action: action) {
            Text(title)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .padding(.vertical, AppSpacing.sm)
        }
    }
}

// MARK: - Onboarding Button Stack
struct OnboardingButtonStack: View {
    let primaryTitle: String
    let showPrimaryArrow: Bool
    let showSecondaryButton: Bool
    let onPrimary: () -> Void
    let onSecondary: (() -> Void)?
    
    init(
        primaryTitle: String,
        showPrimaryArrow: Bool = true,
        showSecondaryButton: Bool = true,
        onPrimary: @escaping () -> Void,
        onSecondary: (() -> Void)? = nil
    ) {
        self.primaryTitle = primaryTitle
        self.showPrimaryArrow = showPrimaryArrow
        self.showSecondaryButton = showSecondaryButton
        self.onPrimary = onPrimary
        self.onSecondary = onSecondary
    }
    
    var body: some View {
        VStack(spacing: AppSpacing.md) {
            OnboardingPrimaryButton(
                title: primaryTitle,
                showArrow: showPrimaryArrow,
                action: onPrimary
            )
            
            if showSecondaryButton, let onSecondary = onSecondary {
                OnboardingSecondaryButton(action: onSecondary)
            }
        }
        .padding(.horizontal, AppSpacing.lg)
        .padding(.bottom, 50)
    }
}

