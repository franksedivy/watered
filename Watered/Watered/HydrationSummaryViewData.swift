//
//  HydrationSummaryViewData.swift
//  Watered
//
//  Created by Frank Sedivy on 13/08/2026.
//

import Foundation

// Display-ready values for the hydration summary screen.
struct HydrationSummaryViewData {
    let totalText: String
    let goalText: String
    let remainingText: String
    let drinkCountText: String
    let progressText: String
    let progressValue: Double
    
    init(
        snapshot: HydrationSnapshot,
        volumeFormatter: VolumeFormatter,
        progressFormatter: ProgressFormatter
    ) {
        totalText = "Total: \(volumeFormatter.wholeNumberString(from: snapshot.totalVolume))"
        goalText = "Goal: \(volumeFormatter.wholeNumberString(from: snapshot.goalVolume))"
        remainingText = "Remaining: \(volumeFormatter.wholeNumberString(from: snapshot.remainingVolume))"
        drinkCountText = "Drinks logged: \(snapshot.drinkCount)"
        progressText = progressFormatter.percentageString(from: snapshot.progress)
        progressValue = snapshot.progress
    }
}
