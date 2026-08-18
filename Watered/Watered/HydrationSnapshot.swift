//
//  HydrationSnapshot.swift
//  Watered
//
//  Created by Frank Sedivy on 04/07/2026.
//

import Foundation

// A capture view of hydration state at one point in time.
struct HydrationSnapshot {
    // MARK: - Stored Values
    
    let drinkCount: Int
    let totalVolume: Measurement<UnitVolume>
    let totalWaterVolume: Measurement<UnitVolume>?
    let goalVolume: Measurement<UnitVolume>
    let remainingVolume: Measurement<UnitVolume>
    let remainingHydrationVolume: Measurement<UnitVolume>?
    let drinkBreakdown: [DrinkBreakdown]
    
    // MARK: - Raw Liquid Progress
    // Purpose: Calculates raw liquid progress against the daily goal.
    //
    // Input: Uses totalVolume and goalVolume.
    //
    // Returns: A Double where 0 means no progress and 1 means the goal is complete.
    //
    // Behavior:
    // Converts totalVolume and goalVolume to milliliters, divides total by goal,
    // and caps the result at 1.
    //
    // Notes:
    // This treats all liquid volume equally. It may become less important as the
    // Today screen focuses on hydration contribution progress.
    var progress: Double {
        let total = totalVolume.converted(to: .milliliters).value
        let goal = goalVolume.converted(to: .milliliters).value
        
        guard goal > 0 else {
            return 0
        }
        
        return min(total / goal, 1)
    }
    
    // MARK: - Hydration Progress

    // Purpose: Calculates progress toward the daily hydration target.
    //
    // Input: Uses totalWaterVolume and goalVolume.
    //
    // Returns:
    // An optional Double where 0 means no progress and 1 means the goal is complete.
    // Returns nil if totalWaterVolume is unknown.
    //
    // Behavior:
    // If totalWaterVolume exists, converts totalWaterVolume and goalVolume to
    // milliliters, divides estimated water volume by goal, and caps the result at 1.
    //
    // Notes:
    // This is the progress value most closely aligned with the Today screen's
    // hydration target.
    var hydrationProgress: Double? {
        guard let totalWaterVolume = totalWaterVolume else {
            return nil
        }
        
        let total = totalWaterVolume.converted(to: .milliliters).value
        let goal = goalVolume.converted(to: .milliliters).value
        
        guard goal > 0 else {
            return 0
        }
        
        return min(total / goal, 1)
    }
}
