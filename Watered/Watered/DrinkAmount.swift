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
        let text = "\(Int(value)) \(unit.rawValue)"
        
        wateredLog("Formatted drink amount: \(text)")
        
        return text
    }
    
    // Converts any supported unit into milliliters for consisten totals.
    func volumeInMilliliters(label: String = "drink amount") -> Double {
        wateredLog("Converting \(label): \(formatted)")
        
        let measurement = Measurement(
            value: value,
            unit: unit.foundationUnit
        )
        
        let convertedValue = measurement.converted(to: .milliliters).value
        
        wateredLog("Converted \(label): \(Int(convertedValue.rounded())) ml")
        
        return convertedValue
    }
}
