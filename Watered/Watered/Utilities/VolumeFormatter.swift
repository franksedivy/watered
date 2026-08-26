//
//  VolumeFormatter.swift
//  Watered
//
//  Created by Frank Sedivy on 03/07/2026.
//

// Formats volume measurements for simple console output and early UI labels.
import Foundation

struct VolumeFormatter {
    private let locale: Locale
    
    init(locale: Locale = .current) {
        self.locale = locale
    }
    
    // MARK: - Whole Number Formatting
        
    // Purpose:
    // Formats a volume measurement as a rounded whole number in the requested display unit.
    //
    // Input:
    // Uses a Measurement<UnitVolume> and a LiquidUnit.
    //
    // Returns:
    // A localised display string such as "1000 ml", "34 US fl oz", or "35 fl oz".
    //
    // Behavior:
    // Converts the measurement to the LiquidUnit's Foundation unit, then asks
    // Foundation's Measurement.FormatStyle to format the value and unit label.
    //
    // Notes:
    // This controls display only. It does not change how the model stores or
    // calculates volume values.
    func wholeNumberString(
        from volume: Measurement<UnitVolume>,
        displayedAs unit: LiquidUnit = .milliliters
    ) -> String {
        let convertedVolume = volume.converted(to: unit.foundationUnit)
        
        return convertedVolume.formatted(
            .measurement(
                width: .abbreviated,
                usage: .asProvided,
                numberFormatStyle:
                    .number.precision(.fractionLength(0))
                    .grouping(.never)
            )
            .locale(locale)
        )
    }
}
