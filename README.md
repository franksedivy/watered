# Watered
The current focus is the early Today screen UI: showing model-driven hydration data, testing basic interaction, and keeping the SwiftUI structure clean enough to evolve.

TLDR; Hydration tracker, learning project, model-first SwiftUI app.

## Current Status
Watered has a working core hydration model, native SwiftUI Today screen, and first Add Drink flow.

The app can create real `DrinkEntry` values from the UI, update Today, switch display units during a session, and show recent-drink shortcuts. Drink entries and settings are currently still in-memory only.

The current milestone is `0.4 Persistence`, focused on moving drink entries, display settings, and hydration goal settings into persistent app-owned state. This work is also shaping the data model for future iCloud sync and HealthKit export.

No HealthKit, widgets, Watch app, iCloud sync, or production analytics provider yet.

## Getting Started
1. Simply open the project in Xcode, no special setup required yet.
2. Use the main Watered app scheme to build and run the app.
3. Tests run as part of the Test build for now.

## Project Principles
Model-first, small commits, tests, clean separation of concerns.

## Documentation
Link to Wiki:
- [Architecture Overview](https://github.com/franksedivy/watered/wiki/Architecture-Overview)
- [Decision Log](https://github.com/franksedivy/watered/wiki/Decision-Log)
- [Drink Types & Contributions](https://github.com/franksedivy/watered/wiki/Drink-Types-And-Contributions)
- [Hydration Model](https://github.com/franksedivy/watered/wiki/Hydration-Model)
- [Research Notes](https://github.com/franksedivy/watered/wiki/Research-Notes)
- [Testing Approach](https://github.com/franksedivy/watered/wiki/Testing-Approach)

You can also read about the overall progress in my [Design Engineer's diary](https://github.com/franksedivy/watered/wiki/Design-Engineer's-Diary).

## Current Milestones & Releases
- `0.1` [Core-model](https://github.com/franksedivy/watered/milestone/1), [Release notes](https://github.com/franksedivy/watered/releases/tag/0.1_Core-model)
- `0.2` [Basic Today UI](https://github.com/franksedivy/watered/milestone/2), [Release notes](https://github.com/franksedivy/watered/releases/tag/0.2_Today-UI)
- `0.3` [Add Drink Flow](https://github.com/franksedivy/watered/milestone/3), [Release notes](https://github.com/franksedivy/watered/releases/tag/0.3_Add-drink)
- `0.4` [Persistence & Analytics](https://github.com/franksedivy/watered/milestone/4)
- `0.5` HealthKit integration & iOS27 upgrade
- `0.6` iOS Widget & Apple Watch App
- `0.7` Drinks catalogue & iCloud backup
- `0.8` UI Drink transitions
- `0.9` Hardening & Public beta
- `1.0` Bug fixes, AppStore release 
