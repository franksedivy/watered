//
//  WateredTests.swift
//  WateredTests
//
//  Created by Frank Sedivy on 26/06/2026.
//

import Foundation
import Testing
@testable import Watered

struct WateredTests {

    @Test func drinkAmountFormatsMilliliters() async throws {
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        #expect(amount.formatted == "250 ml")
    }
    
    @Test func drinkAmountFluidOunces() async throws {
        let amount = DrinkAmount(value: 8, unit: .fluidOunces)
        
        #expect(amount.formatted == "8 fl oz")
    }
    
    @Test func drinkEntryStoresTypeAmountAndDate() async throws {
        let date = Date()
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        let entry = DrinkEntry(
            type: .water,
            amount: amount,
            date: date
        )
    }
    
    @Test func hydrationTrackerCalculatesTotalMilliliters() async throws {
        let water = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let tea = DrinkEntry(
            type: .tea,
            amount: DrinkAmount(value: 300, unit: .milliliters),
            date: Date()
        )
        
        let tracker = HydrationTracker(entries: [water, tea])
        
        #expect(tracker.totalMilliliters == 550)
    }
}
