//
//  DrinkBreakdown.swift
//  Watered
//
//  Created by Frank Sedivy on 17/08/2026.
//

import Foundation

struct DrinkBreakdown {
    // MARK: - Stored Values
        
    // Purpose:
    // Identifies the drink type represented by this breakdown.
    //
    // Type:
    // A DrinkType value such as water, coffee, tea, juice, or other.
    let type: DrinkType
    
    // Purpose:
    // Stores the total raw liquid volume consumed for this drink type.
    //
    // Type:
    // A Measurement<UnitVolume> using Foundation measurement units.
    let totalVolume: Measurement<UnitVolume>
    
    // Purpose:
    // Stores the estimated hydration contribution for this drink type.
    //
    // Type:
    // An optional Measurement<UnitVolume>.
    //
    // Notes:
    // This is nil when the app does not know how much hydration this drink type
    // contributes, such as the current "Other" drink type.
    let totalHydrationVolume: Measurement<UnitVolume>?
}
