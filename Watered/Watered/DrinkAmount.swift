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
    
    var formatted: String {
        "\(Int(value)) \(unit.rawValue)"
    }
}
