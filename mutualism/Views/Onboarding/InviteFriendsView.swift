//
//  InviteFriendsView.swift
//  mutualism
//
//  Invite friends onboarding screen with share sheet
//

import SwiftUI

struct InviteFriendsView: View {
    let onNext: () -> Void
    let onSkip: () -> Void
    @Environment(\.colorScheme) var colorScheme
    @State private var showShareSheet = false
    
    var body: some View {
        VStack(spacing: 0) {
            Spacer()
            
            // Title with styled text
            VStack(alignment: .center, spacing: 0) {
                HStack(alignment: .firstTextBaseline, spacing: 0) {
                    Text("invite two ")
                        .font(AppTypography.sectionTitle())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    
                    Text("best friends")
                        .font(AppTypography.sectionTitle())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                        .fontWeight(.bold)
                        .underline()
                    
                    Text(" of your")
                        .font(AppTypography.sectionTitle())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                }
                
                Text("to the app.")
                    .font(AppTypography.sectionTitle())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    .padding(.top, 4)
            }
            .multilineTextAlignment(.center)
            .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            
            // Subtitle
            Text("trust me, it will make the experience way better.")
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .multilineTextAlignment(.center)
                .padding(.horizontal, AppSpacing.xl)
            
            Spacer()
            
            // Navigation buttons
            OnboardingButtonStack(
                primaryTitle: "continue",
                onPrimary: {
                    showShareSheet = true
                },
                onSecondary: onSkip
            )
            .sheet(isPresented: $showShareSheet) {
                ShareSheet(items: [shareMessage])
                    .onDisappear {
                        // After sharing, move to next screen
                        onNext()
                    }
            }
        }
    }
    
    private var shareMessage: String {
        "Join me on mutualism - a new way to connect with friends through mutuals and shared spaces! 🤝"
    }
}

// MARK: - Share Sheet
struct ShareSheet: UIViewControllerRepresentable {
    let items: [Any]
    
    func makeUIViewController(context: Context) -> UIActivityViewController {
        let controller = UIActivityViewController(
            activityItems: items,
            applicationActivities: nil
        )
        return controller
    }
    
    func updateUIViewController(_ uiViewController: UIActivityViewController, context: Context) {
        // No update needed
    }
}

