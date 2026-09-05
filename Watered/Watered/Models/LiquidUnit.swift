//
//  LiquidUnit.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import Foundation

// The volume units Watered understands when logging a drink.
nonisolated enum LiquidUnit: String, CaseIterable, Identifiable {
    case milliliters = "ml"
    case usFluidOunces = "US fl oz"
    case imperialFluidOunces = "imp fl oz"

    // Purpose:
    // Gives each LiquidUnit a stable identity for a SwiftUI collections and pickers.
    //
    // Returns:
    // The unit itself, which is unique for every LiquidUnit case.
    //
    // UI role:
    // Lets ProfileView render all supported display units in a Picker without
    // inventing separate IDs or labels.
    var id: LiquidUnit {
        return self
    }

    // MARK: - Persistence
    //
    // Purpose:
    // Provides a stable value for persistence.
    //
    // Notes:
    // This avoids storing display labels such as "ml" as the app's durable data.
    var persistenceIdentifier: String {
        switch self {
        case .milliliters:          return "milliliters"
        case .usFluidOunces:        return "usFluidOunces"
        case .imperialFluidOunces:  return "imperialFluidOunces"
        }
    }

    // Purpose:
    // Recreates a liquid unit from a stored persistence value.
    init?(persistenceIdentifier: String) {
        switch persistenceIdentifier {
        case "milliliters":          self = .milliliters
        case "usFluidOunces":        self = .usFluidOunces
        case "imperialFluidOunces":  self = .imperialFluidOunces
        default:                     return nil
        }
    }

    // The matching Foundation unit, used for system-backed conversions.
    var foundationUnit: UnitVolume {
        switch self {
        case .milliliters:
            return .milliliters
        case .usFluidOunces:
            return .fluidOunces
        case .imperialFluidOunces:
            return .imperialFluidOunces
        }
    }
}
