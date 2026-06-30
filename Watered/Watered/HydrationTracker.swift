//
//  HydrationTracker.swift
//  Watered
//
//  Created by Frank Sedivy on 30/06/2026.
//

import Foundation

struct HydrationTracker {
    var entries: [DrinkEntry] = []
    
    var totalMilliliters: Double {
        entries.reduce(0) {total, entry in
            total + entry.amount.volumeInMilliliters
        }
    }
}
