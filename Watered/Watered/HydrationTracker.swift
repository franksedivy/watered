//
//  HydrationTracker.swift
//  Watered
//
//  Created by Frank Sedivy on 30/06/2026.
//

import Foundation

struct HydrationTracker {
    var entries: [DrinkEntry] = []
    var dailyGoal: HydrationGoal
    
    // MARK: - Total Volume
    // Purpose: Calculates the total raw liquid volume from all logged drink entries.
    // Input: Uses the tracker's entries array.
    // Returns:A Measurement<UnitVolume> in milliliters representing total liquid consumed.
    //
    // Behavior:
    // Converts each entry amount to milliliters, adds the values together, and
    // returns the final total as a Foundation Measurement.
    //
    // Notes:
    // This does not apply water-content ratios. Water, juice, tea, coffee, and
    // other drinks all count by their physical liquid volume.
    var totalVolume: Measurement<UnitVolume> {
        let totalInMilliliters = entries.reduce(0.0) { total, entry in
            total + entry.amount.volume.converted(to: .milliliters).value
        }
        
        return Measurement(value: totalInMilliliters, unit: .milliliters)
    }
    
    // MARK: - Total Water Volume
    // Purpose: Calculates the estimated physical water volume from all logged drink entries.
    //
    // Input: Uses the tracker's entries array and each entry's waterVolume.
    //
    // Returns:
    // An optional Measurement<UnitVolume> in milliliters.
    // Returns nil if any entry has unknown water content.
    //
    // Behavior:
    // Loops through entries one by one. If an entry has waterVolume, it is
    // converted to milliliters and added to the total. If an entry has nil
    // waterVolume, the calculation stops and returns nil.
    //
    // Notes:
    // Returning nil is deliberate. It prevents the app from silently guessing
    // water contribution for unknown drink types.
    var totalWaterVolume: Measurement<UnitVolume>? {
        var totalInMilliliters = 0.0
        
        for entry in entries {
            guard let waterVolume = entry.waterVolume else {
                return nil
            }
            
            totalInMilliliters += waterVolume.converted(to: .milliliters).value
        }
        
        return Measurement(value: totalInMilliliters, unit: .milliliters)
    }
    
    // MARK: - Drink Breakdown
    // Purpose: Creates grouped raw liquid totals by drink type.
    //
    // Input: Uses the tracker's entries array and DrinkType.allCases.
    //
    // Returns:
    // An array of DrinkBreakdown values.
    // Each DrinkBreakdown represents one drink type that has at least one entry.
    //
    // Behavior:
    // Loops through every known DrinkType, filters the entries down to the
    // current type, skips the type when there are no matching entries, adds the
    // matching entry volumes together in milliliters, and returns one grouped
    // result for each drink type found.
    //
    // Notes:
    // This intentionally returns raw liquid volume only. Hydration contribution
    // by drink type will be handled separately when the model needs it.
    var drinkBreakdown: [DrinkBreakdown] {
        DrinkType.allCases.compactMap { type in
            let entriesForType = entries.filter { entry in
                entry.type == type
            }
        
            guard !entriesForType.isEmpty else {
                return nil
            }
            
            let totalInMilliliters = entriesForType.reduce(0.0) { total, entry in
                total + entry.amount.volume.converted(to: .milliliters).value
            }
            
            return DrinkBreakdown(
                type: type,
                totalVolume: Measurement(value: totalInMilliliters, unit: .milliliters)
            )
        }
    }
    
    // MARK: - Remaining Hydration Volume
        
    // Purpose:
    // Calculates how much estimated water volume is left before the daily
    // hydration target is met.
    //
    // Input: Uses dailyGoal.volume and totalWaterVolume.
    //
    // Returns:
    // An optional Measurement<UnitVolume> in milliliters.
    // Returns nil if totalWaterVolume is nil.
    //
    // Behavior:
    // Converts the goal and estimated water volume to milliliters, subtracts
    // estimated water consumed from the goal, and clamps the result at zero.
    //
    // Notes:
    // This is likely to become the main "remaining" value for the Today screen,
    // because the daily goal is understood as a hydration target.
    var remainingHydrationVolume: Measurement<UnitVolume>? {
        guard let totalWaterVolume = totalWaterVolume else {
            return nil
        }
        
        let goalInMilliliters = dailyGoal.volume.converted(to: .milliliters).value
        let totalInMilliliters = totalWaterVolume.converted(to: .milliliters).value
        let remainingInMilliliters = max(goalInMilliliters - totalInMilliliters, 0)
        
        return Measurement(value: remainingInMilliliters, unit: .milliliters)
    }
    
    // MARK: - Snapshot
        
    // Purpose:
    // Creates a HydrationSnapshot containing the tracker's current calculated state.
    //
    // Input:
    // Uses all current tracker state: entries, dailyGoal, and calculated values.
    //
    // Returns:
    // A HydrationSnapshot containing the current summary of today's hydration data.
    //
    // Behavior:
    // Packages several separate calculated values into one object so the UI and
    // view-data layer can read a single snapshot instead of repeatedly asking the
    // tracker for individual values.
    //
    // Notes:
    var snapshot: HydrationSnapshot {
        HydrationSnapshot(
            drinkCount: entries.count,
            totalVolume: totalVolume,
            totalWaterVolume: totalWaterVolume,
            goalVolume: dailyGoal.volume,
            remainingHydrationVolume: remainingHydrationVolume,
            drinkBreakdown: drinkBreakdown
        )
    }
}
