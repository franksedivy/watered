//
//  File.swift
//  Watered
//
//  Created by Frank Sedivy on 01/07/2026.
//

import Foundation

// The user's target liquid intake for a single day
struct HydrationGoal {
    let amount: DrinkAmount
    
    // the goal converted to milliliters for internal calculations.
    var volumeInMilliliters: Double {
        let convertedGoal = amount.volumeInMilliliters()
        
        wateredLog("Daily goal converted: \(Int(convertedGoal.rounded())) ml")
        
        return convertedGoal
    }
}
