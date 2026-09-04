//
//  AddDrinkPillRow.swift
//  Watered
//
//  Created by Frank Sedivy on 03/09/2026.
//

import SwiftUI

// MARK: - Add Drink Pill Row
//
// Purpose:
// Displays a horizontally scrolling row of pill-shaped Add Drink options.
//
// Input:
// Accepts display labels that should be shown as pills, an optional
// selected label, and an optional selection action.
//
// Returns:
// A SwiftUI view containing a horizontal scroll view of pill labels
// or pill buttons.
//
// Notes:
// Recents can use this as a read-only row by omitting the selected label
// and selection action. Drink types can use it as a selectable row by
// passing both
struct AddDrinkPillRow: View {
    let labels: [String]
    let selectedLabel: String?
    let accessibilityIdentifier: String
    let onSelect: ((String) -> Void)?
    
    init(
        labels: [String],
        selectedLabel: String? = nil,
        accessibilityIdentifier: String,
        onSelect: ((String) -> Void)? = nil
    ) {
        self.labels = labels
        self.selectedLabel = selectedLabel
        self.accessibilityIdentifier = accessibilityIdentifier
        self.onSelect = onSelect
    }
    
    var body: some View {
        ScrollView(.horizontal, showsIndicators: false) {
            HStack(spacing: 8) {
                ForEach(labels, id: \.self) { label in
                    if onSelect != nil {
                        Button {
                            onSelect?(label)
                        } label: {
                            pillContent(for: label)
                        }
                        .buttonStyle(
                            AddDrinkPillButtonStyle(
                                isSelected: selectedLabel == label
                            )
                        )
                    }
                    else {
                        pillContent(for: label)
                    }
                }
            }
        }
        .scrollBounceBehavior(.basedOnSize, axes: .horizontal)
        .accessibilityIdentifier(accessibilityIdentifier)
    }
    
    // MARK: - Pill Content
    //
    // Purpose:
    // Builds the shared visual content for each pill.
    //
    // Input:
    // Accepts the label displayed inside the pill.
    //
    // Returns:
    // A small text view styled as a capsule.
    //
    // UI role:
    // Keeps selectable and read-only pills visually consistent.
    private func pillContent(for label: String) -> some View {
        let isSelected = selectedLabel == label
        
        return Text(label)
            .font(.callout)
            .foregroundStyle(isSelected ? .white : .primary)
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                isSelected ? Color.accentColor : Color.clear,
                in: Capsule()
            )
            .background(.thinMaterial, in: Capsule())
    }
    
    // MARK: - Add Drink Pill Button Style
    //
    // Purpose:
    // Adds pressed-state feedback to tappable Add Drink pills.
    //
    // Input:
    // Receives SwiftUI's button configuration and whether the pill is already
    // selected.
    //
    // Returns:
    // A button body that keeps the resting pill style intact, while briefly using
    // the selected color as the user presses it.
    //
    // UI role:
    // Makes recent-drink pills feel tappable without making them permanently look
    // selected after the direct-submit action runs.
    private struct AddDrinkPillButtonStyle: ButtonStyle {
        let isSelected: Bool
        
        func makeBody(configuration: Configuration) -> some View {
            configuration.label
                .foregroundStyle(shouldUseSelectedStyle(configuration: configuration) ? .white : .primary)
                .background(
                    shouldUseSelectedStyle(configuration: configuration) ? Color.accentColor : Color.clear,
                    in: Capsule()
                )
        }
        
        private func shouldUseSelectedStyle(configuration: Configuration) -> Bool {
            return isSelected || configuration.isPressed
        }
    }
}

