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
        switch type.hydrationContributionRule {
        case .ratio(let ratio):
            return Measurement(
                value: amount.volume.value * ratio,
                unit: amount.volume.unit
            )
        case .alcohol(let defaultABV):
            let alcoholVolume = amount.volume.value * defaultABV
            let estimatedHydrationPenalty = alcoholVolume * 10
            let estimatedHydrationContribution = amount.volume.value - estimatedHydrationPenalty
            
            return Measurement(
                value: estimatedHydrationContribution,
                unit: amount.volume.unit
            )
        case .unknown:
            return nil
        }
    }
}
