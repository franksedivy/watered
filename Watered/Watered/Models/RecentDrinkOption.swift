//
//  RecentDrinkOption.swift
//  Watered
//
//  Created by Frank Sedivy on 04/09/2026.
//

import Foundation

// MARK: - Recent Drink Option
//
// Purpose:
// Represents one complete recent-drink shortcut shown in the Add Drink sheet.
//
// Input:
// Accepts the drink type, volume value, and unit needed to recreate a previously
// used drink
//
// Returns:
// A lightweight value that can provide display text and submit a real DrinkEntry.
//
// Notes:
// This is intentionally separate from AddDrinkView so recent-drink shortcuts can
// become persistence-backed later without changing the view's basic shape.
struct RecentDrinkOption {
    let drinkType: DrinkType
    let volumeValue: Double
    let unit: LiquidUnit
    
    // MARK: - Display
    //
    // Purpose:
    // Provides the text shown inside the recent-drink pill.
    //
    // Returns:
    // A short user-facing label such as "300 ml of Water|.
    var label: String {
        return "\(Int(volumeValue)) \(unit.rawValue) of \(drinkType.rawValue)"
    }
    
    // MARK: - Entry Creation
    //
    // Purpose:
    // Converts the recent-drink shortcut into a real DrinkEntry.
    //
    // Input:
    // Accepts the date that should be attached to the new drink entry. The default
    // is the current date so a recent drink can be submitted immediately.
    //
    // Returns:
    // A DrinkEntry containing the recent drink type, volume, unit, and supplied date.
    func drinkEntry(date: Date = Date()) -> DrinkEntry {
        let draft = AddDrinkDraft(
            drinkType: drinkType,
            volumeValue: volumeValue,
            unit: unit
        )
        
        return draft.drinkEntry(date: date)
    }
}
