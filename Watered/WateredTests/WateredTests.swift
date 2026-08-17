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
    
    // MARK: - DrinkAmount
    
    @Test func drinkAmountFormatsMilliliters() async throws {
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        #expect(amount.formatted == "250 ml")
    }
    
    @Test func drinkAmountFluidOunces() async throws {
        let amount = DrinkAmount(value: 8, unit: .usFluidOunces)
        
        #expect(amount.formatted == "8 US fl oz")
    }
    
    @Test func drinkAmountConvertsImperialFluidOuncesToMilliliters() async throws {
        let amount = DrinkAmount(value: 8, unit: .imperialFluidOunces)
        let volume = await amount.volume.converted(to: .milliliters)
        
        #expect(Int(volume.value.rounded()) == 227)
    }
    
    @Test func drinkAmountDescriptionUsesFormattedAmount() async throws {
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        #expect(await amount.description == "250 ml")
    }
    
    // MARK: - DrinkType
    
    @Test func drinkTypeWaterHasFullWaterContent() async throws {
        #expect(DrinkType.water.waterContentRatio == 1)
    }
    
    @Test func drinkTypeTeaHasEstimatedWaterContent() async throws {
        #expect(DrinkType.tea.waterContentRatio == 0.99)
    }
    
    @Test func drinkTypeJuiceHasEstimatedWaterContent() async throws {
        #expect(DrinkType.juice.waterContentRatio == 0.89)
    }
    
    @Test func drinkTypeCoffeeHasEstimatedWaterContent() async throws {
        #expect(DrinkType.coffee.waterContentRatio == 0.99)
    }
    
    @Test func drinkTypeOtherHasUnknownWaterContent() async throws {
        #expect(DrinkType.other.waterContentRatio == nil)
    }
    
    // MARK: - DrinkEntry
    
    @Test func drinkEntryStoresTypeAmountAndDate() async throws {
        let date = Date()
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        let entry = DrinkEntry(
            type: .water,
            amount: amount,
            date: date
        )
        
        #expect(entry.type == .water)
        #expect(await entry.amount.formatted == "250 ml")
        #expect(entry.date == date)
    }
    
    @Test func drinkEntryDescriptionIncludesTypeAndAmount() async throws {
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        #expect(await entry.description == "Water, 250 ml")
    }
    
    @Test func drinkEntryWaterVolumeKeepsFullWaterAmount() async throws {
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let waterVolume = await entry.waterVolume?.converted(to: .milliliters)
        
        #expect(waterVolume?.value == 250)
    }
    
    @Test func drinkEntryJuiceWaterVolumeUsesWaterContentRatio() async throws {
        let entry = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 100, unit: .milliliters),
            date: Date()
        )
        
        let waterVolume = await entry.waterVolume?.converted(to: .milliliters)
        
        #expect(waterVolume?.value == 89)
    }
    
    @Test func drinkEntryOtherWaterVolumeIsUnknown() async throws {
        let entry = DrinkEntry(
            type: .other,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        #expect(await entry.waterVolume == nil)
    }
    
    // MARK: - HydrationTracker
    
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
        
        let total = await tracker.totalVolume.converted(to: .milliliters)
        
        #expect(total.value == 550)
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
        
        let remaining = await tracker.remainingVolume.converted(to: .milliliters)
        
        #expect(remaining.value == 1450)
    }
    
    @Test func hydrationTrackerCalculatesTotalWaterVolume() async throws {
        let water = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let juice = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 100, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [water, juice],
            dailyGoal: goal
        )
        
        let totalWater = await tracker.totalWaterVolume?.converted(to: .milliliters)
        
        #expect(totalWater?.value == 339)
    }
    
    @Test func hydrationTrackerCalculatesRemainingWaterVolume() async throws {
        let juice = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 100, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 500, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [juice],
            dailyGoal: goal
        )
        
        let remainingWater = await tracker.remainingWaterVolume?.converted(to: .milliliters)
        
        #expect(remainingWater?.value == 411)
    }
    
    @Test func hydrationTrackerWaterVolumeIsUnknownWhenEntryWaterVolumeIsUnknown() async throws {
        let other = DrinkEntry(
            type: .other,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [other],
            dailyGoal: goal
        )
        
        #expect(await tracker.totalWaterVolume == nil)
        #expect(await tracker.remainingWaterVolume == nil)
    }
    
    @MainActor
    @Test func hydrationTrackerCreatesSnapshot() async throws {
        let water = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 500, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [water],
            dailyGoal: goal
        )
        
        let snapshot = tracker.snapshot
        let breakdown = snapshot.drinkBreakdown
        let firstBreakdown = breakdown.first
        let firstBreakdownTotal = firstBreakdown?.totalVolume.converted(to: .milliliters)
        
        #expect(snapshot.drinkCount == 1)
        #expect(snapshot.totalVolume.converted(to: .milliliters).value == 500)
        #expect(snapshot.totalWaterVolume?.converted(to: .milliliters).value == 500)
        #expect(snapshot.goalVolume.converted(to: .milliliters).value == 2000)
        #expect(snapshot.remainingVolume.converted(to: .milliliters).value == 1500)
        #expect(snapshot.remainingWaterVolume?.converted(to: .milliliters).value == 1500)
        #expect(breakdown.count == 1)
        #expect(firstBreakdown?.type == .water)
        #expect(firstBreakdownTotal?.value == 500)
    }
    
    // Given multiple drink entries, including two entries with the same drink type,
    // when the tracker creates a drink breakdown, then entries of the same type are
    // grouped together and their raw liquid volumes are added.
    @MainActor
    @Test func hydrationTrackerCreatesDrinkBreakdownByType() async throws {
        let firstWater = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let secondWater = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 500, unit: .milliliters),
            date: Date()
        )
        
        let juice = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 300, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [firstWater, secondWater, juice],
            dailyGoal: goal
        )
        
        let breakdown = tracker.drinkBreakdown
        let waterBreakdown = breakdown.first { drinkBreakdown in
            drinkBreakdown.type == .water
        }
        let juiceBreakdown = breakdown.first { drinkBreakdown in
            drinkBreakdown.type == .juice
        }
        
        let waterTotal = waterBreakdown?.totalVolume.converted(to: .milliliters)
        let juiceTotal = juiceBreakdown?.totalVolume.converted(to: .milliliters)
        
        #expect(breakdown.count == 2)
        #expect(waterTotal?.value == 750)
        #expect(juiceTotal?.value == 300)
    }
    
    // Given drink entries for only one drink type, when the tracker creates a drink
    // breakdown, then drink types with no entries are left out of the result.
    @MainActor
    @Test func hydrationTrackerDrinkBreakdownExcludesEmptyDrinkTypes() async throws {
        let water = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [water],
            dailyGoal: goal
        )
        
        let breakdown = tracker.drinkBreakdown
        
        #expect(breakdown.count == 1)
        #expect(breakdown.first?.type == .water)
    }
    
    // MARK: - HydrationSnapshot
    
    @Test func hydrationSnapshotCalculatesProgress() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 500, unit: UnitVolume.milliliters),
            totalWaterVolume: Measurement(value: 500, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingVolume: Measurement(value: 1500, unit: UnitVolume.milliliters),
            remainingWaterVolume: Measurement(value: 1500, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.progress == 0.25)
    }
    
    @Test func hydrationSnapshotCapsProgressAtOne() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 2,
            totalVolume: Measurement(value: 2500, unit: UnitVolume.milliliters),
            totalWaterVolume: Measurement(value: 2500, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingVolume: Measurement(value: 0, unit: UnitVolume.milliliters),
            remainingWaterVolume: Measurement(value: 0, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.progress == 1)
    }
    
    @Test func hydrationSnapshotCalculatesWaterProgress() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            totalWaterVolume: Measurement(value: 89, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 200, unit: UnitVolume.milliliters),
            remainingVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            remainingWaterVolume: Measurement(value: 111, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.waterProgress == 0.445)
    }
    
    @Test func hydrationSnapshotWaterProgressIsUnknownWhenWaterVolumeIsUnknown() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            totalWaterVolume: nil,
            goalVolume: Measurement(value: 200, unit: UnitVolume.milliliters),
            remainingVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            remainingWaterVolume: nil,
            drinkBreakdown: []
        )
        
        #expect(snapshot.waterProgress == nil)
    }
    
    // MARK: - Formatters
    
    @Test func volumeFormatterFormatsWholeMilliliters() async throws {
        let formatter = await VolumeFormatter()
        let volume = Measurement(value: 477.2, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume) == "477 mL")
    }
    
    @Test func progressFormatterFormatsPercentage() async throws {
        let formatter = ProgressFormatter()
        
        #expect(formatter.percentageString(from: 0.25) == "25%")
    }
    
    // MARK: - HydrationSummaryViewData
    
    // Given a snapshot where total liquid and estimated water contribution differ,
    // when view data is created, then the main total uses raw liquid volume while
    // progress uses estimated hydration contribution.
    @MainActor
    @Test func hydrationSummaryViewDataUsesHydrationProgressNotRawLiquidProgress() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
            totalWaterVolume: Measurement(value: 890, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
            remainingWaterVolume: Measurement(value: 1110, unit: UnitVolume.milliliters),
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .juice,
                    totalVolume: Measurement(value: 1000, unit: UnitVolume.milliliters)
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(),
            progressFormatter: ProgressFormatter()
        )
        
        #expect(viewData.totalText == "Total liquid: 1000 mL")
        #expect(viewData.goalText == "Hydration goal: 2000 mL")
        #expect(viewData.remainingText == "Remaining hydration: 1110 mL")
        #expect(viewData.drinkCountText == "Drinks logged: 1")
        #expect(viewData.progressText == "45%")
        #expect(viewData.progressValue == 0.445)
        #expect(viewData.drinkBreakdownTexts == ["1000 mL of juice"])
    }
    
    // Given a snapshot with unknown estimated water contribution, when view data is
    // created, then hydration progress and remaining hydration are shown as unknown
    // rather than guessed.
    @MainActor
    @Test func hydrationSummaryViewDataHandlesUnknownHydrationProgress() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 250, unit: UnitVolume.milliliters),
            totalWaterVolume: nil,
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingVolume: Measurement(value: 1750, unit: UnitVolume.milliliters),
            remainingWaterVolume: nil,
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .other,
                    totalVolume: Measurement(value: 250, unit: UnitVolume.milliliters)
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(),
            progressFormatter: ProgressFormatter()
        )
        
        #expect(viewData.totalText == "Total liquid: 250 mL")
        #expect(viewData.remainingText == "Remaining hydration: Unknown")
        #expect(viewData.progressText == "Hydration progress unknown")
        #expect(viewData.progressValue == 0.0)
        #expect(viewData.drinkBreakdownTexts == ["250 mL of other"])
    }
}
