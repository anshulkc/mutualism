//
//  InstagramOnboardingView.swift
//  mutualism
//
//  Instagram OAuth onboarding screen
//

import SwiftUI

struct InstagramOnboardingView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var isLoading = false
    @State private var showWebView = true
    
    var body: some View {
        VStack(spacing: 0) {
            // Header
            VStack(spacing: AppSpacing.md) {
                Text("lets connect your instagram!")
                    .font(AppTypography.sectionTitle())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, AppSpacing.xl)
                    .padding(.top, AppSpacing.xl)
            }
            
            Spacer()
            
            // WebView
            if showWebView {
                ZStack {
                    WebView(
                        url: URL(string: "https://www.instagram.com/accounts/login/")!,
                        isLoading: $isLoading,
                        onNavigationComplete: { url in
                            // Handle OAuth redirect here
                            print("Navigated to: \(url?.absoluteString ?? "unknown")")
                            // Auto-advance to next screen on successful login
                            // You can add logic here to detect successful login
                        }
                    )
                    .cornerRadius(AppRadius.lg)
                    .padding(.horizontal, AppSpacing.lg)
                    
                    if isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle())
                            .scaleEffect(1.5)
                    }
                }
                .frame(height: 500)
            }
            
            Spacer()
            
            // Description
            Text("this allows us to find out who your mutuals are.")
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
                .padding(.bottom, AppSpacing.xl)
            
            Spacer()
            
            // Buttons
            OnboardingButtonStack(
                primaryTitle: "continue",
                onPrimary: onNext,
                onSecondary: onSkip
            )
        }
    }
}

