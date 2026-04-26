//
//  OpenComposerSheet.swift
//  mutualism
//
//  Bottom sheet composer for configuring open broadcasts
//

import SwiftUI
import MapKit

struct OpenComposerSheet: View {
    @ObservedObject var viewModel: SerendipityViewModel
    @Environment(\.dismiss) var dismiss
    @Environment(\.colorScheme) var colorScheme
    
    var body: some View {
        NavigationView {
            ZStack {
                AppColors.adaptiveBackground(for: colorScheme)
                    .ignoresSafeArea()
                
                ScrollView {
                    VStack(alignment: .leading, spacing: AppSpacing.xl) {
                        // 1. Destination Section
                        destinationSection
                        
                        Divider()
                            .background(AppColors.adaptiveBorder(for: colorScheme))
                        
                        // 2. Time Frame Section
                        timeFrameSection
                        
                        Divider()
                            .background(AppColors.adaptiveBorder(for: colorScheme))
                        
                        // 3. Notes Section
                        notesSection
                        
                        Divider()
                            .background(AppColors.adaptiveBorder(for: colorScheme))
                        
                        // 4. Radius Section
                        radiusSection
                        
                        Divider()
                            .background(AppColors.adaptiveBorder(for: colorScheme))
                        
                        // 5. Visibility Hint Section
                        visibilitySection
                    }
                    .padding(AppSpacing.lg)
                    .padding(.bottom, 100) // Space for floating button
                }
                
                // Floating CTA buttons
                VStack {
                    Spacer()
                    ctaButtons
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .principal) {
                    VStack(spacing: 2) {
                        Rectangle()
                            .fill(AppColors.adaptiveBorder(for: colorScheme))
                            .frame(width: 36, height: 4)
                            .cornerRadius(2)
                    }
                }
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Notice"),
                    message: Text(viewModel.errorMessage ?? ""),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
    
    // MARK: - Destination Section
    
    private var destinationSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(SerendipityStrings.destination)
                .font(AppTypography.settingsSectionTitle())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
            
            // Search field
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                    .font(.system(size: 16))
                
                TextField(SerendipityStrings.destinationPlaceholder, text: $viewModel.searchText)
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                
                if !viewModel.searchText.isEmpty {
                    Button(action: { viewModel.searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                            .font(.system(size: 16))
                    }
                }
            }
            .padding(AppSpacing.md)
            .background(
                RoundedRectangle(cornerRadius: AppRadius.md)
                    .fill(AppColors.adaptiveSurface(for: colorScheme))
                    .overlay(
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                    )
            )
            
            // Recent places
            if viewModel.searchText.isEmpty {
                Text("Recent places")
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
            }
            
            ForEach(viewModel.filteredPlaces) { place in
                Button(action: {
                    viewModel.selectedDestination = place
                    viewModel.searchText = ""
                }) {
                    HStack {
                        Image(systemName: "mappin.circle.fill")
                            .foregroundColor(AppColors.adaptiveAccent(for: colorScheme))
                            .font(.system(size: 20))
                        
                        Text(place.name)
                            .font(AppTypography.body())
                            .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                        
                        Spacer()
                        
                        if viewModel.selectedDestination?.id == place.id {
                            Image(systemName: "checkmark")
                                .foregroundColor(AppColors.adaptivePrimary(for: colorScheme))
                                .font(.system(size: 16, weight: .semibold))
                        }
                    }
                    .padding(AppSpacing.md)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .fill(AppColors.adaptiveSurface(for: colorScheme))
                            .overlay(
                                RoundedRectangle(cornerRadius: AppRadius.md)
                                    .stroke(viewModel.selectedDestination?.id == place.id ?
                                        AppColors.adaptivePrimary(for: colorScheme) :
                                        AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                            )
                    )
                }
            }
            
            // Checkbox
            Toggle(isOn: $viewModel.shareVenueNameOnly) {
                Text(SerendipityStrings.shareVenueNameOnly)
                    .font(AppTypography.body())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
            }
            .tint(AppColors.adaptivePrimary(for: colorScheme))
        }
    }
    
    // MARK: - Time Frame Section
    
    private var timeFrameSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            Text(SerendipityStrings.timeFrame)
                .font(AppTypography.settingsSectionTitle())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
            
            Text("within next 2–3 hours")
                .font(AppTypography.caption())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
            
            // Duration presets
            HStack(spacing: AppSpacing.sm) {
                ForEach(SerendipityConfiguration.durationPresets, id: \.self) { duration in
                    Button(action: {
                        viewModel.selectedDurationMinutes = duration
                    }) {
                        Text(SerendipityStrings.minutesLabel(duration))
                            .font(AppTypography.body())
                            .foregroundColor(viewModel.selectedDurationMinutes == duration ? 
                                           AppColors.adaptivePrimaryStrong(for: colorScheme) : 
                                           AppColors.adaptiveText(for: colorScheme))
                            .padding(.horizontal, AppSpacing.md)
                            .padding(.vertical, 10)
                            .background(
                                RoundedRectangle(cornerRadius: AppRadius.sm)
                                    .fill(viewModel.selectedDurationMinutes == duration ? 
                                          AppColors.adaptivePrimary(for: colorScheme) : 
                                          AppColors.adaptiveSurface(for: colorScheme))
                                    .overlay(
                                        RoundedRectangle(cornerRadius: AppRadius.sm)
                                            .stroke(viewModel.selectedDurationMinutes == duration ?
                                                AppColors.adaptivePrimary(for: colorScheme) :
                                                AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                                    )
                            )
                    }
                }
            }
            
            // Start time toggle
            HStack {
                Toggle(isOn: $viewModel.startNow) {
                    Text(viewModel.startNow ? SerendipityStrings.startNow : SerendipityStrings.scheduleFor)
                        .font(AppTypography.body())
                        .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                }
                .tint(AppColors.adaptivePrimary(for: colorScheme))
            }
            
            // Date picker (when scheduled)
            if !viewModel.startNow {
                DatePicker(
                    "",
                    selection: $viewModel.scheduledStartTime,
                    in: Date()...Date().addingTimeInterval(3 * 3600),
                    displayedComponents: .hourAndMinute
                )
                .datePickerStyle(.compact)
                .labelsHidden()
            }
        }
    }
    
    // MARK: - Notes Section
    
    private var notesSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(SerendipityStrings.notes)
                    .font(AppTypography.settingsSectionTitle())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                
                Spacer()
                
                Text("\(viewModel.notes.count)/\(SerendipityConfiguration.maxNotesLength)")
                    .font(AppTypography.caption())
                    .foregroundColor(viewModel.notes.count > SerendipityConfiguration.maxNotesLength ? 
                                   .red : AppColors.adaptiveTextMuted(for: colorScheme))
            }
            
            TextField(SerendipityStrings.notesPlaceholder, text: $viewModel.notes, axis: .vertical)
                .font(AppTypography.body())
                .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                .lineLimit(3...5)
                .padding(AppSpacing.md)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(AppColors.adaptiveSurface(for: colorScheme))
                        .overlay(
                            RoundedRectangle(cornerRadius: AppRadius.md)
                                .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                        )
                )
        }
    }
    
    // MARK: - Radius Section
    
    private var radiusSection: some View {
        VStack(alignment: .leading, spacing: AppSpacing.md) {
            HStack {
                Text(SerendipityStrings.radius)
                    .font(AppTypography.settingsSectionTitle())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                
                Spacer()
                
                Text(SerendipityStrings.radiusLabel(viewModel.radiusKm))
                    .font(AppTypography.bodyMedium())
                    .foregroundColor(AppColors.adaptivePrimary(for: colorScheme))
            }
            
            Slider(
                value: $viewModel.radiusKm,
                in: SerendipityConfiguration.minRadiusKm...SerendipityConfiguration.maxRadiusKm,
                step: 0.5
            )
            .tint(AppColors.adaptivePrimary(for: colorScheme))
            
            // Estimated recipients
            HStack {
                Image(systemName: "person.2.fill")
                    .font(.system(size: 14))
                    .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                
                Text(SerendipityStrings.estimatedRecipients(viewModel.estimatedRecipients))
                    .font(AppTypography.caption())
                    .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
            }
        }
    }
    
    // MARK: - Visibility Section
    
    private var visibilitySection: some View {
        HStack(alignment: .top, spacing: AppSpacing.md) {
            Image(systemName: "eye.fill")
                .font(.system(size: 16))
                .foregroundColor(AppColors.adaptiveAccent(for: colorScheme))
            
            Text(SerendipityStrings.visibilityHint)
                .font(AppTypography.caption())
                .foregroundColor(AppColors.adaptiveTextMuted(for: colorScheme))
                .fixedSize(horizontal: false, vertical: true)
        }
        .padding(AppSpacing.md)
        .background(
            RoundedRectangle(cornerRadius: AppRadius.md)
                .fill(AppColors.adaptiveSurface(for: colorScheme))
                .overlay(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                )
        )
    }
    
    // MARK: - CTA Buttons
    
    private var ctaButtons: some View {
        VStack(spacing: AppSpacing.md) {
            // Primary button
            Button(action: {
                viewModel.broadcastOpen()
            }) {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: AppColors.adaptivePrimaryStrong(for: colorScheme)))
                    } else {
                        Text(SerendipityStrings.broadcastOpen)
                            .font(AppTypography.button())
                    }
                }
                .foregroundColor(viewModel.isValidForBroadcast && !viewModel.isLoading ?
                               AppColors.adaptivePrimaryStrong(for: colorScheme) :
                               AppColors.adaptiveTextSubtle(for: colorScheme))
                .frame(maxWidth: .infinity)
                .padding(.vertical, 16)
                .background(
                    RoundedRectangle(cornerRadius: AppRadius.md)
                        .fill(viewModel.isValidForBroadcast && !viewModel.isLoading ? 
                              AppColors.adaptivePrimary(for: colorScheme) : 
                              AppColors.adaptiveSurface(for: colorScheme))
                )
            }
            .disabled(!viewModel.isValidForBroadcast || viewModel.isLoading)
            
            // Secondary button
            Button(action: {
                viewModel.cancelComposer()
                dismiss()
            }) {
                Text(SerendipityStrings.cancel)
                    .font(AppTypography.button())
                    .foregroundColor(AppColors.adaptiveText(for: colorScheme))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 16)
                    .background(
                        RoundedRectangle(cornerRadius: AppRadius.md)
                            .stroke(AppColors.adaptiveBorder(for: colorScheme), lineWidth: 1)
                    )
            }
        }
        .padding(AppSpacing.lg)
        .background(
            Rectangle()
                .fill(AppColors.adaptiveBackground(for: colorScheme))
                .shadow(color: .black.opacity(0.1), radius: 8, x: 0, y: -2)
        )
    }
}

#Preview {
    OpenComposerSheet(viewModel: SerendipityViewModel())
}

