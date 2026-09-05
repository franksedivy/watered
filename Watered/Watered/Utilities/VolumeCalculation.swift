//
//  VolumeCalculation.swift
//  Watered
//
//  Created by Frank Sedivy on 19/08/2026.
//

import Foundation

// Centralises the volume unit Watered uses for internal model calculations.
nonisolated enum VolumeCalculation {
    
    // MARK: - Base Unit
    
    // Purpose:
    // Defines the single unit used when the model needs to compare, add, or
    // subtract volume measurements.
    //
    // Notes:
    // This is not the user's display unit. Display formatting is handled by
    // VolumeFormatter and LiquidUnit.
    nonisolated static let baseUnit: UnitVolume = .milliliters
    
    // MARK: - Conversion
    
    // Purpose:
    // Converts any volume measurement into the model's base calculation value.
    //
    // Input:
    // Uses a Measurement<UnitVolume> in any supported Foundation volume unit.
    //
    // Returns:
    // A Double representing the measurement value in the base calculation unit.
    nonisolated static func baseValue(from volume: Measurement<UnitVolume>) -> Double {
        volume.converted(to: baseUnit).value
    }
    
    // MARK: - Measurement Creation
    
    // Purpose:
    // Create a volume measurement from a value already expressed in the base
    // calculation unit.
    //
    // Input:
    // Uses a Double that has already been calculated in the base unit.
    //
    // Returns:
    // A Measurement<UnitVolume> using the base calculation unit.
    nonisolated static func measurement(fromBaseValue value: Double) -> Measurement<UnitVolume> {
        Measurement(value: value, unit: baseUnit)
    }
}
