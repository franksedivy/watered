//
//  TodayScreenMode.swift
//  Watered
//
//  Created by Frank Sedivy on 26/08/2026.
//
// MARK: - Today Screen Mode
//
// Purpose: Describes the main presentation states the Today screen can show
//
// Input:
// This type doe snot accept input directly. TodayView decides which case to use
// by looking at the current drink entries and hydration progress.
//
// Returns:
// A named state that TodayView can switch over when choosing which Today content
// to display.
//
// UI role:
// Keeps Today screen state vocabulary separate from TodayView's layout code.
enum TodayScreenMode {
    case empty          // Empty screen when no drinks have been logged
    case firstDrink     // First drink has been logged, mostly used to celebrate engagement
    case inProgress     // Most common use when drinks are logged during the day
    case goalReached    // Used for when the user's hydration goal has been reached
}

