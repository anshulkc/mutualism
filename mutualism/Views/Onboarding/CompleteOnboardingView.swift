//
//  CompleteOnboardingView.swift
//  mutualism
//
//  Final onboarding screen before entering app
//

import SwiftUI

struct CompleteOnboardingView: View {
    let onComplete: () -> Void
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Icon
            Image(systemName: "checkmark.circle.fill")
                .font(.system(size: 80))
                .foregroundColor(AppColors.adaptivePrimary(for: colorScheme))
                .padding(.bottom, AppSpacing.xl)
            
            // Title
            Text("you're all set!")
                .font(AppTypography.sectionTitle())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.md)
            
            // Description
            Text("tap \"open\" anytime to let nearby mutuals know you're available to connect")
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .multilineTextAlignment(.center)
                .lineSpacing(6)
                .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            
            // Complete Button
            OnboardingButtonStack(
                primaryTitle: "get started",
                showPrimaryArrow: false,
                showSecondaryButton: false,
                onPrimary: onComplete
            )
        }
    }
}

