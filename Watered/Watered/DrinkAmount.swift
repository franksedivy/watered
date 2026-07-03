//
//  DrinkAmount.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import Foundation

struct DrinkAmount {
    let value: Double
    let unit: LiquidUnit
    
    // A short display string for console output and simple UI labels.
    var formatted: String {
        "\(Int(value)) \(unit.rawValue)"
    }
    
    // The amount represented using Foundations's generic volume measurement type
    var volume: Measurement<UnitVolume> {
        Measurement(
            value: value,
            unit: unit.foundationUnit
        )
    }
}
