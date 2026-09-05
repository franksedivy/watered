//
//  DrinkEntry.swift
//  Watered
//
//  Created by Frank Sedivy on 30/06/2026.
//

import Foundation

nonisolated struct DrinkEntry: Identifiable, CustomStringConvertible {
    let id: UUID
    let type: DrinkType
    let amount: DrinkAmount
    let date: Date
    let createdAt: Date
    let updatedAt: Date
    let source: DrinkEntrySource
    
    var description: String {
        "\(type.rawValue), \(amount)"
    }
    
    // Purpose:
    // Provides a clearer name for the date the drink was logged for.
    //
    // Notes:
    // This keeps the existing 'date' property stable while preparing th emodel for
    // the future persistent 'loggedAt' field.
    var loggedAt: Date {
        date
    }
    
    init(
        id: UUID = UUID(),
        type: DrinkType,
        amount: DrinkAmount,
        date: Date,
        createdAt: Date = Date(),
        updatedAt: Date = Date(),
        source: DrinkEntrySource = .manual
    ) {
        self.id = id
        self.type = type
        self.amount = amount
        self.date = date
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.source = source
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
