//
//  IntroducingView.swift
//  mutualism
//
//  Second onboarding screen introducing mutualism
//

import SwiftUI

struct IntroducingView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var showButton = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Typewriter text
            VStack(alignment: .center, spacing: AppSpacing.xl) {
                // "introducing..."
                TypewriterText(
                    segments: [
                        TextSegment(
                            text: "introducing...",
                            color: AppColors.adaptiveText(for: colorScheme),
                            font: AppTypography.sectionTitle()
                        )
                    ],
                    charactersPerSecond: 20
                )
                
                // "mutualism!"
                TypewriterText(
                    segments: [
                        TextSegment(
                            text: "mutualism!",
                            color: AppColors.adaptivePrimary(for: colorScheme),
                            font: AppTypography.largeTitle()
                        )
                    ],
                    charactersPerSecond: 15
                )
                
                // Definition with underlined words
                VStack(spacing: 0) {
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        Text("a way to meet friends through")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    }
                    
                    HStack(alignment: .firstTextBaseline, spacing: 0) {
                        TypewriterText(
                            segments: [
                                TextSegment(
                                    text: "mutuals",
                                    color: AppColors.adaptivePrimary(for: colorScheme),
                                    font: AppTypography.body(),
                                    isUnderlined: true
                                )
                            ],
                            charactersPerSecond: 25
                        )
                        
                        Text(" and ")
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                        
                        TypewriterText(
                            segments: [
                                TextSegment(
                                    text: "shared spaces",
                                    color: AppColors.adaptivePrimary(for: colorScheme),
                                    font: AppTypography.body(),
                                    isUnderlined: true
                                )
                            ],
                            charactersPerSecond: 25,
                            onComplete: {
                                withAnimation(.easeIn(duration: 0.3)) {
                                    showButton = true
                                }
                            }
                        )
                    }
                }
                .multilineTextAlignment(.center)
            }
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            
            // Buttons (appear after animation)
            if showButton {
                OnboardingButtonStack(
                    primaryTitle: "continue",
                    onPrimary: onNext,
                    onSecondary: onSkip
                )
                .transition(.opacity)
            }
        }
    }
}

