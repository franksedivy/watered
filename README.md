# Watered

Watered is an iOS hydration tracker built as a learning project in Swift and SwiftUI.

The current focus is the core model layer: representing drinks, calculating intake, and keeping the code clean before building out the UI.

## Current Architecture

### LiquidUnit
Defines the volume units Watered supports and maps them to Foundation's `UnitVolume`.

### DrinkAmount
Represents an amount of liquid and exposes it as `Measurement<UnitVolume>`.

### DrinkType
Defines the type of drink, such as water, tea, coffee, juice, or other.

### DrinkEntry
Represents one logged drink, including its type, amount, and date.

### HydrationGoal
Represents the user's daily hydration target.

### HydrationTracker
Calculates total intake and remaining intake from drink entries and a daily goal.

### VolumeFormatter
Formats volume measurements for console output and early UI labels.

### ContentView
Currently acts as a temporary console demo while the model layer is being built.

## Current Design Principles

- Keep model types quiet and focused.
- Use Foundation's `Measurement<UnitVolume>` for volume handling.
- Keep formatting separate from calculations.
- Keep SwiftUI views lightweight.
- Add tests around model behavior as the app grows.
