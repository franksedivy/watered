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
    
    @Test func drinkAmountFormatsMilliliters() {
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        #expect(amount.formatted == "250 ml")
    }
    
    @Test func drinkAmountFluidOunces() {
        let amount = DrinkAmount(value: 8, unit: .usFluidOunces)
        
        #expect(amount.formatted == "8 US fl oz")
    }
    
    @Test func drinkAmountConvertsImperialFluidOuncesToMilliliters() {
        let amount = DrinkAmount(value: 8, unit: .imperialFluidOunces)
        let volume = amount.volume.converted(to: .milliliters)
        
        #expect(Int(volume.value.rounded()) == 227)
    }
    
    @Test func drinkAmountDescriptionUsesFormattedAmount() {
        let amount = DrinkAmount(value: 250, unit: .milliliters)
        
        #expect(amount.description == "250 ml")
    }
    
    // MARK: - DrinkType

    @Test func drinkTypeWaterUsesFullHydrationContributionRatio() {
        #expect(DrinkType.water.hydrationContributionRule == HydrationContributionRule.ratio(1.0))
    }

    @Test func drinkTypeTeaUsesEstimatedHydrationContributionRatio() {
        #expect(DrinkType.tea.hydrationContributionRule == HydrationContributionRule.ratio(0.99))
    }

    @Test func drinkTypeJuiceUsesEstimatedHydrationContributionRatio() {
        #expect(DrinkType.juice.hydrationContributionRule == HydrationContributionRule.ratio(0.89))
    }

    @Test func drinkTypeCoffeeUsesEstimatedHydrationContributionRatio() {
        #expect(DrinkType.coffee.hydrationContributionRule == HydrationContributionRule.ratio(0.99))
    }

    @Test func drinkTypeBeerUsesDefaultAlcoholRule() {
        #expect(DrinkType.beer.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.05))
    }

    @Test func drinkTypeCiderUsesDefaultAlcoholRule() {
        #expect(DrinkType.cider.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.05))
    }

    @Test func drinkTypeWineUsesDefaultAlcoholRule() {
        #expect(DrinkType.wine.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.13))
    }

    @Test func drinkTypeSpiritsUsesDefaultAlcoholRule() {
        #expect(DrinkType.spirits.hydrationContributionRule == HydrationContributionRule.alcohol(defaultABV: 0.40))
    }

    @Test func drinkTypeOtherUsesUnknownHydrationContributionRule() {
        #expect(DrinkType.other.hydrationContributionRule == HydrationContributionRule.unknown)
    }
    
    // MARK: - DrinkEntry
    
    @Test func drinkEntryStoresTypeAmountAndDate() {
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
    
    // Given a drink entry created without explicit persistence metadata,
    // when the entry is initialised, then it receives default metadata ready
    // for persistence.
    @Test func drinkEntryCreatesManualMetadataByDefault() {
        let loggedDate = Date()
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: loggedDate
        )
        
        #expect(entry.id != UUID(uuidString: "00000000-0000-0000-0000-000000000000"))
        #expect(entry.loggedAt == loggedDate)
        #expect(entry.source == .manual)
        #expect(entry.createdAt <= Date())
        #expect(entry.updatedAt <= Date())
    }
    
    // Given two drink entries created without explicit identifiers, when their
    // IDs are compared, then each entry has a distinct identifier for persistence.
    @Test func drinkEntryCreatesDifferentIdentifiersByDefault() {
        let firstEntry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let secondEntry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        #expect(firstEntry.id != secondEntry.id)
    }
    
    // Given explicit metadata values from persistence, when a drink entry is
    // recreated, then the model preserves the metadata exactly.
    @Test func drinkEntryAcceptsExplicitPersistenceMetadata() {
        let id = UUID()
        let loggedDate = Date(timeIntervalSince1970: 1000)
        let createdAt = Date(timeIntervalSince1970: 2000)
        let updatedAt = Date(timeIntervalSince1970: 3000)
        
        let entry = DrinkEntry(
            id: id,
            type: .coffee,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: loggedDate,
            createdAt: createdAt,
            updatedAt: updatedAt,
            source: .manual,
        )
        
        #expect(entry.id == id)
        #expect(entry.date == loggedDate)
        #expect(entry.loggedAt == loggedDate)
        #expect(entry.createdAt == createdAt)
        #expect(entry.updatedAt == updatedAt)
        #expect(entry.source == .manual)
    }
    
    @Test func drinkEntryDescriptionIncludesTypeAndAmount() {
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        #expect(entry.description == "Water, 250 ml")
    }
    
    @Test func drinkEntryHydrationContributionVolumeKeepsFullWaterAmount() {
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == 250)
    }
    
    @Test func drinkEntryJuiceHydrationContributionVolumeUsesHydrationContributionRatio() {
        let entry = DrinkEntry(
            type: .juice,
            amount: DrinkAmount(value: 100, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == 89)
    }
    
    @Test func drinkEntryOtherHydrationContributionVolumeIsUnknown() {
        let entry = DrinkEntry(
            type: .other,
            amount: DrinkAmount(value: 250, unit: .milliliters),
            date: Date()
        )
        
        #expect(entry.hydrationContributionVolume == nil)
    }
    
    @Test func drinkEntryBeerHydrationContributionIsPositiveButReduced() {
        let entry = DrinkEntry(
            type: .beer,
            amount: DrinkAmount(value: 330, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == 165)
    }
    
    @Test func drinkEntrySpiritsHydrationContributionIsNegative() {
        let entry = DrinkEntry(
            type: .spirits,
            amount: DrinkAmount(value: 25, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == -75)
    }
    
    @Test func drinkEntryWineHydrationContributionIsNegative() {
        let entry = DrinkEntry(
            type: .wine,
            amount: DrinkAmount(value: 150, unit: .milliliters),
            date: Date()
        )
        
        let hydrationContributionVolume = entry.hydrationContributionVolume?.converted(to: .milliliters)
        
        #expect(hydrationContributionVolume?.value == -45)
    }
    
    // MARK: - AddDrinkDraft
    
    @Test func addDrinkDraftCreatesDrinkEntryFromSelectedValues() {
        let date = Date()
        
        let draft = AddDrinkDraft(
            drinkType: .water,
            volumeValue: 330,
            unit: .milliliters
        )
        
        let entry = draft.drinkEntry(date: date)
        
        #expect(entry.type == .water)
        #expect(entry.amount.value == 330)
        #expect(entry.amount.unit == .milliliters)
        #expect(entry.date == date)
    }
    
    @Test func addDrinkDraftPreservesSelectedUnitWhenCreatingDrinkEntry() {
        let draft = AddDrinkDraft(
            drinkType: .coffee,
            volumeValue: 8,
            unit: .imperialFluidOunces
        )
        
        let entry = draft.drinkEntry()
        
        #expect(entry.type == .coffee)
        #expect(entry.amount.value == 8)
        #expect(entry.amount.unit == .imperialFluidOunces)
    }
    
    // MARK: - PersistentDrinkEntry
    //
    // Given a drink entry with persistence metadata, when a persistent drink entry
    // is created from it, then the stored values use stable persistence identifiers.
    
    
    // MARK: - WateredStore
    
    @MainActor
    @Test func wateredStoresStartsWithoutNoDrinkEntries() {
        let store = WateredStore()
        
        #expect(store.entries.isEmpty)
    }
    
    @MainActor
    @Test func wateredStoredAddsDrinkEntry() {
        let entry = DrinkEntry(
            type: .water,
            amount: DrinkAmount(value: 330, unit: .milliliters),
            date: Date()
        )
        
        let store = WateredStore()
        
        store.addDrinkEntry(entry)
        
        #expect(store.entries.count == 1)
        #expect(store.entries.first?.type == .water)
        #expect(store.entries.first?.amount.value == 330)
        #expect(store.entries.first?.amount.unit == .milliliters)
    }
    
    // MARK: - HydrationTracker
    
    @Test func hydrationTrackerCalculatesTotalVolume() {
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
    
    @Test func hydrationTrackerCalculatesTotalHydrationVolume() {
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
        
        let totalWater = tracker.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalWater?.value == 339)
    }
    
    @Test func hydrationTrackerCalculatesRemainingHydrationVolume() {
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
        
        let remainingHydration = tracker.remainingHydrationVolume?.converted(to: .milliliters)
        
        #expect(remainingHydration?.value == 411)
    }
    
    @Test func hydrationTrackerHydrationContributionVolumeIsUnknownWhenEntryHydrationContributionVolumeIsUnknown() {
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
        
        #expect(tracker.totalHydrationVolume == nil)
        #expect(tracker.remainingHydrationVolume == nil)
    }
    @Test func hydrationTrackerCreatesSnapshot() {
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
    @Test func hydrationTrackerCreatesDrinkBreakdownByType() {
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
    @Test func hydrationTrackerDrinkBreakdownIncludesHydrationVolumeForWater() {
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
    @Test func hydrationTrackerDrinkBreakdownIncludesHydrationVolumeForJuice() {
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
    @Test func hydrationTrackerDrinkBreakdownIncludesTotalVolumeForOther() {
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
    @Test func hydrationTrackerDrinkBreakdownExcludesEmptyDrinkTypes() {
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
    @Test func hydrationTrackerTotalHydrationVolumeMatchesExistingContributionBehaviour() {
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
        let totalHydration = tracker.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalHydration?.value == 339)
    }
    @Test func hydrationTrackerCountsAlcoholInRawTotalAndHydrationContribution() {
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
        
        let totalVolume = tracker.totalVolume.converted(to: .milliliters)
        let totalHydrationVolume = tracker.totalHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalVolume.value == 980)
        #expect(totalHydrationVolume?.value == 620)
    }
    
    @Test func hydrationTrackerNegativeAlcoholContributionIncreasesRemainingHydration() {
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
        
        let totalHydrationVolume = tracker.totalHydrationVolume?.converted(to: .milliliters)
        let remainingHydrationVolume = tracker.remainingHydrationVolume?.converted(to: .milliliters)
        
        #expect(totalHydrationVolume?.value == -75)
        #expect(remainingHydrationVolume?.value == 575)
    }
    
    // MARK: - HydrationSnapshot
    @Test func hydrationSnapshotCalculatesHydrationProgress() {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: 89, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 200, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 111, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.hydrationProgress == 0.445)
        #expect(snapshot.clampedHydrationProgress == 0.445)
    }
    
    @Test func hydrationSnapshotHydrationProgressIsUnknownWhenHydrationContributionVolumeIsUnknown() {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
            totalHydrationVolume: nil,
            goalVolume: Measurement(value: 200, unit: UnitVolume.milliliters),
            remainingHydrationVolume: nil,
            drinkBreakdown: []
        )
        
        #expect(snapshot.hydrationProgress == nil)
        #expect(snapshot.clampedHydrationProgress == nil)
    }
    
    @Test func hydrationSnapshotKeepsActualNegativeProgressButClampsVisualProgress() {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 25, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: -75, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 2075, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.hydrationProgress == -0.0375)
        #expect(snapshot.clampedHydrationProgress == 0)
    }
    
    @Test func hydrationSnapshotKeepsActualProgressAboveOne() {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 2500, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: 2500, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 0, unit: UnitVolume.milliliters),
            drinkBreakdown: []
        )
        
        #expect(snapshot.hydrationProgress == 1.25)
        #expect(snapshot.clampedHydrationProgress == 1)
    }
    
    // MARK: - VolumeCalculation
    
    @Test func volumeCalculationConvertsMeasurementToBaseValue() {
        let volume = Measurement(value: 1, unit: UnitVolume.liters)
        
        #expect(VolumeCalculation.baseValue(from: volume) == 1000)
    }
    
    @Test func volumeCalculationCreatesMeasurementFromBaseValue() {
        let volume = VolumeCalculation.measurement(fromBaseValue: 750)
        
        #expect(volume.value == 750)
        #expect(volume.unit == VolumeCalculation.baseUnit)
    }
    
    // MARK: - Formatters
    
    @Test func volumeFormatterFormatsWholeMilliliters() {
        let formatter = VolumeFormatter(locale: Locale(identifier: "en_GB"))
        let volume = Measurement(value: 1000, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume, displayedAs: .milliliters) == "1000 ml")
    }
    
    @Test func volumeFormatterFormatsWholeUSFluidOunces() {
        let formatter = VolumeFormatter(locale: Locale(identifier: "en_GB"))
        let volume = Measurement(value: 1000, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume, displayedAs: .usFluidOunces) == "34 US fl oz")
    }
    
    @Test func volumeFormatterFormatsWholeImperialFluidOunces() {
        let formatter = VolumeFormatter(locale: Locale(identifier: "en_GB"))
        let volume = Measurement(value: 1000, unit: UnitVolume.milliliters)
        
        #expect(formatter.wholeNumberString(from: volume, displayedAs: .imperialFluidOunces) == "35 fl oz")
    }
    
    @Test func progressFormatterFormatsPercentage() {
        let formatter = ProgressFormatter()
        
        #expect(formatter.percentageString(from: 0.25) == "25%")
    }
    
    // MARK: - HydrationSummaryViewData
    
    // Given a snapshot where total liquid and estimated water contribution differ,
    // when view data is created, then the main total uses raw liquid volume while
    // progress uses estimated hydration contribution.
    @Test func hydrationSummaryViewDataUsesHydrationProgressNotRawLiquidProgress() {
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
        #expect(viewData.actualProgressValue == 0.445)
        #expect(viewData.visualProgressValue == 0.445)
        #expect(viewData.drinkBreakdownRows.first?.consumedText == "1000 ml of juice")
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: 89%")
    }
    
    // Given a snapshot with unknown estimated water contribution, when view data is
    // created, then hydration progress and remaining hydration are shown as unknown
    // rather than guessed.
    @Test func hydrationSummaryViewDataHandlesUnknownHydrationProgress() {
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
        #expect(viewData.actualProgressValue == nil)
        #expect(viewData.visualProgressValue == 0.0)
        #expect(viewData.drinkBreakdownRows.first?.consumedText == "250 ml of other")
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: Unknown")
    }
    
    // Given a supported display unit, when summary view data is created, then volume
    // strings are formatted using that unit without changing the underlying model values.
    @Test func hydrationSummaryViewDataUsesDisplayUnit() {
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
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: 100%")
    }
    
    // Given a drink breakdown with negative hydration contribution, when view data is
    // created, then hydration impact is shown as a negative percentage.
    @Test func hydrationSummaryViewDataFormatsNegativeHydrationImpactPercentage() {
        let snapshot = HydrationSnapshot(
            drinkCount: 1,
            totalVolume: Measurement(value: 50, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: -150, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 2150, unit: UnitVolume.milliliters),
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .spirits,
                    totalVolume: Measurement(value: 50, unit: UnitVolume.milliliters),
                    totalHydrationVolume: Measurement(value: -150, unit: UnitVolume.milliliters)
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(),
            progressFormatter: ProgressFormatter()
        )
        
        #expect(viewData.drinkBreakdownRows.first?.consumedText == "50 ml of spirits")
        #expect(viewData.drinkBreakdownRows.first?.hydrationImpactText == "Hydration impact: -300%")
    }
    
    // Given drink breakdown rows with different hydration contribution ratios, when
    // summary view data is created, then each row receives the expected semantic
    // hydration impact style.
    @Test func hydrationSummaryViewDataAssignsHydrationImpactStyles() {
        let snapshot = HydrationSnapshot(
            drinkCount: 4,
            totalVolume: Measurement(value: 0, unit: UnitVolume.milliliters),
            totalHydrationVolume: Measurement(value: 0, unit: UnitVolume.milliliters),
            goalVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            remainingHydrationVolume: Measurement(value: 2000, unit: UnitVolume.milliliters),
            drinkBreakdown: [
                DrinkBreakdown(
                    type: .water,
                    totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
                    totalHydrationVolume: Measurement(value: 100, unit: UnitVolume.milliliters)
                ),
                DrinkBreakdown(
                    type: .beer,
                    totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
                    totalHydrationVolume: Measurement(value: 50, unit: UnitVolume.milliliters)
                ),
                DrinkBreakdown(
                    type: .wine,
                    totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
                    totalHydrationVolume: Measurement(value: -30, unit: UnitVolume.milliliters)
                ),
                DrinkBreakdown(
                    type: .other,
                    totalVolume: Measurement(value: 100, unit: UnitVolume.milliliters),
                    totalHydrationVolume: nil
                )
            ]
        )
        
        let viewData = HydrationSummaryViewData(
            snapshot: snapshot,
            volumeFormatter: VolumeFormatter(),
            progressFormatter: ProgressFormatter()
        )
        
        #expect(viewData.drinkBreakdownRows[0].hydrationImpactStyle == .positive)
        #expect(viewData.drinkBreakdownRows[1].hydrationImpactStyle == .reduced)
        #expect(viewData.drinkBreakdownRows[2].hydrationImpactStyle == .negative)
        #expect(viewData.drinkBreakdownRows[3].hydrationImpactStyle == .unknown)
    }
}
