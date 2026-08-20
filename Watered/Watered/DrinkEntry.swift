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
    
    // MARK: - Hydration Contribution
    // Estimated hydration contribution for this drink entry.
    var hydrationContributionVolume: Measurement<UnitVolume>? {
        guard let hydrationContributionRatio = type.hydrationContributionRatio else {
            return nil
        }
        
        return Measurement(
            value: amount.volume.value * hydrationContributionRatio,
            unit: amount.volume.unit
        )
    }
}
