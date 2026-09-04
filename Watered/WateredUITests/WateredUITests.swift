//
//  WateredUITests.swift
//  WateredUITests
//
//  Created by Frank Sedivy on 26/06/2026.
//

import XCTest

final class WateredUITests: XCTestCase {

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.

        // In UI tests it is usually best to stop immediately when a failure occurs.
        continueAfterFailure = false

        // In UI tests it’s important to set the initial state - such as interface orientation - required for your tests before they run. The setUp method is a good place to do this.
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    @MainActor
    func testAppLaunchesToTodayScreen() throws {
        // Purpose: Proves that Watered launches into the main Today sexperience
        //
        // Behavior:
        // This is intentionally a smoke test. It does not check layout, color,
        // typography, or exact copy. It only checks for the stable Today screen
        // accessibility identifier.
        let app = XCUIApplication()
        app.launch()
        
        let todayScreen = app.otherElements["todayScreen"]
        XCTAssertTrue(todayScreen.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testAddDrinkActionButtonExists() throws {
        // Purpose:
        // Proves that the Today screen exposes the add-drink action.
        //
        // Behavior:
        // This test only checks for the stable accessibility identifier on the
        // floating add-drink button. It does not care where the button sits visually.
        let app = XCUIApplication()
        app.launch()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testTappingAddDrinkActionShowsAddDrinkSheet() throws {
        // Purpose:
        // Proves that the floating add-drink action opens the temporary Add Drink flow.
        //
        // Behvaior:
        // This test checks the navigation from Today into the sheet. It does not add a
        // drink yet, so failure are easier to understand if sheet presentation breaks.
        let app = XCUIApplication()
        app.launch()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
    }
    
    @MainActor
    func testAddingDrinkUpdatesTodayTotalAmount() throws {
        // Purpose:
        // Proves that adding a drink updates the Today summary.
        //
        // Behvaior:
        // This test does not yet assert an exact amount.
        // It only checks that the total amount text changes away from the empty
        // starting value after a drink is added.
        let app = XCUIApplication()
        app.launch()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
        
        addDrinkSubmitButton.tap()
        
        let updatedTotalAmount = app.staticTexts["330 ml"]
        XCTAssertTrue(
            updatedTotalAmount.waitForExistence(timeout: 2),
            "Today should show the default Add Drink form submission as 330 ml"
        )
    }
    
    @MainActor
    func testAddingDrinkWithSelectedVolumeUpdatesTodayTotalAmount() throws {
        // Purpose:
        // Proves that the Add Drink form uses the selected volume, not only the
        // default form value.
        //
        // Behavior:
        // Opens Add Drink, adjusts the volume wheel from its default value to
        // 500 ml, submits the drink, and checks that Today shows the selected
        // amount
        let app = XCUIApplication()
        app.launch()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let volumePickerWheel = app.pickerWheels.firstMatch
        XCTAssertTrue(volumePickerWheel.waitForExistence(timeout: 2))
        
        volumePickerWheel.adjust(toPickerWheelValue: "500 ml")
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
        
        addDrinkSubmitButton.tap()
        
        let updatedTotalAmount = app.staticTexts["500 ml"]
        XCTAssertTrue(
            updatedTotalAmount.waitForExistence(timeout: 2),
            "Today should show the manually selected Add Drink volume as 500 ml"
        )
    }
    
    @MainActor
    func testAddingMultipleDrinksKeepsTodayUsable() throws {
        // Purpose: Proves that repeated drink additions do not break the Today flow
        //
        // Behvaior:
        // Each add goes through the same user path: open the sheet, tap the temporary
        // add button, return to Today. The test does not care which random drinks are
        // selected or waht exact totals are shown.
        let app = XCUIApplication()
        app.launch()
        
        for addDrinkAttempt in 1...3 {
            let addDrinkButton = app.buttons["addDrinkActionButton"]
            XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
            
            addDrinkButton.tap()
            
            let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
            XCTAssertTrue(addDrinkSubmitButton.waitForExistence(timeout: 2))
            
            addDrinkSubmitButton.tap()
            
            let totalAmountText = app.staticTexts["todayTotalAmountText"]
            XCTAssertTrue(
                totalAmountText.waitForExistence(timeout: 2),
                "Total amount should exist after add attempt \(addDrinkAttempt)"
            )
        }
    }
    
    @MainActor
    func testAddingRecentDrinkUpdatesTodayTotalAmount() throws {
        // Purpose:
        // Proves that a recent-drink pill submits its drink directly.
        //
        // Behavior:
        // Opens Add Drink, taps a complete recent-drink shortcut, and checks that
        // Today updates without using the checkmark submit button.
        let app = XCUIApplication()
        app.launch()
        
        let addDrinkButton = app.buttons["addDrinkActionButton"]
        XCTAssertTrue(addDrinkButton.waitForExistence(timeout: 2))
        
        addDrinkButton.tap()
        
        let recentDrinksRow = app.scrollViews["addDrinkRecentsScrollView"]
        XCTAssertTrue(recentDrinksRow.waitForExistence(timeout: 2))
        
        let firstRecentDrinkButton = recentDrinksRow.buttons.firstMatch
        XCTAssertTrue(firstRecentDrinkButton.waitForExistence(timeout: 2))
        
        firstRecentDrinkButton.tap()
        
        let addDrinkSubmitButton = app.buttons["addDrinkSubmitButton"]
        XCTAssertFalse(
            addDrinkSubmitButton.waitForExistence(timeout: 1),
            "Add Drink should close after directly submitting a recent drink"
        )
        
        let totalAmountText = app.staticTexts["todayTotalAmountText"]
        XCTAssertTrue(
            totalAmountText.waitForExistence(timeout: 2),
            "Today should still show the total amount after submitting a recent drink"
        )
    }

//    @MainActor
//    func testLaunchPerformance() throws {
//        // This measures how long it takes to launch your application.
//        measure(metrics: [XCTApplicationLaunchMetric()]) {
//            XCUIApplication().launch()
//        }
//    }
}
