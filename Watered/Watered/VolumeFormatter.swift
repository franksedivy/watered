//
//  VolumeFormatter.swift
//  Watered
//
//  Created by Frank Sedivy on 03/07/2026.
//

// Formats volume measurements for simple console output and early UI labels.
import Foundation

struct VolumeFormatter {
    func
        wholeNumberString(from volume: Measurement<UnitVolume>,
        convertedTo unit: UnitVolume = .milliliters) -> String {
            let convertedVolume = volume.converted(to: unit)
            let roundedValue = Int(convertedVolume.value.rounded())
        
        return "\(roundedValue) \(convertedVolume.unit.symbol)"
    }
}
