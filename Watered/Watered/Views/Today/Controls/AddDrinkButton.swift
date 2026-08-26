//
//  AddDrinkButton.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//

import SwiftUI

// MARK: - Add Drink Button
//
// Purpose: Displays the circular plus button used to start adding a drink.
//
// Input:
// Accepts a glass tint color so the parent Today view can control styling.
// Accepts an onAddDrink action so this button can trigger drink adding without
// knowing how drinks are created.
//
// UI role:
// Keeps the add-drink control separate from the Today screen layout. This view
// owns the visual button shape, symbol, and tappable area.
struct AddDrinkButton: View {
    let glassTint: Color
    let onAddDrink: () -> Void
    
    var body: some View {
        Button(action: onAddDrink) {
            Image(systemName: "plus")
                .font(.system(size: 32, weight: .regular))
                .foregroundStyle(.white)
                .frame(width: 62, height: 62)
                .contentShape(Circle())
                .glassEffect(.regular.tint(glassTint).interactive(), in: Circle())
        }
        .buttonStyle(.plain)
        .contentShape(Circle())
    }
}

#Preview {
    AddDrinkButton(
        glassTint: Color.black.opacity(0.60),
        onAddDrink: {}
    )
}
