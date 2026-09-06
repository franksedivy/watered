//
//  TodayCalendarDay.swift
//  Watered
//
//  Created by Frank Sedivy on 06/09/2026.
//

import Foundation

// MARK: - Today Calendar Day
//
// Purpose:
// Stores the local calendar day currently shown by Today.
//
// Input:
// Accepts a date and calendar so tests can control day-boundary behavriour.
//
// UI role:
// Gives WateredTabView a small testable model for refreshing Today when iOS
// reports a significant time change.
nonisolated struct TodayCalendarDay {
    private(set) var date: Date
    let calendar: Calendar
    
    init(
        date: Date = Date(),
        calendar: Calendar = .current
    ) {
        self.date = date
        self.calendar = calendar
    }
    
    // MARK: - Refreshing
    //
    // Purpose:
    // Updates the active Today date.
    //
    // Input:
    // Accepts the current date. Defaults to Date() for app use, while tests can
    // pass fixed values.
    //
    // Behvavior:
    // Stores the new date so Today can recalculate which drink entries belong to
    // the active local calendar day.
    mutating func refresh(now: Date = Date()) {
        date = now
    }
    
    // MARK: - Entry Filtering
    //
    // Purpose:
    // Check whether a drink entry belongs to this active Today calendar day.
    //
    // Input:
    // Accepts a DrinkEntry from the app store.
    //
    // Returns:
    // true when the entry was logged on the same local calendar day as date.
    func contains(_ entry: DrinkEntry) -> Bool {
        return calendar.isDate(entry.loggedAt, inSameDayAs: date)
    }
}
