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
    
    var totalMilliliters: Double {
        wateredLog("Calculating total from \(entries.count) drink entries")
        
        let total = entries.reduce(0) { total, entry in
            let newTotal = total + entry.amount.volumeInMilliliters()
            
            wateredLog("Added \(entry.type.rawValue); running total is \(Int(newTotal.rounded())) ml")
            
            return newTotal
        }
        
        wateredLog("Final total: \(Int(total.rounded())) ml")

        return total
    }
    
    var remainingMilliliters: Double {
        wateredLog("Calculating remaining hydration")
        
        let remaining = max(dailyGoal.volumeInMilliliters - totalMilliliters, 0)
        
        wateredLog("Remaining hydration: \(Int(remaining.rounded())) ml")
        
        return remaining
    }    
}
