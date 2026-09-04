//
//  AddDrinkActionButton.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Add Drink Action Button
//
// Purpose: Shows the primary add-drink action used near the app tab bar.
// Input: Accepts an onTap closure from the parent view.
// Returns: A small circular SwiftUI button.
//
// UI role:
// This button exists because Watered needs a prominent add-drink action near the
// tab bar, similar in placement to Apple's search affordance, while keeping the
// actual tab bar native.
struct AddDrinkActionButton: View {
    // MARK: - Actions

    // Purpose: Stores the action that runs when the button is tapped.
    // Input: Supplied by the parent view that owns the add-drink sheet state.
    private let onTap: () -> Void

    // MARK: - Initialisation
    init(onTap: @escaping () -> Void) {
        self.onTap = onTap
    }

    // MARK: - Body
    var body: some View {
        Button(action: onTap) {
            Image(systemName: "plus")
                .font(.system(size: 28, weight: .regular))
                .frame(width: 48, height: 48)
                
        }
        .buttonStyle(.glass)
        .buttonBorderShape(.circle)
        .accessibilityLabel("Add drink")
        .accessibilityIdentifier("addDrinkActionButton")
        .accessibilityHint("Opens the Add Drink form.")
    }
}

#Preview {
    AddDrinkActionButton(onTap: {})
}
