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
    
    // The total liquid intake represented as a Foundation volume measurement.
    var totalVolume: Measurement<UnitVolume> {
        let totalInMilliliters = entries.reduce(0) { total, entry in total + entry.amount.volume.converted(to: .milliliters).value
        }
        
        return Measurement(value: totalInMilliliters, unit: .milliliters)
    }
    
    // The remaining liquid needed to reach the daily goal.
    var remainingVolume: Measurement<UnitVolume> {
        let goalInMilliliters = dailyGoal.volume.converted(to: .milliliters).value
        let totalInMilliliters = totalVolume.converted(to: .milliliters).value
        let remainingInMilliliters = max(goalInMilliliters - totalInMilliliters, 0)
        
        return Measurement(value: remainingInMilliliters, unit: .milliliters)
    }
    
    // Temporary compatibility helper while existing UI/tests still expect milliliters
    var totalMilliliters: Double {
        totalVolume.converted(to: .milliliters).value
    }
    
    // Temporary compatibility helper while existing UI/tests still expect milliliter values
    var remainingMilliliters: Double {
        remainingVolume.converted(to: .milliliters).value
    }
}
