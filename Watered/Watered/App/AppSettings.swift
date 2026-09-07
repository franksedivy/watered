//
//  AppSettings.swift
//  Watered
//
//  Created by Frank Sedivy on 07/09/2026.
//

import Foundation

// MARK: - App Settings
//
// Purpose:
// Stores Watered's user-configurable app settings.
//
// Input:
// Accepts the user's preferred display unit and daily hydration goal.
//
// Persistence role:
// Acts as the app model for settings. Persistence-specific models can map to and
// from this type without leaking SwiftData details into views.
nonisolated struct AppSettings {
    let displayUnit: LiquidUnit
    let dailyHydrationGoal: HydrationGoal
    
    // MARK: - Defaults
    //
    // Purpose:
    // Creates Watered's first-run default settings.
    //
    // Input:
    // Accepts a Locale so tests can verify locale-based defaults without relying
    // on the test device's actual region settings.
    //
    // Returns:
    // App settings using US fluid ounces only for US measurement systems and
    // milliliters everywhere else.
    static func defaults(for locale: Locale = .current) -> AppSettings {
        let displayUnit: LiquidUnit
        
        switch locale.measurementSystem {
        case .us:
            displayUnit = .usFluidOunces
        default:
            displayUnit = .milliliters
        }
        
        return AppSettings(
            displayUnit: displayUnit,
            dailyHydrationGoal: HydrationGoal(
                amount: DrinkAmount(value: 2700, unit: .milliliters)
            )
        )
    }
}
