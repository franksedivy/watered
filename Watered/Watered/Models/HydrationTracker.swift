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
    // Input:
    // Uses the tracker's entries array.
    //
    // Returns:
    // A Measurement<UnitVolume> in the model's base calculation unit representing
    // total liquid consumed.
    //
    // Behavior:
    // Converts each entry amount to the model's base calculation unit, adds the
    // values together, and returns the final total as a Foundation Measurement.
    //
    // Notes:
    // This does not apply water-content ratios. Water, juice, tea, coffee, and
    // other drinks all count by their physical liquid volume.
    var totalVolume: Measurement<UnitVolume> {
        let totalBaseValue = entries.reduce(0.0) { total, entry in
            total + VolumeCalculation.baseValue(from: entry.amount.volume)
        }
        
        return VolumeCalculation.measurement(fromBaseValue: totalBaseValue)
    }
    
    // MARK: - Total Hydration Volume

    // Purpose: Calculates the estimated hydration contribution from all logged drink entries.
    //
    // Input: Uses the tracker's entries array and each entry's hydrationContributionVolume.
    //
    // Returns:
    // An optional Measurement<UnitVolume> in the model's base calculation unit.
    // Returns nil if any entry has unknown hydration contribution.
    //
    // Behavior:
    // Loops through entries one by one. If an entry has hydrationContributionVolume,
    // it is converted to the model's base calculation unit and added to the total.
    // If an entry has nil hydrationContributionVolume, the calculation stops and
    // returns nil.
    var totalHydrationVolume: Measurement<UnitVolume>? {
        var totalBaseValue = 0.0
        
        for entry in entries {
            guard let hydrationContributionVolume = entry.hydrationContributionVolume else {
                return nil
            }
            
            totalBaseValue += VolumeCalculation.baseValue(from: hydrationContributionVolume)
        }
        
        return VolumeCalculation.measurement(fromBaseValue: totalBaseValue)
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
    // matching entry volumes together in the base calculation unit, and returns one
    // grouped result for each drink type found.
    //
    // Notes:
    // This intentionally returns raw liquid volume only. Hydration contribution
    // by drink type will be handled separately when the model needs it.
    var drinkBreakdown: [DrinkBreakdown] {
        var breakdowns: [DrinkBreakdown] = []
        
        for type in DrinkType.allCases {
            let entriesForType = entries.filter { entry in
                entry.type == type
            }
            
            guard !entriesForType.isEmpty else {
                continue
            }
            
            var totalBaseValue = 0.0
            
            for entry in entriesForType {
                totalBaseValue += VolumeCalculation.baseValue(from: entry.amount.volume)
            }
            
            var totalHydrationBaseValue = 0.0
            var hasUnknownHydrationContribution = false
            
            for entry in entriesForType {
                guard let hydrationContributionVolume = entry.hydrationContributionVolume else {
                    hasUnknownHydrationContribution = true
                    break
                }
                
                totalHydrationBaseValue += VolumeCalculation.baseValue(from: hydrationContributionVolume)
            }
            
            let totalHydrationVolume: Measurement<UnitVolume>?
            
            if hasUnknownHydrationContribution {
                totalHydrationVolume = nil
            } else {
                totalHydrationVolume = VolumeCalculation.measurement(
                    fromBaseValue: totalHydrationBaseValue
                )
            }
            
            let breakdown = DrinkBreakdown(
                type: type,
                totalVolume: VolumeCalculation.measurement(fromBaseValue: totalBaseValue),
                totalHydrationVolume: totalHydrationVolume
            )
            
            breakdowns.append(breakdown)
        }
        
        return breakdowns
    }
    
    // MARK: - Remaining Hydration Volume
        
    // Purpose:
    // Calculates how much hydration contribution is left before the daily
    // hydration target is met.
    //
    // Input: Uses dailyGoal.volume and totalHydrationVolume.
    //
    // Returns:
    // An optional Measurement<UnitVolume> in the model's base calculation unit.
    // Returns nil if totalHydrationVolume is nil.
    //
    // Behavior:
    // Converts the goal and hydration contribution to the model's base calculation
    // unit, subtracts hydration contribution from the goal, and clamps the result
    // at zero.
    //
    // Notes:
    // This is likely to become the main "remaining" value for the Today screen,
    // because the daily goal is understood as a hydration target.
    var remainingHydrationVolume: Measurement<UnitVolume>? {
        guard let totalHydrationVolume = totalHydrationVolume else {
            return nil
        }
        
        let goalBaseValue = VolumeCalculation.baseValue(from: dailyGoal.volume)
        let totalBaseValue = VolumeCalculation.baseValue(from: totalHydrationVolume)
        let remainingBaseValue = max(goalBaseValue - totalBaseValue, 0)
        
        return VolumeCalculation.measurement(fromBaseValue: remainingBaseValue)
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
            totalHydrationVolume: totalHydrationVolume,
            goalVolume: dailyGoal.volume,
            remainingHydrationVolume: remainingHydrationVolume,
            drinkBreakdown: drinkBreakdown
        )
    }
}
