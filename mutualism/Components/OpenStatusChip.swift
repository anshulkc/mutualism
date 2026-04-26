//
//  OpenStatusChip.swift
//  mutualism
//
//  Compact status chip showing active broadcast
//

import SwiftUI

struct OpenStatusChip: View {
    @ObservedObject var viewModel: SerendipityViewModel
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        if let _ = viewModel.activeBroadcast, viewModel.isActive {
            HStack(spacing: AppSpacing.sm) {
                // Status indicator
                Circle()
                    .fill(AppColors.accent)
                    .frame(width: 8, height: 8)
                    .shadow(color: AppColors.accent.opacity(0.5), radius: 4)
                
                // Status text
                Text("\(SerendipityStrings.open) · \(viewModel.countdownText)")
                    .font(AppTypography.bodyMedium())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                
                Spacer()
                
                // Edit button
                Button(action: {
                    viewModel.showComposer = true
                }) {
                    Image(systemName: "pencil")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                }
                .accessibilityLabel("Edit broadcast")
                
                // End button
                Button(action: {
                    viewModel.endBroadcast()
                }) {
                    Image(systemName: "xmark")
                        .font(.system(size: 14))
                        .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                }
                .accessibilityLabel("End broadcast")
            }
            .padding(.horizontal, AppSpacing.md)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.lg)
                    .fill(AppColors.adaptiveSurface(for: colorScheme))
                    .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: 2)
            )
            .padding(.horizontal, AppSpacing.lg)
        }
    }
}

