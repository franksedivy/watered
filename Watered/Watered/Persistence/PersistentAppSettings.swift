//
//  PersistentAppSettings.swift
//  Watered
//
//  Created by Frank Sedivy on 07/09/2026.
//

import Foundation
import SwiftData

// MARK: - Persistent App Settings
//
// Purpose:
// Stores Watered's user-configurable settings in SwiftData.
//
// Input:
// Accepts stable persistence identifiers and primitive values that SwiftData can
// store safely.
//
// Persistence role:
// Maps between the app's AppSettings model and the SwiftData row that survives
// app relaunches.
@Model
final class PersistentAppSettings {
    var id: String
    var displayUnitID: String
    var dailyGoalValue: Double
    var dailyGoalUnitID: String
    var createdAt: Date
    var updatedAt: Date
    
    init(
        id: String = "appSettings",
        displayUnitID: String,
        dailyGoalValue: Double,
        dailyGoalUnitID: String,
        createdAt: Date = Date(),
        updatedAt: Date = Date()
    ) {
        self.id = id
        self.displayUnitID = displayUnitID
        self.dailyGoalValue = dailyGoalValue
        self.dailyGoalUnitID = dailyGoalUnitID
        self.createdAt = createdAt
        self.updatedAt = updatedAt
    }
    
    convenience init(appSettings: AppSettings) {
        self.init(
            displayUnitID: appSettings.displayUnit.persistenceIdentifier,
            dailyGoalValue: appSettings.dailyHydrationGoal.amount.value,
            dailyGoalUnitID: appSettings.dailyHydrationGoal.amount.unit.persistenceIdentifier
        )
    }
    
    func appSettings() -> AppSettings? {
        guard let displayUnit = LiquidUnit(persistenceIdentifier: displayUnitID),
              let dailyGoalUnit = LiquidUnit(persistenceIdentifier: dailyGoalUnitID)
        else {
            return nil
        }
        
        return AppSettings(
            displayUnit: displayUnit,
            dailyHydrationGoal: HydrationGoal(
                amount: DrinkAmount(
                    value: dailyGoalValue,
                    unit: dailyGoalUnit
                )
            )
        )
    }
}
