//
//  DrinkAmount.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import Foundation

nonisolated struct DrinkAmount: CustomStringConvertible {
    let value: Double
    let unit: LiquidUnit
    
    var description: String {
        formatted
    }
    
    // A short display string for console output and simple UI labels.
    var formatted: String {
        "\(Int(value)) \(unit.rawValue)"
    }
    
    // The amount represented using Foundation's generic volume measurement type.
    var volume: Measurement<UnitVolume> {
        Measurement(
            value: value,
            unit: unit.foundationUnit
        )
    }
}
