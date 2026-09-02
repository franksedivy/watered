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
    
    // Purpose:
    // Stores the app-level display unit when the Add Drink form opens.
    //
    // Input:
    // Supplied by WateredTabView from the temporary display unit selected in
    // Profile
    //
    // UI role:
    // Lets Add Drink defaults its volume selection to the same unit Today
    // is using.
    private let defaultUnit: LiquidUnit
    
    // MARK: - Initialisation
    
    init(defaultUnit: LiquidUnit, onAddDrink: @escaping () -> Void) {
        self.defaultUnit = defaultUnit
        self.onAddDrink = onAddDrink
        _selectedUnit = State(initialValue : defaultUnit)
    }
    
    // MARK: - Form State
    //
    // Purpose:
    // Stores the drink tyep currently selected in the Add Drink form.
    //
    // UI role:
    // Lets the form remember the user's selected drink type before the real
    // DrinkEntry creation step exists.
    //
    // Notes:
    // This is local form state. It does not update Today until a later ticket
    // wires the submitted form into the app state.
    @State private var selectedDrinkType: DrinkType = .water
    
    // Purpose:
    // Stores the unit currently selected in the Add Drink form.
    //
    // Input:
    // Initially created from the app-level default unit passed into the view.
    //
    // UI role:
    // Lets the Add Drink form use the same unit as Today be default, while still
    // allowing this form to manage its own selected unit before submission.
    @State private var selectedUnit: LiquidUnit
    
    // MARK: - Body
    
    var body: some View {
        NavigationStack {
            Form {
                Section {
                    VStack(alignment: .leading, spacing: 4) {
                        Text("Add drink")
                            .font(.headline)
                        Text("Now, change time")
                            .font(.caption)
                            .foregroundStyle(.secondary)
                    }
                }
                
                Section("Type") {
                    Picker("Drink type", selection: $selectedDrinkType) {
                        ForEach(DrinkType.allCases, id: \.self) { drinkType in
                            Text(drinkType.rawValue)
                                .tag(drinkType)
                        }
                    }
                    .accessibilityIdentifier("addDrinkTypePicker")
                }
                
                Section("Recents") {
                    Text("Recent drinks will go here")
                        .foregroundStyle(.secondary)
                }
                
                Section("Volume") {
                    Text("Volume input will go here")
                        .foregroundStyle(.secondary)
                    Picker("Unit", selection: $selectedUnit) {
                        ForEach(LiquidUnit.allCases) { liquidUnit in
                            Text(liquidUnit.rawValue)
                                .tag(liquidUnit)
                        }
                    }
                    .pickerStyle(.segmented)
                    .accessibilityIdentifier("addDrinkUnitPicker")
                }
                
                Section("Temporary action") {
                    Button(action: onAddDrink) {
                        Label("Add demo drink", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addDemoDrinkButton")
                }
            }
        }
        .navigationTitle("Add Drink")
    }
}

#Preview {
    AddDrinkView(defaultUnit: .milliliters, onAddDrink: {})
}
