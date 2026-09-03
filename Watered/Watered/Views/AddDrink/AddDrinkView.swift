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
    // Stores the action taht recieves teh complete dirnk entry when the user
    // submits the Add Drink form.
    //
    // Input: Supplied by the parent view that owns the current drink entries.
    private let onAddDrink: (DrinkEntry) -> Void
    
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
    
    init(defaultUnit: LiquidUnit, onAddDrink: @escaping (DrinkEntry) -> Void) {
        self.defaultUnit = defaultUnit
        self.onAddDrink = onAddDrink
        _selectedVolumeValue = State(
            initialValue: AddDrinkView.defaultVolumeValue(for: defaultUnit)
        )
    }
    
    // MARK: - Form State
    //
    // Purpose: Stores the drink tyep currently selected in the Add Drink form.
    //
    // UI role:
    // Lets the form remember the user's selected drink type before the real
    // DrinkEntry creation step exists.
    //
    // Notes:
    // This is local form state. It does not update Today until a later ticket
    // wires the submitted form into the app state.
    @State private var selectedDrinkType: DrinkType = .water
    
    // Purpose: Stores the selected volume amount inside the Add Drink form.
    //
    // Input:
    // Gives the form a concrete volume value before the real DrinkEntry creation
    // step exists.
    @State private var selectedVolumeValue: Double
    
    // MARK: - Volume Options
    //
    // Purpose: Provides the first predefined volume options for the Add Drink form.
    //
    // Returns: A list of common drink volumes in the currently selected unit.
    //
    // UI role:
    // Keeps the Volume picker simple while avoiding free numeric input for the first
    // real Add Drink flow.
    private var volumeOptions: [Double] {
        switch defaultUnit {
        case .milliliters:
            return [150, 200, 250, 300, 330, 500, 600, 750, 1000]
        case .usFluidOunces:
            return [6, 8, 10, 12, 16, 20, 24, 32]
        case .imperialFluidOunces:
            return [5, 8, 10, 12, 16, 20, 24, 32]
        }
    }
    
    // Purpose: Provides the default volumes for the form's selected unit.
    //
    // Input: Accepts the unit that Add Drink recieved from the app-level setting.
    //
    // Returns: A sensible starting volume from the predefined options
    private static func defaultVolumeValue(for unit: LiquidUnit) -> Double {
        switch unit {
        case .milliliters:          return 330
        case .usFluidOunces:        return 12
        case .imperialFluidOunces:  return 8
        }
    }
    
    // MARK: - Submission
    //
    // Purpose: Submits the current Add Drink form state as a real DrinkEntry.
    //
    // Input:
    // Reads the selected drink type, selected volume value, and default display unit
    // currently held by the form.
    //
    // Behavior:
    // Wraps the current form values in an AddDrinkDraft, asks the draft to create
    // the DrinkEntry, logs the submitted entry, and hands the entry back to the
    // parent view.
    private func submitDrink() {
        let draft = AddDrinkDraft(
            drinkType: selectedDrinkType,
            volumeValue: selectedVolumeValue,
            unit: defaultUnit
        )
        
        let drinkEntry = draft.drinkEntry()
        
        wateredLog("Submitting drink entry: \(drinkEntry)")
        onAddDrink(drinkEntry)
    }
    
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
                    .onChange(of: selectedDrinkType) { previousValue, newValue in
                        wateredLog("Selected drink type changed from \(previousValue) to \(newValue)")
                        
                    }
                }
                
                Section("Recents") {
                    Text("Recent drinks will go here")
                        .foregroundStyle(.secondary)
                }
                
                Section("Volume") {
                    Picker("Volume", selection: $selectedVolumeValue) {
                        ForEach(volumeOptions, id: \.self) { volumeOption in
                            Text("\(Int(volumeOption)) \(defaultUnit.rawValue)")
                                .tag(volumeOption)
                        }
                    }
                    .accessibilityIdentifier("addDrinkVolumePicker")
                    .onChange(of: selectedVolumeValue) { previousValue, newValue in
                        wateredLog("Add Drink volume changed from \(previousValue) to \(newValue) \(defaultUnit.rawValue)")
                    }
                }
                
                Section("Action") {
                    Button(action: submitDrink) {
                        Label("Add drink", systemImage: "plus")
                    }
                    .accessibilityIdentifier("addDrinkSubmitButton")
                }
            }
            .onAppear {
                wateredLog(
                    "Add Drink opened with default unit \(defaultUnit.rawValue) and default volume:\(selectedVolumeValue) \(defaultUnit.rawValue)")
            }
        }
        .navigationTitle("Add Drink")
    }
}

#Preview {
    AddDrinkView(defaultUnit: .milliliters) { drinkEntry in
        wateredLog("Preview submitted drink entry: \(drinkEntry)")
    }
}
