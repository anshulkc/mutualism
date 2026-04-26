//
//  ContentView.swift
//  mutualism
//
//  Created by Anshul Chennavaram on 10/2/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject private var viewModel = ContentViewModel()
    @StateObject private var serendipityViewModel = SerendipityViewModel()
    @State private var selectedTab = 0
    @State private var selectedCompatibility = 0 // 0: ALL, 1: URL, 2: IRL
    @State private var selectedNavTab = 0
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        ZStack {
            AppColors.adaptiveBackground(for: colorScheme).ignoresSafeArea()

            VStack(spacing: 0) {
                // Content based on selected nav tab
                Group {
                    switch selectedNavTab {
                    case 0:
                        peopleMemoriesContent
                    case 1:
                        Color.clear // Camera/Add tab placeholder
                    case 2:
                        ProfileView()
                    default:
                        peopleMemoriesContent
                    }
                }

                // Bottom Navigation Bar
                BottomNavBar(selectedTab: $selectedNavTab)
            }
        }
        .preferredColorScheme(.dark)
        .sheet(isPresented: $serendipityViewModel.showComposer) {
            OpenComposerSheet(viewModel: serendipityViewModel)
                .presentationDetents([.large])
                .presentationDragIndicator(.visible)
        }
    }

    private var peopleMemoriesContent: some View {
        VStack(spacing: 0) {
            // Tab Navigation
            HStack(spacing: 0) {
                TabButton(
                    title: "people",
                    isSelected: selectedTab == 0,
                    action: { selectedTab = 0 }
                )

                TabButton(
                    title: "memories",
                    isSelected: selectedTab == 1,
                    action: { selectedTab = 1 }
                )
            }
            .padding(.top, 8)

            ScrollView {
                VStack(alignment: .leading, spacing: AppSpacing.xl) {
                    // INITIATED SERENDIPITY Section
                    VStack(alignment: .leading, spacing: AppSpacing.md) {
                        // Show status chip if active, otherwise show open button
                        if serendipityViewModel.isActive {
                            OpenStatusChip(viewModel: serendipityViewModel)
                        } else {
                            Button(action: {
                                serendipityViewModel.openComposer()
                            }) {
                                HStack {
                                    VStack(alignment: .leading, spacing: AppSpacing.sm) {
                                        Text("are you open?")
                                            .font(AppTypography.body())
                                            .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                                            .lineSpacing(4)

                                        Text("let nearby friends know you're available")
                                            .font(AppTypography.caption())
                                            .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                                    }

                                    Spacer()

                                    Image(systemName: "arrow.right.circle.fill")
                                        .font(.system(size: 28))
                                        .foregroundColor(AppColors.adaptiveAccent(for: colorScheme))
                                }
                                .padding(AppSpacing.md)
                                .background(
                                    RoundedRectangle(cornerRadius: AppRadius.lg)
                                        .fill(AppColors.adaptiveSurface(for: colorScheme))
                                        .overlay(
                                            RoundedRectangle(cornerRadius: AppRadius.lg)
                                                .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                                        )
                                )
                            }
                            .padding(.horizontal, AppSpacing.lg)
                        }
                    }
                    .padding(.top, AppSpacing.lg)

                    // COMPATIBILITY Section
                    VStack(alignment: .leading, spacing: AppSpacing.lg) {
                        Text("COMPATIBILITY")
                            .font(AppTypography.sectionTitle())
                            .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                            .tracking(1)
                            .padding(.horizontal, AppSpacing.lg)

                        // Filter Buttons
                        HStack(spacing: AppSpacing.md) {
                            CompatibilityButton(
                                title: "ALL",
                                isSelected: selectedCompatibility == 0,
                                action: { selectedCompatibility = 0 }
                            )

                            CompatibilityButton(
                                title: "URL",
                                isSelected: selectedCompatibility == 1,
                                action: { selectedCompatibility = 1 }
                            )

                            CompatibilityButton(
                                title: "IRL",
                                isSelected: selectedCompatibility == 2,
                                action: { selectedCompatibility = 2 }
                            )

                            Spacer()
                        }
                        .padding(.horizontal, AppSpacing.lg)

                        // Check Compatibility Button
                        Button(action: {
                            viewModel.checkCompatibility()
                        }) {
                            HStack(spacing: AppSpacing.sm) {
                                Image(systemName: "magnifyingglass")
                                    .font(.system(size: 16))
                                Text("check compatibility")
                                    .font(AppTypography.button())
                            }
                            .foregroundColor(AppColors.adaptivePrimaryStrong(for: colorScheme))
                            .padding(.horizontal, AppSpacing.lg)
                            .padding(.vertical, 12)
                            .frame(maxWidth: .infinity)
                            .background(
                                RoundedRectangle(cornerRadius: AppRadius.lg)
                                    .fill(AppColors.adaptivePrimary(for: colorScheme))
                            )
                        }
                        .padding(.horizontal, AppSpacing.lg)
                        .accessibilityLabel("Check compatibility")

                        // Illustration
                        CompatibilityIllustration()
                            .frame(maxWidth: .infinity)
                            .padding(.top, AppSpacing.lg)
                    }
                    .padding(.bottom, AppSpacing.xl)
                }
            }
        }
    }
}

#Preview {
    ContentView()
}
