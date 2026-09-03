//
//  AddDrinkDraft.swift
//  Watered
//
//  Created by Frank Sedivy on 03/09/2026.
//

import Foundation

// MARK: - Add Drink Draft
//
// Purpose:
// Stores the values selected in the Add Drink form before they become a
// DrinkEntry.
//
// Input:
// Accepts the selected drink type, the selected numeric volume value, and
// the unit currently used by the Add Drink flow.
//
// Returns:
// A lightweight value that can create a DrinkEntry without depending on
// Swift UI
//
// Notes:
// This keeps AddDrinkView focused on UI state and user interaction. The view
// decides what the user selected, while AddDrinkDraft decides how those selected
// values become app model data.
struct AddDrinkDraft {
    let drinkType : DrinkType
    let volumeValue: Double
    let unit: LiquidUnit
    
    // MARK: - Entry Creation
    //
    // Purpose: Converts the draft form values into a real DrinkEntry
    //
    // Input:
    // Accepts the date that should be attached to the drink entry. The default is
    // the current date so the UI can submit a drink without manually creating one.
    //
    // Returns:
    // A DrinkEntry containing the selected drink type, selected amount, selected
    // unit, and supplied date.
    func drinkEntry(date: Date = Date()) -> DrinkEntry {
        let drinkAmount = DrinkAmount(
            value: volumeValue,
            unit: unit
        )
        
        return DrinkEntry(
            type: drinkType,
            amount: drinkAmount,
            date: date
        )
    }
}
