//
//  AddDrinkView.swift
//  Watered
//
//  Created by Frank Sedivy on 30/08/2026.
//

import SwiftUI

// MARK: - Add Drink View
//
// Input: Accepts an onAddDrink closure from the parent view.
//
// Returns:
// A SwiftUI view containing the first native add-drink action.
//
// UI role:
// This screen gives the app a real place for the add-drink flow to live.
// In 0.2 it only triggers the temporary demo drink action. In 0.3 this can grow
// into the proper drink logging flow without changing the app's top-level
// navigation shape.
struct AddDrinkView: View {
    // MARK: - Actions
    
    // Purpose:
    // Stores the action that runs when the user taps the add-drink button.
    //
    // Input:
    // Supplied by the parent view that owns the current drink entries.
    private let onAddDrink: () -> Void
    
    // MARK: - Initialisation
    
    init(onAddDrink: @escaping () -> Void) {
        self.onAddDrink = onAddDrink
    }
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 24) {
                Button(action: onAddDrink) {
                    Label("Add demo drink", systemImage: "plus")
                }
            }
        }
        .navigationTitle("Add Drink")
    }
}

#Preview {
    AddDrinkView(onAddDrink: {})
}
