//
//  WateredStore.swift
//  Watered
//
//  Created by Frank Sedivy on 05/09/2026.
//

import Foundation
import Observation

// MARK: - Watered Store
//
// Purpose:
// Owns Watered's first app-level hydration state.
//
// Input:
// Can be initialised with existing drink entries for tests, previews, or future
// persistence loading.
@Observable
final class WateredStore {
    
    // MARK: - Drink Entries
    //
    // Purpose:
    // Stores the drink entries currently known to the app.
    private(set) var entries: [DrinkEntry]
    
    // MARK: - Initialisation
    
    init(entries: [DrinkEntry] = []) {
        self.entries = entries
    }
    
    // MARK: - Actions
    //
    // Input:
    // Accepts a DrinkEntry created by the Add Drink flow.
    //
    // Behavior:
    // Appends the entry and logs the state change at the app action boundary.
    func addDrinkEntry(_ entry: DrinkEntry) {
        entries.append(entry)
        wateredLog("Drink entry accepted by WateredStore: \(entry.type.rawValue) \(entry.amount.formatted); drink count is \(entries.count)")
    }
}
