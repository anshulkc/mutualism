//
//  ProblemStatementView.swift
//  mutualism
//
//  First onboarding screen with typewriter animation
//

import SwiftUI

struct ProblemStatementView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var showButton = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Typewriter text
            VStack(alignment: .leading, spacing: AppSpacing.sm) {
                // Line 1: "quality human"
                Text("quality human")
                    .font(AppTypography.sectionTitle())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                
                // Line 2: "connection is difficult."
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("connection is ")
                        .font(AppTypography.sectionTitle())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    
                    TypewriterText(
                        segments: [
                            TextSegment(
                                text: "difficult.",
                                color: Color(hex: "#DC2626"),
                                font: AppTypography.sectionTitle()
                            )
                        ],
                        charactersPerSecond: 25
                    )
                }
                
                // Line 2: "nothing is organic anymore."
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("nothing is ")
                        .font(AppTypography.sectionTitle())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    
                    TypewriterText(
                        segments: [
                            TextSegment(
                                text: "organic",
                                color: Color(hex: "#16A34A"),
                                font: AppTypography.sectionTitle()
                            )
                        ],
                        charactersPerSecond: 25
                    )
                    
                    Text(" anymore.")
                        .font(AppTypography.sectionTitle())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                }
                
                // Line 3: "lets fix that."
                TypewriterText(
                    segments: [
                        TextSegment(
                            text: "lets fix that.",
                            color: AppColors.adaptivePrimary(for: colorScheme),
                            font: AppTypography.sectionTitle()
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

