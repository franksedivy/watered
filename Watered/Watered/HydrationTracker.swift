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
    
    // The total estimated water content from all drink entries.
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
    
    // The remaining liquid needed to reach the daily goal.
    var remainingVolume: Measurement<UnitVolume> {
        let goalInMilliliters = dailyGoal.volume.converted(to: .milliliters).value
        let totalInMilliliters = totalVolume.converted(to: .milliliters).value
        let remainingInMilliliters = max(goalInMilliliters - totalInMilliliters, 0)
        
        return Measurement(value: remainingInMilliliters, unit: .milliliters)
    }
    
    // The remaining estimated water needed to reach the daily goal.
    var remainingWaterVolume: Measurement<UnitVolume>? {
        guard let totalWaterVolume = totalWaterVolume else {
            return nil
        }
        
        let goalInMilliliters = dailyGoal.volume.converted(to: .milliliters).value
        let totalInMilliliters = totalWaterVolume.converted(to: .milliliters).value
        let remainingInMilliliters = max(goalInMilliliters - totalInMilliliters, 0)
        
        return Measurement(value: remainingInMilliliters, unit: .milliliters)
    }
    
    // Captures the current hydration state once for display, logging, or UI
    var snapshot: HydrationSnapshot {
        HydrationSnapshot(
            drinkCount: entries.count,
            totalVolume: totalVolume,
            totalWaterVolume: totalWaterVolume,
            goalVolume: dailyGoal.volume,
            remainingVolume: remainingVolume,
            remainingWaterVolume: remainingWaterVolume)
    }
}
