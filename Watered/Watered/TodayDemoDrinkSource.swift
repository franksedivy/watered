//
//  TodayDemoDrinkSource.swift
//  Watered
//
//  Created by Frank Sedivy on 21/08/2026.
//

import Foundation

// A temporary drink template used by the 0.2 Today screen prototype.
struct TodayDemoDrink {
    let type: DrinkType
    let amount: DrinkAmount
    
    // MARK: - Entry Creation
    
    // Purpose:
    // Create a real DrinkEntry from this temporary demo drink.
    //
    // Input:
    // Accepts a Date so tests and prototype code can decide when the entry
    // should appear to have been logged.
    //
    // Returns:
    // A DrinkEntry using this demo drink's type and amount.
    func entry(date: Date = Date()) -> DrinkEntry {
        DrinkEntry(
            type: type,
            amount: amount,
            date: date
        )
    }
}

// Provides temporary random drinks for the 0.2 Today screen prototype.
struct TodayDemoDrinkSource {
    let availableDrinks: [TodayDemoDrink]
    
    // MARK: - Initialisation
    
    init(availableDrinks: [TodayDemoDrink] = TodayDemoDrinkSource.defaultDrinks) {
        self.availableDrinks = availableDrinks
    }
    
    // MARK: - Default Drinks
    
    // Purpose:
    // Defines the temporary drink pool used when the prototype adds a random drink.
    //
    // Returns:
    // A fixed list of demo drinks covering full, reduced and negative hydration
    // contribution behavioiur
    static let defaultDrinks: [TodayDemoDrink] = [
        TodayDemoDrink(type: .water, amount: DrinkAmount(value: 250, unit: .milliliters)),
        TodayDemoDrink(type: .water, amount: DrinkAmount(value: 300, unit: .milliliters)),
        TodayDemoDrink(type: .water, amount: DrinkAmount(value: 500, unit: .milliliters)),
        TodayDemoDrink(type: .coffee, amount: DrinkAmount(value: 200, unit: .milliliters)),
        TodayDemoDrink(type: .tea, amount: DrinkAmount(value: 250, unit: .milliliters)),
        TodayDemoDrink(type: .juice, amount: DrinkAmount(value: 250, unit: .milliliters)),
        TodayDemoDrink(type: .beer, amount: DrinkAmount(value: 330, unit: .milliliters)),
        TodayDemoDrink(type: .wine, amount: DrinkAmount(value: 150, unit: .milliliters)),
        TodayDemoDrink(type: .spirits, amount: DrinkAmount(value: 50, unit: .milliliters))
    ]
    
    // MARK: - Random Entry
    
    // Purpose:
    // Creates one random DrinkEntry from the available demo drinks.
    //
    // Input:
    // Accepts a Date so the caller can control the logged date.
    //
    // Returns:
    // A DrinkEntry when at least one demo drink is available.
    // Returns nil if the source has no available drinks.
    func randomEntry(date: Date = Date()) -> DrinkEntry? {
        guard let selectedDrink = availableDrinks.randomElement() else {
            return nil
        }
        
        return selectedDrink.entry(date: date)
    }
}
