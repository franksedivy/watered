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
        let amount = DrinkAmount(value: 8, unit: .usFluidOunces)
        
        #expect(amount.formatted == "8 US fl oz")
    }
    
    @Test func drinkEntryStoresTypeAmountAndDate() async throws {
        let date = Date()
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        let entry = DrinkEntry(
            type: .water,
            amount: amount,
            date: date
        )
        
        #expect(entry.type == .water)
        #expect(entry.amount.formatted == "250 ml")
        #expect(entry.date == date)
    }
    
    @Test func hydrationTrackerCalculatesTotalVolume() async throws {
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
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [water, tea],
            dailyGoal: goal
        )
        
        let total = tracker.totalVolume.converted(to: .milliliters)
        
        #expect(total.value == 550)
    }
    
    @Test func drinkAmountConvertsImperialFluidOUncestoMilliliters() async throws {
        let amount = DrinkAmount(value: 8, unit: .imperialFluidOunces)
        let volume = amount.volume.converted(to: .milliliters)
        
        #expect(Int(volume.value.rounded()) == 227)
    }
    
    @Test func hydrationTrackerCalculatesRemainingVolume() async throws {
        let water = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 550, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [water],
            dailyGoal: goal
        )
        
        let remaining = tracker.remainingVolume.converted(to: .milliliters)
        
        #expect(remaining.value == 1450)
    }
    
    @Test func volumeFormatterFormatsWholeMilliliters() async throws {
        let formatter = VolumeFormatter()
        let volume = Measurement(value: 477.2, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume) == "477 mL")
    }
}
