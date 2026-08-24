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
    let totalHydrationVolume: Measurement<UnitVolume>?
    let goalVolume: Measurement<UnitVolume>
    let remainingHydrationVolume: Measurement<UnitVolume>?
    let drinkBreakdown: [DrinkBreakdown]
    
    // MARK: - Hydration Progress

    // Purpose: Calculates progress toward the daily hydration target.
    //
    // Input: Uses totalHydrationVolume and goalVolume.
    //
    // Returns:
    // An optional Double where 0 means no progress and 1 means the goal is complete.
    // Returns nil if totalHydrationVolume is unknown.
    //
    // Behavior:
    // If totalHydrationVolume exists, converts totalHydrationVolume and goalVolume
    // to the model's base calculation unit, divides hydration contribution by goal,
    // and caps the result at 1.
    var hydrationProgress: Double? {
        guard let totalHydrationVolume = totalHydrationVolume else {
            return nil
        }
        
        let totalBaseValue = VolumeCalculation.baseValue(from: totalHydrationVolume)
        let goalBaseValue = VolumeCalculation.baseValue(from: goalVolume)
        
        guard goalBaseValue > 0 else {
            return 0
        }
        
        return totalBaseValue / goalBaseValue
    }
    
    // Purpose:
    // Provides a progress value that is safe for SwiftUI ProgressView.
    //
    // Returns:
    // Hydration progress clamped to the visual range 0...1.
    var clampedHydrationProgress: Double? {
        guard let hydrationProgress = hydrationProgress else {
            return nil
        }
        
        return min(max(hydrationProgress,0), 1)
    }
}
