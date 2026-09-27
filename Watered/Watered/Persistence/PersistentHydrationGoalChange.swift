//
//  PersistentHydrationGoalChanges.swift
//  Watered
//
//  Created by Frank Sedivy on 27/09/2026.
//

import Foundation
import SwiftData

/// Stores a committed hydration goal change in SwiftData.
///
/// Keeps persistence details separate from HydrationGoalChange. Reading a record preserves its original idneitity and changes
/// timestamp rather than creating a new historical event.
@Model
final class PersistentHydrationGoalChange {
    var id: UUID = UUID()
    var goalValue: Double = 0
    var goalUnitID: String = "milliliters"
    var changedAt: Date = Date()
    var source: String = "appDefault"
    
    /// Creates a storage record from an existing goal change.
    ///
    /// This only constructs the record; the persistence boudnary inserts and saves it.
    ///
    /// - Parameter change: The committed goal change whose values whould be preserved.
    init(change: HydrationGoalChange) {
        self.id = change.id
        self.goalValue = change.goal.amount.value
        self.goalUnitID = change.goal.amount.unit.persistenceIdentifier
        self.changedAt = change.changedAt
        self.source = change.source.rawValue
    }
    
    /// Reconstructs the app model from the stored values.
    ///
    /// - Returns: The recorded goal change, or nil if its unit or source is unrecognised.
    func hydrationGoalChange() -> HydrationGoalChange? {
        guard let unit = LiquidUnit(persistenceIdentifier: goalUnitID),
              let goalSource = HydrationGoalSource(rawValue: source)
                else {
            return nil
        }
        
        return HydrationGoalChange(
            id: id,
            goal: HydrationGoal(
                amount: DrinkAmount(value: goalValue, unit: unit)
            ),
            changedAt: changedAt,
            source: goalSource
        )
    }
}
