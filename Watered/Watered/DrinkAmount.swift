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
    
    // Converts any supported unit into milliliters for consisten totals.
    var volumeInMilliliters: Double {
        let measurement = Measurement(
            value: value,
            unit: unit.foundationUnit
        )
        
        return measurement.converted(to: .milliliters).value
    }
}
