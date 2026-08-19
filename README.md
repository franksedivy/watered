# Watered
Watered is an iOS hydration tracker built as a learning project in Swift and SwiftUI where i'm guided by Codex, but acitvely learn all the patterns and code that makes the app. It's not code vibing and letting Codex do all the work, it's codex playing a role of the tutor, guiding, explaining but not doing any of the hands on work, however a dood amount of automation by the GPT happens in the background to ensure documentation (such as this file) and tests are kept up to date and in sync with latest code.

The current focus is the core model layer: representing drinks, calculating intake, and keeping the code clean before building out the UI.

## Approach
The app is being built model-first.
That means we are starting with the core ideas of the app before making the UI more complex:
1. Represent liquid units
2. Represent drink amounts
3. Represent drink types
4. Represent one logged drink
5. Calculate total intake and remaining intake
6. Format that state for display
7. Show a simple SwiftUI summary view

The guiding idea is:
Models calculate > Snapshots summarise > View data prepares > Views display.

## High-Level App Flow
`WateredApp` starts the app.
`ContentView` currently creates temporary sample data.
`HydrationTracker` takes drink entries and a daily goal.
`HydrationSnapshot` captures the calculated hydration state.
`HydrationSummaryViewData` prepares display-ready text and progress value from the snapshot.
`VolumeFormatter` and `ProgressFormatter` turn raw model values into readable text and are used by `HydrationSummaryViewData`.
`ContentView` displays the prepared values on screen.

## Today Screen Semantics
The Today screen deliberately separates three related ideas:
1. Total liquid consumed
2. Hydration progress
3. Hydration contribution breakdown

The main amount shown on the Today screen is total liquid consumed.
For example, if the user drinks `1 L` of juice, the app should still say they drank `1 L` today.

The progress percentage is based on estimated water contribution toward the daily hydration target.
For example, if the daily target is `2 L` and the user drinks `1 L` of juice with an estimated water content ratio of `0.89`, the user has logged `1 L` of liquid but made about `44.5%` progress toward the hydration target.

The circular target visual uses the same hydration-progress meaning.
Its coloured segments represent each drink type's estimated water contribution toward the hydration target.
The unfilled part of the ring represents the remaining hydration target.

The drink breakdown list uses raw liquid volume grouped by drink type.
This means the list and ring show the same drink categories, but not necessarily the same values.

Example:
- list row: `1 L juice consumed`
- ring segment: `890 mL contribution toward hydration target`

The daily goal should be understood as a hydration target, not simply a raw liquid-volume target.

Alcohol handling is intentionally out of scope for `0.1`.
Alcohol may need a separate model later because it can affect hydration differently from simple physical water content.

## Current App State
The app currently has a simple read-only screen.
It can show:
- hydration progress percentage
- progress bar
- total liquid consumed
- daily hydration goal
- remaining estimated water contribution
- number of drinks logged

The data is still sample data created in code. There is no real add-drink button, persistence, HealthKit, Watch app, or user settings yet.

## Design Principles
- Keep models quiet and focused
- Keep formatting separate from calculations
- Keep SwiftUI views lightweight and focused on layout
- Use Foundation types where they fit, especially `Measurement<UnitVolume>`
- Avoid hard-coding anything
- Prefer small, buildable steps
- Add tests around model behaviour
- Refactor when the design starts to feel unclear

---

## Known Cleanup items
- `ContentView` still creates temporary sample data directly
- `HydrationSummaryViewData` now prepares display-ready values, but later this may move behind a view model or app state object
- Some tests currently use `await` because of Swift 6 actor-isolation warnings. We should understand and clean this up later.
- `WateredDebug` is still temporary and should either be removed or replaced with a deliberate debug scenario/logger

---

## Current Architecture

### WateredApp.swift
This is the app entry point.
It uses SwiftUI's `@main` structure and opens `ContentView` inside a `WindowGroup`.

Current responsibility:
- start the app
- choose the first screen

### ContentView.swift
This is the current SwiftUI screen.

Right now it creates sample hydration data directly in the view:
- one water entry
- one juice entry
- one daily goal
- one hydration tracker
- one hydration snapshot
- one hydration summary view data object

It then displays values from `HydrationSummaryViewData`.

Current responsibility:
- show the basic hydration summary screen
- prove that model data can appear in SwiftUI
- read prepared display values instead of formatting them directly

Future responsibility:
- mostly layout only
- eventually receive prepared display data from a view model or app state object

### LiquidUnit.swift
`LiquidUnit` defines the volume units Watered understands.

Current units:
- milliliters
- US fluid ounces
- imperial fluid ounces
It also maps each app unit to Foundation's `UnitVolume`.
This lets Watered use Apple's measurement system instead of hard-coded conversion numbers.

### DrinkAmount.swift
`DrinkAmount` represents an amount of liquid.
It stores:
- `value`
- `unit`

For example:
- `250 ml`
- `8 imp fl oz`

It exposes the amount as `Measurement<UnitVolume>`, which is the system-backed volume representation.
It also has a simple text description so it can be printed or logged in a readable way.

### DrinkBreakdown.swift
`DrinkBreakdown` represents a grouped drink total for one drink type.

It stores:

- drink type
- total raw liquid volume for that drink type

Example:

If today's entries are:

- Water, 250 ml
- Water, 500 ml
- Juice, 300 ml

The drink breakdown can represent:

- Water, 750 ml
- Juice, 300 ml

This lets the app move from individual logged drinks to simple grouped totals for the Today screen.

### DrinkType.swift
`DrinkType` defines what kind of drink was logged.

Current types:
- water
- coffee
- tea
- juice
- other
Each case has a readable string value for simple display and debugging.

### DrinkEntry.swift
`DrinkEntry` represents one logged drink.

It combines:
- drink type
- drink amount
- date

Example idea:
Water, 250 ml, logged today
This is the basic unit of hydration history.

### HydrationGoal.swift
`HydrationGoal` represents the user's target liquid intake for a day.
It currently wraps a `DrinkAmount`.
This is deliberately separate from `HydrationTracker` so that the goal is a named app concept, not just a loose number.

### HydrationTracker.swift
`HydrationTracker` is the core calculation object.

It owns:
- drink entries
- daily goal

It calculates:
- total raw liquid volume consumed
- total estimated water volume consumed
- remaining raw liquid volume
- remaining hydration volume
- a hydration snapshot
- drink breakdown grouped by drink type

It does not format text for the UI. It works with `Measurement<UnitVolume>` values.

### HydrationSnapshot.swift
`HydrationSnapshot` captures hydration state at one point in time.

It stores:
- drink count
- total raw liquid volume
- total estimated water volume
- goal volume
- remaining raw liquid volume
- remaining hydration volume
- drink breakdown grouped by drink type

It calculates one progress value:
- `hydrationProgress`, based on estimated water contribution

`hydrationProgress` is optional because some drink entries, such as `Other`, may not have a known water content ratio.

Example:

If the daily goal is `2000 ml` and the user logs `1000 ml` of juice:

- raw liquid volume is `1000 ml`
- estimated water volume is `890 ml`
- `hydrationProgress` is `0.445`, or 44.5%

This lets Watered distinguish between how much liquid was consumed and how much estimated water that liquid contains.

The snapshot is useful because the UI can read one summary object instead of repeatedly asking the tracker for separate values.

### HydrationSummaryViewData.swift
`HydrationSummaryViewData` prepares values for the hydration summary screen.

It takes:
- a `HydrationSnapshot`
- a `VolumeFormatter`
- a `ProgressFormatter`
- a display unit

It creates:
- total liquid text
- hydration goal text
- remaining hydration text
- drink count text
- hydration progress percentage text
- progress value for the progress bar
- drink breakdown text rows

The Today screen uses total raw liquid volume for the main consumed amount, but uses estimated water contribution for hydration progress and remaining hydration.

This keeps `ContentView` focused on layout instead of making it build strings or format numbers.

### VolumeFormatter.swift
`VolumeFormatter` turns volume measurements into readable text.

It can format a `Measurement<UnitVolume>` using any supported `LiquidUnit`.
The formatter converts the measurement through `LiquidUnit.foundationUnit` and then uses Foundation's measurement formatting to produce the display text.

Example outputs:
- `1000 ml`
- `34 US fl oz`
- `35 fl oz`

This keeps display formatting and display-unit choice out of the model layer.

### ProgressFormatter.swift
`ProgressFormatter` turns a progress value into a percentage string.

Example: `0.25` becomes `25%`
This keeps percentage display logic out of the SwiftUI view.

### WateredDebug.swift
This contains a temporary logging helper from the early learning phase.
It is not central to the current app architecture.

Future options:
- remove it
- or replace it with a deliberate debug scenario/logger
