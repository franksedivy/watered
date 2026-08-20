//
//  HydrationSummaryViewData.swift
//  Watered
//
//  Created by Frank Sedivy on 13/08/2026.
//

import Foundation

//Display-ready values for one drink breakdown row
struct DrinkBreakdownViewData {
    let consumedText: String
    let hydrationImpactText: String
}

// Display-ready values for the hydration summary screen.
struct HydrationSummaryViewData {
    let totalText: String
    let goalText: String
    let remainingText: String
    let drinkCountText: String
    let progressText: String
    let progressValue: Double
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
        goalText = "Hydration goal: \(goal)"
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
            progressText = progressFormatter.percentageString(from: hydrationProgress)
            progressValue = hydrationProgress
        } else {
            progressText = "Hydration progress unknown"
            progressValue = 0.0
        }
        
        drinkBreakdownRows = snapshot.drinkBreakdown.map { drinkBreakdown in
            let amount = volumeFormatter.wholeNumberString(
                from: drinkBreakdown.totalVolume,
                displayedAs: displayUnit
            )
            let drinkType = drinkBreakdown.type.rawValue.lowercased()
            let consumedText = "\(amount) of \(drinkType)"
            
            let hydrationImpactText: String
            
            if let totalHydrationVolume = drinkBreakdown.totalHydrationVolume {
                let hydrationImpact = volumeFormatter.wholeNumberString(
                    from: totalHydrationVolume,
                    displayedAs: displayUnit
                )
                hydrationImpactText = "Hydration impact: \(hydrationImpact)"
            } else {
                hydrationImpactText = "Hydration impact: Unknown"
            }
            
            return DrinkBreakdownViewData(
                consumedText: consumedText,
                hydrationImpactText: hydrationImpactText
            )
        }
    }
}
