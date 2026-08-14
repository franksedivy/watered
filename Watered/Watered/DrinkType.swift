//
//  DrinkType.swift
//  Watered
//
//  Created by Frank Sedivy on 30/06/2026.
//

import Foundation

enum DrinkType: String {
    case water = "Water"
    case coffee = "Coffee"
    case tea = "Tea"
    case juice = "Juice"
    case other = "Other"
    
    // Estimated physical water content for each drink type.
    var waterContentRatio: Double? {
        switch self {
        case .water:
            return 1.0
        case .coffee:
            return 0.99
        case .tea:
            return 0.99
        case .juice:
            return 0.89
        case .other:
            return nil
        }
    }
}
