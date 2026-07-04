//
//  HydrationSnapshot.swift
//  Watered
//
//  Created by Frank Sedivy on 04/07/2026.
//

import Foundation

// A capture view of hydration state at one point in time.
struct HydrationSnapshot {
    let drinkCount: Int
    let totalVolume: Measurement<UnitVolume>
    let goalVolume: Measurement<UnitVolume>
    let remainingVolume: Measurement<UnitVolume>
    
    // Progress toward the daily goal, where 0 is empty and 1 is complete.
    var progress: Double {
        let total = totalVolume.converted(to: .milliliters).value
        let goal = goalVolume.converted(to: .milliliters).value
        
        guard goal > 0 else {
            return 0
        }
        
        return min(total / goal, 1)
    }
}
