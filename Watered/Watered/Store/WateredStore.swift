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
    
    // MARK: - Persistence Loading
    //
    // Purpose:
    // Replace the current in-memory drink entries with entries loaded from
    // persistence.
    //
    // Input:
    // Accepts DrinkEntry values recreated from SwiftData.
    //
    // Behavior:
    // Update the store so the UI can render persisted drink entries after app
    // launch.
    func loadDrinkEntries(_ loadedEntries: [DrinkEntry]) {
        entries = loadedEntries
        wateredLog("Loaded \(entries.count) persisted drink entries into WateredStore")
    }
    
    // MARK: - Calendar Day Filtering
    //
    // Purpose:
    // Returns the drink entries logged during one local calendar day.
    //
    // Input:
    // Accepts the date that represents the calendar day to read and the calendar
    // Watered should use to compare entry dates.
    //
    // Returns:
    // The entries whose loggedAt date falls on the same calendar day as the
    // supplied date.
    //
    // Behavior:
    // Keeps historical entries in the store while letting Today display only
    // entries that belong to the active day.
    func drinkEntries(for calendarDay: Date, calendar: Calendar = .current) -> [DrinkEntry] {
        return entries.filter { entry in
            calendar.isDate(entry.loggedAt, inSameDayAs: calendarDay)
        }
    }
    
    // MARK: - Recent Drinks
    //
    // Purpose:
    // Builds recent-drink shortcuts from the store's full dirnk history
    //
    // Returns:
    // Unique drink options ordered by their most recent logged date.
    // Returns an empty array when there are no entries.
    //
    // Behavior:
    // Treats entries with the same drink type, volume value, and unit as
    // one shortcut. Preserves the original amount and unit for submission.
    var recentDrinkOptions: [RecentDrinkOption] {
        let newestEntries = entries.sorted { firstEntry, secondEntry in
            firstEntry.loggedAt > secondEntry.loggedAt
        }
        
        var options: [RecentDrinkOption] = []
        
        for entry in newestEntries {
            let alreadyIncluded = options.contains { option in
                option.drinkType == entry.type &&
                option.volumeValue == entry.amount.value &&
                option.unit == entry.amount.unit
            }
            if alreadyIncluded == false {
                let option = RecentDrinkOption(
                    drinkType: entry.type,
                    volumeValue: entry.amount.value,
                    unit: entry.amount.unit
                )
                
                options.append(option)
            }
        }
        
        return options
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
