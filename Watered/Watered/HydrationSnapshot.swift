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
}
