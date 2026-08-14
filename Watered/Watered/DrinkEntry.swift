//
//  DrinkEntry.swift
//  Watered
//
//  Created by Frank Sedivy on 30/06/2026.
//

import Foundation

struct DrinkEntry: CustomStringConvertible {
    let type: DrinkType
    let amount: DrinkAmount
    let date: Date
    
    var description: String {
        "\(type.rawValue), \(amount)"
    }
    
    // Estimated physical water volume for the drink entry.
    var waterVolume: Measurement<UnitVolume>? {
        guard let waterContentRatio = type.waterContentRatio else {
            return nil
        }
        
        return Measurement(
            value: amount.volume.value * waterContentRatio,
            unit: amount.volume.unit
        )
    }
}
