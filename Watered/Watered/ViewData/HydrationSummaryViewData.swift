//
//  HydrationSummaryViewData.swift
//  Watered
//
//  Created by Frank Sedivy on 13/08/2026.
//

import Foundation

// MARK: - Drink Breakdown Hydration Impact Style
//
// Purpose:
// Describes how a drink breakdown row should visually communicate its hydration
// impact.
//
// Values:
// - positive: the drink contributes its full consumed volume as hydration.
// - reduced: the drink contributes hydration, but less than its raw consumed volume.
// - negative: the drink reduces the user's net hydration progress.
// - unknown: Watered does not know the drink's hydration contribution.
//
// UI role:
// Gives SwiftUI a semantic styling value without making the view parse display
// text or repeat hydration calculation logic.
nonisolated enum HydrationImpactStyle {
    case positive
    case reduced
    case negative
    case unknown
}

extension HydrationImpactStyle {
    // MARK: - Initialisation
    //
    // Purpose:
    // Creates a semantic hydration impact style from a hydration contribution
    // percentage.
    //
    // Input:
    // Accepts hydrationImpactProgress as a decimal value, where 1.0 means 100%.
    //
    // Returns:
    // A HydrationImpactStyle bucket used by the UI.
    //
    // Behavior:
    // 80% and above is strong, 30% to 79% is reduced, and anything below 30%
    // is low or negative.
    nonisolated init(hydrationImpactProgress: Double) {
        if hydrationImpactProgress >= 0.8 {
            self = .positive
        } else if hydrationImpactProgress >= 0.3 {
            self = .reduced
        } else {
            self = .negative
        }
    }
}

// Display-ready values for one drink breakdown row.
nonisolated struct DrinkBreakdownViewData {
    let consumedText: String
    let hydrationImpactText: String
    let hydrationImpactStyle: HydrationImpactStyle
}

// Display-ready values for the hydration summary screen.
nonisolated struct HydrationSummaryViewData {
    let totalText: String
    let totalAmountText: String
    let goalText: String
    let goalAmountText: String
    let remainingText: String
    let drinkCountText: String
    let progressText: String
    let actualProgressValue: Double?
    let visualProgressValue: Double
    let drinkBreakdownRows: [DrinkBreakdownViewData]
    
    // MARK: - Initialisation
    
    // Purpose: Converts a HydrationSnapshot into simple display-ready values.
    //
    // Input: Uses a HydrationSnapshot, VolumeFormatter, ProgressFormatter and
    // display unit.
    //
    // Returns:
    // A HydrationSummaryViewData value containing strings and progress values
    // ready for the SwiftUI view to display.
    //
    // Behavior:
    // Formats raw liquid total for the main Today total, formats progress from
    // estimated water contribution, formats remaining hydration when it is known,
    // and formats grouped drink breakdown rows.
    //
    // Notes:
    // This type prepares text for the UI, but it does not calculate hydration
    // totals itself. Those calculations belong to HydrationTracker and
    // HydrationSnapshot.
    init(
        snapshot: HydrationSnapshot,
        volumeFormatter: VolumeFormatter,
        progressFormatter: ProgressFormatter,
        displayUnit: LiquidUnit = .milliliters
    ) {
        let totalLiquid = volumeFormatter.wholeNumberString(
            from: snapshot.totalVolume,
            displayedAs: displayUnit
        )
        let goal = volumeFormatter.wholeNumberString(
            from: snapshot.goalVolume,
            displayedAs: displayUnit
        )
        
        totalText = "Total liquid: \(totalLiquid)"
        totalAmountText = totalLiquid
        goalText = "Hydration goal: \(goal)"
        goalAmountText = goal
        drinkCountText = "Drinks logged: \(snapshot.drinkCount)"
        
        if let remainingHydrationVolume = snapshot.remainingHydrationVolume {
            let remainingHydration = volumeFormatter.wholeNumberString(
                from: remainingHydrationVolume,
                displayedAs: displayUnit
            )
            remainingText = "Remaining hydration: \(remainingHydration)"
        } else {
            remainingText = "Remaining hydration: Unknown"
        }
        
        if let hydrationProgress = snapshot.hydrationProgress {
            let textProgress = max(hydrationProgress, 0)
            
            progressText = progressFormatter.percentageString(from: textProgress)
            actualProgressValue = hydrationProgress
            visualProgressValue = snapshot.clampedHydrationProgress ?? 0.0
        } else {
            progressText = "Hydration progress unknown"
            actualProgressValue = nil
            visualProgressValue = 0.0
        }
        
        drinkBreakdownRows = snapshot.drinkBreakdown.map { drinkBreakdown in
            let amount = volumeFormatter.wholeNumberString(
                from: drinkBreakdown.totalVolume,
                displayedAs: displayUnit
            )
            let drinkType = drinkBreakdown.type.rawValue.lowercased()
            let consumedText = "\(amount) of \(drinkType)"
            
            let hydrationImpactText: String
            let hydrationImpactStyle: HydrationImpactStyle
            
            if let totalHydrationVolume = drinkBreakdown.totalHydrationVolume {
                let totalLiquidBaseValue = VolumeCalculation.baseValue(from: drinkBreakdown.totalVolume)
                let totalHydrationBaseValue = VolumeCalculation.baseValue(from: totalHydrationVolume)
                
                let hydrationImpactProgress = totalHydrationBaseValue / totalLiquidBaseValue
                let hydrationImpact = progressFormatter.percentageString(from: hydrationImpactProgress)
                
                hydrationImpactText = "Hydration impact: \(hydrationImpact)"
                hydrationImpactStyle = HydrationImpactStyle(hydrationImpactProgress: hydrationImpactProgress)
            } else {
                hydrationImpactText = "Hydration impact: Unknown"
                hydrationImpactStyle = .unknown
            }
            
            return DrinkBreakdownViewData(
                consumedText: consumedText,
                hydrationImpactText: hydrationImpactText,
                hydrationImpactStyle: hydrationImpactStyle
            )
        }
    }
}
