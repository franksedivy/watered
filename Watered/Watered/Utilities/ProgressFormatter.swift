//
//  SnapshotFormatter.swift
//  Watered
//
//  Created by Frank Sedivy on 04/07/2026.
//
import Foundation

// Formats progress value for console output and early UI labels
nonisolated struct ProgressFormatter {
    nonisolated init() {}
    
    nonisolated func percentageString(from progress: Double) -> String {
        let roundedPercentage = Int((progress * 100).rounded())
        return "\(roundedPercentage)%"
    }
}
