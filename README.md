# Watered
Watered is an iOS hydration tracker built as a learning project in Swift and SwiftUI where i'm guided by Codex, but acitvely try to learn all the patterns and code that makes the app. It's not code vibing and letting Codex do all the work, it's codex playing a role of the tutor, guiding, explaining but not doing any of the hands on work.

The current focus is the core model layer: representing drinks, calculating intake, and keeping the code clean before building out the UI.

## Approach
The app is being built model-first.
That means we are starting with the core ideas of the app before amking the UI more complex:
1. Represent liquid units - `LiquidUnit.swift`
2. Represent drink amounts - `DrinkAmount.swift`
3. Represent drink types - `DrinkType.swift`
4. Represent one logged drink - `HydrationSnapshot.swift`
5. Calculate total intake and remaining intake - `HydrationTracker.swift`
6. Format that state for display - `ProgressFormatter.swift` / `VolumeFormatter.swift`
7. Show a simple SwiftUI summary view - `ContentView.swift`

The guiding idea is:
Models calculate > Formatters format > Views display.

## Design Principles
- Keep models quiet and focused
- Keep formatting separate form calculations
- Keep SwiftUI views lightweight and focused on layout
- Use Foundation types where they fit, especially 'Measurement<UnitVolume>'
- Avoid harcoding anything
- Prefer small, buildable steps
- Add tests around model behaviour
- Refactor when the design starts to feel unclear

---

## Known Cleanup items
- 'ContenView' still does some formatting directly
- A future 'HydrationSummaryViewData' type could prepare display-ready strings for the view.
- 'ProgressFormatter' exists, but the UI should be checked to make sure progress is actually shown
- Some tests currently use 'await' becuase of Swift 6 actor-isolation warnings. We should understand and clean this up later.

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
It then displays values from that snapshot.

Current responsibility:
- show the basic hydration summary screen
- prove that model data can appear in SwiftUI

Future responsibility:
- mostly layout only
- eventually receive prepared display data from a view model or view-data type

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
- total volume consumed
- remaining volume
- a hydration snapshot

It does not format text for the UI. It works with `Measurement<UnitVolume>` values.

### HydrationSnapshot.swift
`HydrationSnapshot` captures hydration state at one point in time.

It stores:
- drink count
- total volume
- goal volume
- remaining volume

It also calculates progress from `0` to `1`.

For example:
- `0.25` means 25%
- `1.0` means complete

The snapshot is useful because the UI can read one summary object instead of repeatedly asking the tracker for separate values.

### VolumeFormatter.swift
`VolumeFormatter` turns volume measurements into readable text.

Example: `477 mL`
This keeps display formatting out of the model layer.

### ProgressFormatter.swift
`ProgressFormatter` turns a progress value into a percentage string.

Example:`0.25` becomes `25%`
This keeps percentage display logic out of the SwiftUI view.

### WateredDebug.swift
This contains a temporary logging helper from the early learning phase.
It is not central to the current app architecture.

Future options:
- remove it
- or replace it with a deliberate debug scenario/logger
