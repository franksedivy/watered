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

    @Test func drinkTypeWaterUsesFullHydrationContributionRatio() async throws {
        #expect(DrinkType.water.hydrationContributionRule == HydrationContributionRule.ratio(1.0))
    }

    @Test func drinkTypeTeaUsesEstimatedHydrationContributionRatio() async throws {
        #expect(DrinkType.tea.hydrationContributionRule == HydrationContributionRule.ratio(0.99))
    }

    @Test func drinkTypeJuiceUsesEstimatedHydrationContributionRatio() async throws {
        #expect(DrinkType.juice.hydrationContributionRule == HydrationContributionRule.ratio(0.89))
    }

    @Test func drinkTypeCoffeeUsesEstimatedHydrationContributionRatio() async throws {
        #expect(DrinkType.coffee.hydrationContributionRule == HydrationContributionRule.ratio(0.99))
    }

    @Test func drinkTypeBeerUsesDefaultAlcoholRule() async throws {
        #expect(DrinkType.beer.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.05))
    }

    @Test func drinkTypeCiderUsesDefaultAlcoholRule() async throws {
        #expect(DrinkType.cider.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.05))
    }

    @Test func drinkTypeWineUsesDefaultAlcoholRule() async throws {
        #expect(DrinkType.wine.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.13))
    }

    @Test func drinkTypeSpiritsUsesDefaultAlcoholRule() async throws {
        #expect(DrinkType.spirits.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.40))
    }

    @Test func drinkTypeOtherUsesUnknownHydrationContributionRule() async throws {
        #expect(DrinkType.other.hydrationContributionRule == HydrationContributionRule.unknown)
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
    
    @Test func drinkEntryHydrationContributionVolumeKeepsFullWaterAmount() async throws {
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = await entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == 250)
    }
    
    @Test func drinkEntryJuiceHydrationContributionVolumeUsesHydrationContributionRatio() async throws {
        let entry = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 100, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = await entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == 89)
    }
    
    @Test func drinkEntryOtherHydrationContributionVolumeIsUnknown() async throws {
        let entry = DrinkEntry(
            type: .other,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        #expect(await entry.hydrationContributionVolume == nil)
    }
    
    @Test func drinkEntryBeerHydrationContributionIsPositiveButReduced() async throws {
        let entry = DrinkEntry(
            type: .beer,
            amount: DrinkAmount(value: 330, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = await entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == 165)
    }
    
    @Test func drinkEntrySpiritsHydrationContributionIsNegative() async throws {
        let entry = DrinkEntry(
            type: .spirits,
            amount: DrinkAmount(value: 25, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = await entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == -75)
    }
    
    @Test func drinkEntryWineHydrationContributionIsNegative() async throws {
        let entry = DrinkEntry(
            type: .wine,
            amount: DrinkAmount(value: 150, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = await entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == -45)
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
    
    @Test func hydrationTrackerCalculatesTotalHydrationVolume() async throws {
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
        
        let totalWater = await tracker.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalWater?.value == 339)
    }
    
    @Test func hydrationTrackerCalculatesRemainingHydrationVolume() async throws {
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
        
        let remainingHydration = await tracker.remainingHydrationVolume?.converted(to: .milliliters)
        
        #expect(remainingHydration?.value == 411)
    }
    
    @Test func hydrationTrackerHydrationContributionVolumeIsUnknownWhenEntryHydrationContributionVolumeIsUnknown() async throws {
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
        
        #expect(await tracker.totalHydrationVolume == nil)
        #expect(await tracker.remainingHydrationVolume == nil)
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
        #expect(snapshot.totalHydrationVolume?.converted(to: .milliliters).value == 500)
        #expect(snapshot.goalVolume.converted(to: .milliliters).value == 2000)
        #expect(snapshot.remainingHydrationVolume?.converted(to: .milliliters).value == 1500)
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
    
    // Given water entries in the drink log, when the tracker creates a drink breakdown,
    // then the water breakdown reports the same value for raw liquid volume and
    // estimated hydration volume.
    @MainActor
    @Test func hydrationTrackerDrinkBreakdownIncludesHydrationVolumeForWater() async throws {
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
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [firstWater, secondWater],
            dailyGoal: goal
        )
        let breakdown = tracker.drinkBreakdown
        let waterBreakdown = breakdown.first { drinkBreakdown in
            drinkBreakdown.type == .water
        }
        
        let rawTotal = waterBreakdown?.totalVolume.converted(to: .milliliters)
        let hydrationTotal = waterBreakdown?.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(rawTotal?.value == 750)
        #expect(hydrationTotal?.value == 750)
    }
    
    // Given a juice entry in the drink log, when the tracker creates a drink breakdown,
    // then the juice breakdown reports full raw liquid volume and a lower estimated
    // hydration volume based on the juice water-content ratio.
    @MainActor
    @Test func hydrationTrackerDrinkBreakdownIncludesHydrationVolumeForJuice() async throws {
        let juice = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 300, unit: .milliliters),
            date: Date()
        )
        
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        
        let tracker = HydrationTracker(
            entries: [juice],
            dailyGoal: goal
        )
        let breakdown = tracker.drinkBreakdown
        let juiceBreakdown = breakdown.first { drinkBreakdown in
            drinkBreakdown.type == .juice
        }
        
        let rawTotal = juiceBreakdown?.totalVolume.converted(to: .milliliters)
        let hydrationTotal = juiceBreakdown?.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(rawTotal?.value == 300)
        #expect(hydrationTotal?.value == 267)
    }
    
    // Given an other drink entry in the drink log, when the tracker creates a drink
    // breakdown, then the raw liquid volume is still known but estimated hydration
    // volume remains unknown.
    @MainActor
    @Test func hydrationTrackerDrinkBreakdownIncludesTotalVolumeForOther() async throws {
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
        
        let breakdown = tracker.drinkBreakdown
        let otherBreakdown = breakdown.first { drinkBreakdown in
            drinkBreakdown.type == .other
        }
        
        let rawTotal = otherBreakdown?.totalVolume.converted(to: .milliliters)
        
        #expect(rawTotal?.value == 250)
        #expect(otherBreakdown?.totalHydrationVolume == nil)
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
    
    // Given drinks with known hydration contribution ratios, when the tracker calculates
    // total hydration volume, then it returns the same value as the old water-volume
    // calculation but uses the new hydration-contribution terminology.
    @Test func hydrationTrackerTotalHydrationVolumeMatchesExistingContributionBehaviour() async throws {
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
        let totalHydration = await tracker.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalHydration?.value == 339)
    }
    
    @Test func hydrationTrackerCountsAlcoholInRawTotalAndHydrationContribution() async throws {
        let water = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 500, unit: .milliliters),
            date: Date()
        )
        let beer = DrinkEntry(
            type: .beer,
            amount: DrinkAmount(value: 330, unit: .milliliters),
            date: Date()
        )
        let wine = DrinkEntry(
            type: .wine,
            amount: DrinkAmount(value: 150, unit: .milliliters),
            date: Date()
        )
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 2000, unit: .milliliters)
        )
        let tracker = HydrationTracker(
            entries: [water, beer, wine],
            dailyGoal: goal
        )
        
        let totalVolume = await tracker.totalVolume.converted(to: .milliliters)
        let totalHydrationVolume = await tracker.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalVolume.value == 980)
        #expect(totalHydrationVolume?.value == 620)
    }
    
    @Test func hydrationTrackerNegativeAlcoholContributionIncreasesRemainingHydration() async throws {
        let spirits = DrinkEntry(
            type: .spirits,
            amount: DrinkAmount(value: 25, unit: .milliliters),
            date: Date()
        )
        let goal = HydrationGoal(
            amount: DrinkAmount(value: 500, unit: .milliliters)
        )
        let tracker = HydrationTracker(
            entries: [spirits],
            dailyGoal: goal
        )
        
        let totalHydrationVolume = await tracker.totalHydrationVolume?.converted(to: .milliliters)
        let remainingHydrationVolume = await tracker.remainingHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalHydrationVolume?.value == -75)
        #expect(remainingHydrationVolume?.value == 575)
    }
    
    // MARK: - HydrationSnapshot
    @Test func hydrationSnapshotCalculatesHydrationProgress() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: 89, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 200, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 111, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.hydrationProgress == 0.445)
    }
    
    @Test func hydrationSnapshotHydrationProgressIsUnknownWhenHydrationContributionVolumeIsUnknown() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            totalHydrationVolume: nil,
            goalVolume: Measurement(value: 200, unit: UnitVolume.milliliters),
            remainingHydrationVolume: nil,
            drinkBreakdown: []
        )
        
        #expect(snapshot.hydrationProgress == nil)
    }
    
    // MARK: - VolumeCalculation
    
    @Test func volumeCalculationConvertsMeasurementToBaseValue() async throws {
        let volume = Measurement(value: 1, unit: UnitVolume.liters)
        
        #expect(VolumeCalculation.baseValue(from: volume) == 1000)
    }
    
    @Test func volumeCalculationCreatesMeasurementFromBaseValue() async throws {
        let volume = VolumeCalculation.measurement(fromBaseValue: 750)
        
        #expect(volume.value == 750)
        #expect(volume.unit == VolumeCalculation.baseUnit)
    }
    
    // MARK: - Formatters
    
    @Test func volumeFormatterFormatsWholeMilliliters() async throws {
        let formatter = await VolumeFormatter(locale: Locale(identifier: "en_GB"))
        let volume = Measurement(value: 1000, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume, displayedAs: .milliliters) == "1000 ml")
    }
    
    @Test func volumeFormatterFormatsWholeUSFluidOunces() async throws {
        let formatter = await VolumeFormatter(locale: Locale(identifier: "en_GB"))
        let volume = Measurement(value: 1000, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume, displayedAs: .usFluidOunces) == "34 US fl oz")
    }
    
    @Test func volumeFormatterFormatsWholeImperialFluidOunces() async throws {
        let formatter = await VolumeFormatter(locale: Locale(identifier: "en_GB"))
        let volume = Measurement(value: 1000, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume, displayedAs: .imperialFluidOunces) == "35 fl oz")
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
            totalHydrationVolume: Measurement(value: 890, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 1110, unit: UnitVolume.milliliters),
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .juice,
                    totalVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
                    totalHydrationVolume: Measurement(value: 890, unit: UnitVolume.milliliters)
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(),
            progressFormatter: ProgressFormatter()
        )
        
        #expect(viewData.totalText == "Total liquid: 1000 ml")
        #expect(viewData.goalText == "Hydration goal: 2000 ml")
        #expect(viewData.remainingText == "Remaining hydration: 1110 ml")
        #expect(viewData.drinkCountText == "Drinks logged: 1")
        #expect(viewData.progressText == "45%")
        #expect(viewData.progressValue == 0.445)
        #expect(viewData.drinkBreakdownRows.first?.consumedText == "1000 ml of juice")
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: 890 ml")
    }
    
    // Given a snapshot with unknown estimated water contribution, when view data is
    // created, then hydration progress and remaining hydration are shown as unknown
    // rather than guessed.
    @MainActor
    @Test func hydrationSummaryViewDataHandlesUnknownHydrationProgress() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 250, unit: UnitVolume.milliliters),
            totalHydrationVolume: nil,
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: nil,
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .other,
                    totalVolume: Measurement(value: 250, unit: UnitVolume.milliliters),
                    totalHydrationVolume: nil
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(),
            progressFormatter: ProgressFormatter()
        )
        
        #expect(viewData.totalText == "Total liquid: 250 ml")
        #expect(viewData.remainingText == "Remaining hydration: Unknown")
        #expect(viewData.progressText == "Hydration progress unknown")
        #expect(viewData.progressValue == 0.0)
        #expect(viewData.drinkBreakdownRows.first?.consumedText == "250 ml of other")
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: Unknown")
    }
    
    // Given a supported display unit, when summary view data is created, then volume
    // strings are formatted using that unit without changing the underlying model values.
    @MainActor
    @Test func hydrationSummaryViewDataUsesDisplayUnit() async throws {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .water,
                    totalVolume: Measurement(value: 1000, unit: UnitVolume.milliliters),
                    totalHydrationVolume: Measurement(value: 1000, unit: UnitVolume.milliliters)
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(locale: Locale(identifier: "en_GB")),
            progressFormatter: ProgressFormatter(),
            displayUnit: .usFluidOunces
        )
        
        #expect(viewData.totalText == "Total liquid: 34 US fl oz")
        #expect(viewData.goalText == "Hydration goal: 68 US fl oz")
        #expect(viewData.remainingText == "Remaining hydration: 34 US fl oz")
        #expect(viewData.drinkBreakdownRows.first?.consumedText == "34 US fl oz of water")
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: 34 US fl oz")
    }
    
    // MARK: - TodayDemoDrinkSource
    
    @MainActor
    @Test func todayDemoDrinkCreatesDrinkEntry() async throws {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let demoDrink = TodayDemoDrink(
            type: .water,
            amount: DrinkAmount(value: 300, unit: .milliliters)
        )
        
        let entry = demoDrink.entry(date: date)
        
        #expect(entry.type == .water)
        #expect(entry.amount.value == 300)
        #expect(entry.amount.unit == .milliliters)
        #expect(entry.date == date)
    }
    
    @MainActor
    @Test func todayDemoDrinkSourceContainsExpectedDefaultDrinks() async throws {
        let source = TodayDemoDrinkSource()
        let availableDrinks = source.availableDrinks
        
        #expect(availableDrinks.count == 9)
        
        #expect(availableDrinks.contains { drink in
            drink.type == .water && drink.amount.value == 250
        })
        
        #expect(availableDrinks.contains { drink in
            drink.type == .beer && drink.amount.value == 330
        })
        
        #expect(availableDrinks.contains { drink in
            drink.type == .spirits && drink.amount.value == 50
        })
    }
    
    @MainActor
    @Test func todayDemoDrinkSourceReturnsNilWhenNoDrinksAreAvailable() async throws {
        let source = TodayDemoDrinkSource(availableDrinks: [])
        let entry = source.randomEntry()
        
        #expect(entry == nil)
    }
    
    @MainActor
    @Test func todayDemoDrinkSourceCreatesEntryFromAvailableDrink() async throws {
        let date = Date(timeIntervalSinceReferenceDate: 0)
        let demoDrink = TodayDemoDrink(
            type: .coffee,
            amount: DrinkAmount(value: 200, unit: .milliliters)
        )
        let source = TodayDemoDrinkSource(availableDrinks: [demoDrink])
        
        let entry = source.randomEntry(date: date)
        
        #expect(entry?.type == .coffee)
        #expect(entry?.amount.value == 200)
        #expect(entry?.amount.unit == .milliliters)
        #expect(entry?.date == date)
    }
}
