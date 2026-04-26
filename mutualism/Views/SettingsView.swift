//
//  SettingsView.swift
//  mutualism
//
//  Settings and account management page
//

import SwiftUI

struct SettingsView: View {
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    @EnvironmentObject var onboardingManager: OnboardingManager
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground(for: colorScheme).ignoresSafeArea()
            
            VStack(spacing: 0) {
                // Header
                HStack {
                    Button(action: {
                        dismiss()
                    }) {
                        Image(systemName: "chevron.left")
                            .font(.system(size: 20))
                            .foregroundColor(AppColors.adaptivePrimaryStrong(for: colorScheme))
                            .frame(width: 44, height: 44)
                    }
                    
                    Spacer()
                    
                    Text("account")
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    
                    Spacer()
                    
                    Color.clear.frame(width: 44, height: 44)
                }
                .padding(.horizontal, AppSpacing.md)
                .padding(.top, 8)
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        // INFO Section
                        SettingsSection(title: "INFO") {
                            SectionCard {
                                VStack(spacing: 0) {
                                    SettingsRow(
                                        icon: "person",
                                        title: "name",
                                        trailingText: "Anshul Chennavaram",
                                        hasChevron: false
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "phone",
                                        title: "phone number",
                                        trailingText: "(925) 405-6876",
                                        hasChevron: false
                                    )
                                }
                            }
                        }
                        
                        // SETTINGS Section
                        SettingsSection(title: "SETTINGS") {
                            SectionCard {
                                VStack(spacing: 0) {
                                    SettingsRow(
                                        icon: "dollarsign.circle",
                                        title: "mutualism subscription",
                                        action: { print("mutualism subscription tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "creditcard",
                                        title: "payment history",
                                        action: { print("payment history tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "bell",
                                        title: "notification preferences",
                                        action: { print("notification preferences tapped") }
                                    )
                                }
                            }
                        }
                        
                        // SUPPORT Section
                        SettingsSection(title: "SUPPORT") {
                            SectionCard {
                                SettingsRow(
                                    icon: "message",
                                    title: "text us",
                                    trailingText: "(925) 405-6876",
                                    action: { print("text us tapped") }
                                )
                            }
                        }
                        
                        // ABOUT Section
                        SettingsSection(title: "ABOUT") {
                            SectionCard {
                                VStack(spacing: 0) {
                                    SettingsRow(
                                        icon: "questionmark.circle",
                                        title: "how mutualism works",
                                        action: { print("how mutualism works tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "hand.raised",
                                        title: "privacy policy",
                                        action: { print("privacy policy tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "doc.text",
                                        title: "terms of service",
                                        action: { print("terms of service tapped") }
                                    )
                                }
                            }
                        }
                        
                        // MANAGE Section
                        SettingsSection(title: "MANAGE") {
                            SectionCard {
                                VStack(spacing: 0) {
                                    SettingsRow(
                                        icon: "pause.circle",
                                        title: "pause account",
                                        subtitle: "stop receiving invites for now",
                                        action: { print("pause account tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "rectangle.portrait.and.arrow.right",
                                        title: "logout",
                                        action: { print("logout tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "trash",
                                        title: "delete account",
                                        action: { print("delete account tapped") }
                                    )
                                    
                                    Divider()
                                        .background(AppColors.adaptiveBorder(for: colorScheme))
                                        .padding(.leading, 48)
                                    
                                    SettingsRow(
                                        icon: "arrow.counterclockwise",
                                        title: "reset onboarding",
                                        subtitle: "show welcome screens again",
                                        action: { onboardingManager.resetOnboarding() }
                                    )
                                }
                            }
                        }
                    }
                    .padding(.top, AppSpacing.lg)
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
        .navigationBarHidden(true)
    }
}

// MARK: - Settings Section
struct SettingsSection<Content: View>: View {
    @Environment(\.colorScheme) var colorScheme
    let title: String
    let content: Content
    
    init(title: String, @ViewBuilder content: () -> Content) {
        self.title = title
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(title)
                .font(AppTypography.settingsSectionTitle())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .padding(.horizontal, AppSpacing.lg)
            
            content
                .padding(.horizontal, AppSpacing.lg)
        }
    }
}

#Preview {
    SettingsView()
        .environmentObject(OnboardingManager())
}

