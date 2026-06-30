//
//  LiquidUnit.swift
//  Watered
//
//  Created by Frank Sedivy on 26/06/2026.
//

import Foundation

// The volume units Watered understands when logging a drink.
enum LiquidUnit: String {
    case milliliters = "ml"
    case usFluidOunces = "US fl oz"
    case imperialFluidOunces = "imp fl oz"
    
    // The matching Foundaiton unit, used to for system-backed conversions
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
