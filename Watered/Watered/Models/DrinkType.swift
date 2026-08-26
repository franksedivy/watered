//
//  DrinkType.swift
//  Watered
//
//  Created by Frank Sedivy on 30/06/2026.
//

import Foundation

enum HydrationContributionRule: Equatable {
    case ratio(Double)
    case alcohol(defaultABV: Double)
    case unknown
}

enum DrinkType: String, CaseIterable {
    // MARK: - Cases
    
    // Non-alcoholic drinks
    case water  = "Water"
    case coffee = "Coffee"
    case tea    = "Tea"
    case juice  = "Juice"
    
    // Alcoholic drinks
    case beer   = "Beer"
    case cider  = "Cider"
    case wine   = "Wine"
    case spirits = "Spirits"
    
    // Other types
    case other  = "Other"
    
    // MARK: - Hydration Contribution
    
    // Purpose:
    // Describes how Watered should estimate hydration contribution for this drink type.
    //
    // Returns:
    // A HydrationContributionRule.
    //
    // Behavior:
    // Non-alcoholic drinks use a simple ratio.
    // Alcoholic drinks use a default ABV for alcohol impact calculations.
    // Other remains unknown so Watered does not silently guess.
    var hydrationContributionRule: HydrationContributionRule {
        switch self {
        case .water:    return .ratio(1.0)
        case .coffee:   return .ratio(0.99)
        case .tea:      return .ratio(0.99)
        case .juice:    return .ratio(0.89)
        
        case .beer:     return .alcohol(defaultABV: 0.05)
        case .cider:    return .alcohol(defaultABV: 0.05)
        case .wine:     return .alcohol(defaultABV: 0.13)
        case .spirits:  return .alcohol(defaultABV: 0.40)
            
        case .other:    return .unknown
        }
    }
}
