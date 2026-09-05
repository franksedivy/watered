//
//  PersistentDrinkEntry.swift
//  Watered
//
//  Created by Frank Sedivy on 05/09/2026.
//

import Foundation
import SwiftData

// MARK: - Persistent Drink Entry
//
// Purpose:
// Stores a drink entry in SwiftData.
//
// Persistence role:
// Keeps storage concerns separate from the app model while still mapping cleanly
// back into DrinkEntry for hydration calculation and UI display.
@Model
final class PersistentDrinkEntry {
    var id: UUID = UUID()
    var drinkTypeID: String = "water"
    var volumeValue: Double = 0
    var unitID: String = "milliliters"
    var loggedAt: Date = Date()
    var createdAt: Date = Date()
    var updatedAt: Date = Date()
    var source: String = "manual"
    
    init(
        id: UUID = UUID(),
        drinkTypeID: String,
        volumeValue: Double,
        unitID: String,
        loggedAt: Date,
        createdAt: Date,
        updatedAt: Date,
        source: String
    ) {
        self.id = id
        self.drinkTypeID = drinkTypeID
        self.volumeValue = volumeValue
        self.unitID = unitID
        self.loggedAt = loggedAt
        self.createdAt = createdAt
        self.updatedAt = updatedAt
        self.source = source
    }
    
    // Purpose:
    // Creates a persistent entry from Watered's app model.
    convenience init(drinkEntry: DrinkEntry) {
        self.init(
            id: drinkEntry.id,
            drinkTypeID: drinkEntry.type.persistenceIdentifier,
            volumeValue: drinkEntry.amount.value,
            unitID: drinkEntry.amount.unit.persistenceIdentifier,
            loggedAt: drinkEntry.loggedAt,
            createdAt: drinkEntry.createdAt,
            updatedAt: drinkEntry.updatedAt,
            source: drinkEntry.source.rawValue
        )
    }
    
    // Purpose:
    // Recreates Watered's app model from persisted SwiftData values.
    //
    // Returns:
    // A DrinkEntry when all stored string values still map to known model values.
    func drinkEntry() -> DrinkEntry? {
        guard let drinkType = DrinkType(persistenceIdentifier: drinkTypeID),
              let liquidUnit = LiquidUnit(persistenceIdentifier: unitID),
              let drinkEntrySource = DrinkEntrySource(rawValue: source)
        else {
            return nil
        }
        
        return DrinkEntry(
            id: id,
            type: drinkType,
            amount: DrinkAmount(value: volumeValue, unit: liquidUnit),
            date: loggedAt,
            createdAt: createdAt,
            updatedAt: updatedAt,
            source: drinkEntrySource
        )
    }
    
}
