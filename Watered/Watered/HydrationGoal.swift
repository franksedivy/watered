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
    
    // The goal represented as a Foundation volume measurement.
    var volume: Measurement<UnitVolume> {
        amount.volume
    }
}
